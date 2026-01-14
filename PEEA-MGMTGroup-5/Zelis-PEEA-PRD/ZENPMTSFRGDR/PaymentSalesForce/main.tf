
locals {
fn_app_names = {
"zenpmtfesffadr01" = "zenpmtfesfstrdr01"
"zenpmtbesffadr01" = "zenpmtbesfstrdr01"
}

}

module "app-rg" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-resourcegroup"
  name     = var.resource_group_name
  location = var.location
  tags = merge(
    var.tags,
    {
      res-function = "ResourceGroup"
    }
  )
}

 module "app-insights" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-app-insights"

   name                =  var.app_insights_name
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location

   workspace_id = var.workspace_id

   tags = merge(
    var.tags,
    {
      res-function = "AppInsights"
    }
  )
 }

module "storage-account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-storage"

  for_each = local.fn_app_names
  name                                = each.value
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env
  tags = merge(
    var.tags,
    { 
      res-function = "StorageAccount"
    }
  )
}
module "storage_account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-storage"

  name                                = var.storage_account_name 
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env
  tags = merge(
    var.tags,
    { 
      res-function = "StorageAccount"
    }
  )
}

    module "app-kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-key-vault"

  name = var.key_vault_name
  env = var.env
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  tags = merge(
    var.tags,
    { 
      res-function = "KeyVault"
    }
  )
}

 module "win-fun-app" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-windows-appservice"

   appservice_type = "function"
   subnet_id       = var.subnet_id
   for_each = local.fn_app_names
   name                                = each.key
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = each.value
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
   storage_account_id = module.storage_account.id
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
   module "CustomDNS"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
              providers = {
               aws = aws,
               azurerm = azurerm,
               azurerm.transversal = azurerm.certkvtsub
   }
     zone_name         = var.zone_name
     record_type = var.record_type
     for_each = local.fn_app_names
     application_name    = each.key
     custom_domain_verification_id = "${each.key}.azurewebsites.net"
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     resource_group_name = module.app-rg.name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert  = var.cert_enabled
   }

   module "CustomDNS_Frontend"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
              providers = {
               aws = aws,
               azurerm = azurerm,
               azurerm.transversal = azurerm.certkvtsub
   }
     zone_name         = var.zone_name
     host_name = "pepr-fe.zelis.com"
     record_type = var.record_type
     application_name    = "zenpmtfesffadr01"
     custom_domain_verification_id = "zenpmtfesffadr01.azurewebsites.net"
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     resource_group_name = module.app-rg.name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert  = var.cert_enabled
   }

   module "CustomDNS_Backend"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
              providers = {
               aws = aws,
               azurerm = azurerm,
               azurerm.transversal = azurerm.certkvtsub
   }
     zone_name         = var.zone_name
     host_name = "pepr-be.zelis.com"
     record_type = var.record_type
     application_name    = "zenpmtbesffadr01"
     custom_domain_verification_id = "zenpmtbesffadr01.azurewebsites.net"
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     resource_group_name = var.resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert  = var.cert_enabled
   }