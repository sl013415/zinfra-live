


# module "app-insights" {
#    source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-app-insights"
 
#    name                = var.app_insights_name
#    resource_group_name = var.resource_group_name
#    location            = var.location

#    workspace_id = var.workspace_id

#    tags = merge(
#     var.tags,
#     {
#       resource-function = "AppInsights"
#     }
#   )
#  }
# module "storage-account" {
#   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-storage"
#   name                =var.storage_account_name
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   account_tier             = var.account_tier
#   account_replication_type = var.account_replication_type
#   env = var.env
#   is_hns_enabled = true


#   tags = merge(
#     var.tags,
#     { 
#      resource-function = "StorageAccount"
#     }
#   )
# }
 module "win_web_app" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   name                                = var.application_name
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
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

  application_stack = {
     dotnet_version  = "v8.0"
    current_stack  = "dotnet"
   }


    tags = merge(
    var.tags,
    {
     resource-function = "WebApp"
    }
  )
  depends_on = [ module.storage-account ]
 }
  module "Custom_DNS"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = var.record_type
     custom_domain_verification_id = "${var.application_name}.azurewebsites.net"
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }
    module "Custom_DNS_2"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = var.record_type
     host_name = "OONAuditApp.zelis.com"
     custom_domain_verification_id = "${var.application_name}.azurewebsites.net"
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }
    module "app-kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-key-vault"

  name = "zcmoonaakvp01"
  env = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  tags = merge(
    var.tags,
    { 
      resource-function = "KeyVault"
    }
  )
}

   module "app-config" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_app_configuration?ref=Feature/cosmosdb_cassandra_datacenter"

  name = "zcmoonaaacp01"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  tags = merge(
    var.tags,
    { 
      resource-function = "AppConfig"
    }
  )
}

 module "win_web_app2" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   name                                = var.api_application_name
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
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

  application_stack = {
     dotnet_version  = "v8.0"
    current_stack  = "dotnet"
   }


    tags = merge(
    var.tags,
    {
     resource-function = "WebApp"
    }
  )
  depends_on = [ module.storage-account ]
 }
  module "Custom_DNS3"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = var.record_type
     custom_domain_verification_id = "${var.api_application_name}.azurewebsites.net"
     application_name    = var.api_application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }
    module "Custom_DNS_4"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = var.record_type
     host_name = "OONAuditAPI.zelis.com"
     custom_domain_verification_id = "${var.api_application_name}.azurewebsites.net"
     application_name    = var.api_application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }