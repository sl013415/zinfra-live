locals {
  #module_repository         = "https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git"
  ip_whitelist = jsondecode(file("${path.module}/static/ip_whitelist.json"))

  allowed_ip_list = [for k, v in local.ip_whitelist : trimsuffix(v.ip_address, "/32") if v.action == "Allow"]
  key_vault_network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = local.allowed_ip_list
    virtual_network_subnet_ids = null # [var.subnet_id] Subnet requires service endpoints (SubnetsHaveNoServiceEndpointsConfigured)
  }
  storage_account_network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = local.allowed_ip_list
    subnet_ids = null # [var.subnet_id] Subnet requires service endpoints (SubnetsHaveNoServiceEndpointsConfigured)
  }
}
#



 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "ZENZAPPAIP01"
   resource_group_name = var.resource_group_name
   location            = var.location

   workspace_id = null

   tags = merge(
    var.tags,
    {
      Function = "App Insights"
    }
  )
 }

module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                = "zenzappstrp01"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier = "Standard"
  network_rules = local.storage_account_network_rules
  # containers = [
  #   {
  #     name        = "tfstate",
  #     access_type = "container"
  #   }
  # ]

  tags = merge(
    var.tags,
    { 
      Function = "ZAPP Storage Account"
    }
  )
}

module "win-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp01/providers/Microsoft.Network/virtualNetworks/zenpevnnetp01/subnets/PaaSApp-Integration-Net-PRD"

   name                                = "ZENZAPPWAP02"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   #storage_account_name = module.storage-account.name
   resource_group_name = var.resource_group_name
   location            = var.location
   scm_ip_restriction = local.ip_whitelist
   ip_restriction = {
     "LZ Subnet" = {
       priority                  = 200
       action                    = "Allow"
       virtual_network_subnet_id = var.lz_subnet_id
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
      Function = "ZAPP windows Web App"
    }
  )
 }
module "cosmosdb_account" {
  enabled = var.db_enabled
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_cosmosdb_account"
  name                = "zenzappcosp01"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind = var.kind
  tags = merge(
    var.tags,
    {
      Function = "ZAPP Cosmos DB"
    }
  )
}


 module "web-linuxapp" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_linux_web_app"

   appservice_type = "web"
   subnet_id       = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp01/providers/Microsoft.Network/virtualNetworks/zenpevnnetp01/subnets/PaaSApp-Integration-Net-PRD-Linux"

   name                                = "ZENZAPPWAP01"
   appservice_plan_name                = "ZENPEEAASPP02"
   appservice_plan_resource_group_name = var.appservice_plan_resource_group_name

   resource_group_name = var.resource_group_name
   location            = var.location
   #zone_name           = var.zone_name
   scm_ip_restriction = local.ip_whitelist
   ip_restriction = {
     "LZ Subnet" = {
       priority                  = 200
       action                    = "Allow"
       virtual_network_subnet_id = var.lz_subnet_id
     }
   }

   app_settings = {
     "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app-insights.instrumentation_key
   }

   application_stack = {
     node_version  = "16-lts"
     #current_stack  = "python"
   }

    tags = merge(
    var.tags,
    {
      Function = "ZAPP Linux Web App"
    }
  )
 }


 module "static_site" {
  enabled = var.db_enabled
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_static_site"
  name                = "ZENZAPPSWAP01"
  resource_group_name = var.resource_group_name
  location            = var.location
   tags = merge(
    var.tags,
    {
      Function = "ZAPP Static Web App"
    }
  )
}

 module "CustomDNS2"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = "A"
     custom_domain_verification_id ="20.22.102.76"
     application_name    = "zenzappwap02"
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
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
     custom_domain_verification_id = var.custom_domain_verification_id
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  "ZENPEEAASPP02"
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }