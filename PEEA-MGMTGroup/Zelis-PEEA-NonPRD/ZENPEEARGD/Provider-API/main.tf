  module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zenpapiaid01"
   resource_group_name = var.resource_group_name
   location            = var.location

   workspace_id = null

   tags = merge(
    var.tags,
    {
      res-function = "AppInsights"
    }
  )
 }
module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                = "zenpapistrd01"
  resource_group_name = var.resource_group_name
  location            = var.location
  env = var.env
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags = merge(
    var.tags,
    { 
      res-function = "StorageAccount"
    }
  )
}
 module "win-fun-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "function"
   subnet_id       = var.subnet_id
   env = var.env
   name                                = "zenpapifad01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = module.storage-account.name
   storage_account_id = module.storage-account.id
   storage_account_access_key = module.storage-account.primary_access_key
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
     application_insights_key = module.app-insights.instrumentation_key
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
 module "app-kv" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-key-vault"

  name = "zenpapikvd01"
  env = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  tags = merge(
    var.tags,
    { 
      res-function = "KeyVault"
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
     custom_domain_verification_id = var.custom_domain_verification_id
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled

   }
   
    module "CustomDNS_2"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
              providers = {
               aws = aws,
               azurerm = azurerm,
               azurerm.transversal = azurerm.certkvtsub
   }
     zone_name         = var.zone_name
     record_type = var.record_type
     custom_domain_verification_id = var.custom_domain_verification_id
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     application_name    = var.application_name
     host_name = "zepa-dev.zelis.com"
     resource_group_name = var.resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled

   }