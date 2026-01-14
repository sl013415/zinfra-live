locals {
 custom_dns_records = {
"zcmrbpptnaaq01"="zcmrbpptnaaq01.azurewebsites.net"
"zcmrbppctprtwaq01"="zcmrbppctprtwaq01.azurewebsites.net"
"zcmrbpbbaaq01"="zcmrbpbbaaq01.azurewebsites.net"
"zcmrbpersaaq01"="zcmrbpersaaq01.azurewebsites.net"
"zcmrbpfhaaq01"="zcmrbpfhaaq01.azurewebsites.net"
"zcmrbpmdraaq01"="zcmrbpmdraaq01.azurewebsites.net"
"zcmrbptrvaaq01"="zcmrbptrvaaq01.azurewebsites.net"
"zcmrbpmlnaaq01"="zcmrbpmlnaaq01.azurewebsites.net"
"zcmrbplkpwaq01"="zcmrbplkpwaq01.azurewebsites.net"
 }
  web_app_names = {
"zcmrbpptnaaq01" = "zcmrbpptnaiq01"
"zcmrbppctprtwaq01" = "zcmrbppctprtaiq01"
"zcmrbpbbaaq01" = "zcmrbpbbaiq01"
"zcmrbpersaaq01" = "zcmrbpersaiq01"
"zcmrbpfhaaq01" = "zcmrbpfhaiq01"
"zcmrbpmdraaq01" = "zcmrbpmdraiq01"
"zcmrbptrvaaq01" = "zcmrbptrvaiq01"
"zcmrbpmlnaaq01" = "zcmrbpmlnaiq01"
"zcmrbplkpwaq01"= "zcmrbplkpaiq01"
}
stg_acc_names = toset([
  "zcmrbpptnstrq01",
  "zcmrbplogstrq01",
  "zcmrbpstrq01"
 ])
 sql_servers = toset([
  "zcmrbpptnsqlq01",
  "zcmrbpsqlq01"
 ])
    custom_dns_rec = {
        zcmrbpbbaaq01 = "rbp-benchmark-broker-qa.zelis.com"
        zcmrbppctprtwaq01 = "rbp-precert-portal-qa.zelis.com"
        zcmrbplkpwaq01 = "rbp-lookup-qa.zelis.com"
        
    
   }
}

 module "app-insights" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-app-insights"
   for_each = local.web_app_names
   name                = each.value
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
module "storage-account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-storage"
  for_each = local.stg_acc_names
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
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

 module "servicebus_namespace" {
  enabled = var.db_enabled
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm_servicebus_namespace"
  name                = "zcmrbpadmsbq01"
   resource_group_name = var.resource_group_name
   location            = var.location
    tags = merge(
    var.tags,
    {
     res-function = "ServiceBusNameSpace"
     RBP_APP_Name = "rbp-admin-qa"
    }
  )
}
data "azuread_group" "dba_admin" {
   display_name = var.azuread_administrator_group_name
 }
 module "mssql-server" {
   enabled = var.db_enabled
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-mssql"
   for_each = local.sql_servers
   name                = each.key
   env = var.env
   resource_group_name = var.resource_group_name
   location            = var.location
   azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      res-function = "PAAS-SQL"
      RBP_APP_Name           = "portunus-qa-sqlsrvr01"
    }
  )
 }

module "win-web-app" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-windows-appservice"
  

   appservice_type = "web"
   subnet_id       = var.subnet_id
   for_each = local.web_app_names
   name                                = each.key
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   resource_group_name = var.resource_group_name
   location            = var.location
   storage_account_id = var.storage_account_id
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
     res-function = "WebApp"
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
  }


  module "win_web_app" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-windows-appservice"
  

   appservice_type = "function"
   subnet_id       = var.subnet_id
   name                                = var.application_name
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = "zcmrbpptnstrq01"
   storage_account_id = var.storage_account_id
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
     res-function = "WebApp"
    }
  )
 }
 module "Custom_DNS"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
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
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }

    module "app-kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-key-vault"

  name = "zcmrbpptnkvq01"
  env = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  tags = merge(
    var.tags,
    { 
      Function = "KeyVault"
    }
  )
}
 module "Custom_DNS_2"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = var.record_type
     for_each = local.custom_dns_rec
     application_name    = each.key
     custom_domain_verification_id = "${each.key}.azurewebsites.net"
     host_name = each.value
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }

   module "app_kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-key-vault"

  name = "zcmrbpkvq01"
  env = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  tags = merge(
    var.tags,
    { 
      Function = "KeyVault"
    }
  )
}