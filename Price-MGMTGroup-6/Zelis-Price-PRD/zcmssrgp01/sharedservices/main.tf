locals {
fn_app_names = toset([
"zcmfassclfap01",
"zcmfassbmfap01",
"zcmfassdrgfap01",
"zcmfassdrgfap02"

 ]) 

app_insights_names = toset([
  "zcmfassclaip01",
  "zcmfassbmaip01",
  "zcmiassutaip01",
  "zcmfassdrgaip01"
 ]) 
}

 module "app-insights" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-app-insights"
   for_each = local.app_insights_names
   name                = each.key
   resource_group_name = var.resource_group_name
   location            = var.location

   workspace_id = var.workspace_id
  

   tags = merge(
    var.tags,
    {
     resource-function = "AppInsights"
    }
  )
 }

module "win-web-app" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   name                                = var.application_name
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   resource_group_name = var.resource_group_name
   location            = var.location
   storage_account_id =  var.storage_account_id
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


  module "win_fn_app" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-windows-appservice"
   appservice_type = "function"
   subnet_id       = var.subnet_id
   for_each = local.fn_app_names
   name                                = each.key
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = var.storage_account_name
   storage_account_id =  var.storage_account_id
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
 }
   module "CustomDNS"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
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

  name = "zcmfassdrgkvp01"
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
module "storage-account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-storage"
  name                ="zcmsssamrfstrp01"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env
  is_hns_enabled = true


  tags = merge(
    var.tags,
    { 
     resource-function = "StorageAccount"
    }
  )
}
 module "app-config" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_app_configuration"

  name = "zcmssacp01"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  virtual_network_name = "zcmvnnetp01"
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  subnet_name = "PaaSApp-AppConfig-Net"
  tags = merge(
    var.tags,
    { 
      resource-function = "AppConfig"
    }
  )
}
module "app_kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-key-vault"

  name = "zcmfasskvp01"
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
module "storage_account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-storage"
  name                ="zcmssstrp02"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env
  is_hns_enabled = true


  tags = merge(
    var.tags,
    { 
     resource-function = "StorageAccount"
    }
  )
}
data "azuread_group" "dba_admin" {
  display_name = var.azuread_administrator_group_name
}
module "mssql-server" {
  enabled                  = var.db_enabled
  source                   = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-mssql"
  name                     ="zcmsssqlp01"
  env                      = var.env
  resource_group_name      = var.resource_group_name
  location                 = var.location
  azuread_administrator_id = data.azuread_group.dba_admin.object_id

  tags = merge(
    var.tags,
    {
      resource-function = "PAAS-SQL"
      
    }
  )
}