#Storage Account
 module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env

  tags = merge(
    var.tags,
    { 
      res-function = "StorageAccount"
    }
  )
}

module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = var.app_insights_name
   resource_group_name = var.resource_group_name
   location            = var.location
   workspace_id = var.workspace_id

   tags = merge(
    var.tags,
    {
      res-function = "AppInsights"
    }
  )
 }

module "win-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   env = var.env
   name                                = var.win_web_app_name
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   resource_group_name = var.resource_group_name
   location            = var.location
   storage_account_id = module.storage-account.id
   ip_restriction = {
     "LZ Subnet" = {
       priority                  = 200
       action                    = "Allow"
       virtual_network_subnet_id = var.lz_subnet_id
     },
     
       "LZ DR Subnet" = {
       priority                  = 210
       action                    = "Allow"
       virtual_network_subnet_id = var.lz_DR_subnet_id
     }
   }
   app_settings = {
     "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app-insights.instrumentation_key
   }
  application_stack = {
    dotnet_version  = "v6.0"
    current_stack  = "dotnet"
   }
    tags = merge(
    var.tags,
    {
      res-function = "WebApp"
    }
  )
 }

 module "win-fun-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "function"
   subnet_id       = var.subnet_id
   env = var.env
   name                                = var.win_fun_app_name
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = module.storage-account.name
   storage_account_id = module.storage-account.id
   resource_group_name = var.resource_group_name
   location            = var.location
   ip_restriction = {
     "LZ Subnet" = {
       priority                  = 200
       action                    = "Allow"
       virtual_network_subnet_id = var.lz_subnet_id
     },
      "LZ DR Subnet" = {
       priority                  = 210
       action                    = "Allow"
       virtual_network_subnet_id = var.lz_DR_subnet_id
     }
   }
app_settings = {
     "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app-insights.instrumentation_key
   }
   application_stack = {
     dotnet_version = "v6.0"
    current_stack  = "dotnet"
   }

    tags = merge(
    var.tags,
    {
      res-function = "FunctionApp"
    }
  )
 }

 module "lin-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_linux_web_app"

   appservice_type = "web"
   subnet_id       = var.lin_subnet_id
   name                                = var.lin_web_app_name
   appservice_plan_name                =  var.lin_asp_name
   appservice_plan_resource_group_name =  var.lin_asp_rg_name
   storage_account_id = module.storage-account.id
   resource_group_name = var.resource_group_name
   location            = var.location
   env = var.env
   ip_restriction = {
     "LZ Subnet" = {
       priority                  = 200
       action                    = "Allow"
       virtual_network_subnet_id = var.lz_subnet_id
     },
       "LZ DR Subnet" = {
       priority                  = 210
       action                    = "Allow"
       virtual_network_subnet_id = var.lz_DR_subnet_id
     }
   }
app_settings = {
     "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app-insights.instrumentation_key
   }
  application_stack = {
     node_version  = "20-lts"
    current_stack  = "node"
   }
    tags = merge(
    var.tags,
    {
     res-function = "WebApp"
    }
  )
 }

   module "CustomDNS"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = var.record_type
     for_each = local.custom_dns_records
     application_name    = each.key
     custom_domain_verification_id = each.value
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
     
     depends_on = [ 
      module.win-web-app,
      module.win-fun-app
      ]
  }

  
module "CustomDNS2"{
    source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
    providers = {
            aws = aws,
            azurerm = azurerm,
            azurerm.transversal = azurerm.certkvtsub
    }
    zone_name         = var.zone_name
    record_type = var.record_type
    custom_domain_verification_id =  "zcmiarfewad01.azurewebsites.net"
    application_name    = "zcmiarfewad01"
    resource_group_name = var.resource_group_name
    appservice_plan_name                =  var.lin_asp_name
    appservice_plan_resource_group_name =  var.lin_asp_rg_name
    shared_key_vault_name = var.shared_key_vault_name
    shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
    wildcard_cert_name = var.wildcard_cert_name
    new_cert = var.cert_enabled

    depends_on = [ 
      module.lin-web-app
    ]
}

