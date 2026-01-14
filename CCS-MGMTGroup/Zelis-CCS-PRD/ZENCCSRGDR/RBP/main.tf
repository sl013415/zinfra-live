# data "azurerm_client_config" "current" {}
# module "network_restriction_policy"{
#   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//network_restriction"
#   env = var.env
#   subscriptionid = data.azurerm_client_config.current.subscription_id
# }
locals {
  # ip_whitelist = module.network_restriction_policy.ip_whitelist
  # subnet_list = concat(module.network_restriction_policy.wvd_subnets , module.network_restriction_policy.iaas_subnets )
  # vnet_integrated_whitelist = {

  # for item in local.subnet_list  : item.name => {

  #   action = "Allow"

  #   virtual_network_subnet_id = item.id

# }
#   }
# allowed_ip_list = {for k, v in local.ip_whitelist : k => {
#    #ip_address = trimsuffix(v.ip_address, "/32")
#  ip_address =v.ip_address
#  action = v.action
#  priority = v.priority
#  } 
#  }
# webapp_network_restriction = merge(local.vnet_integrated_whitelist , local.allowed_ip_list)
# subnet_ids = [
#   for subnet in local.subnet_list: 
# subnet.id

# ]
# ip_rules = [ for k,v in  local.ip_whitelist : trimsuffix(v.ip_address, "/32")]
#   key_vault_network_acls = {
#     bypass                     = "AzureServices"
#     default_action             = "Deny"
#     ip_rules                   = local.ip_rules
#     virtual_network_subnet_ids =  local.subnet_ids
#   }
#   storage_account_network_rules = {
#     bypass                     = ["AzureServices"]
#     default_action             = "Deny"
#     ip_rules                   = local.ip_rules
#     subnet_ids = local.subnet_ids
 # }
  
 custom_dns_records = {
"zcmrbpptnaadr01"="zcmrbpptnaadr01.azurewebsites.net"
"zcmrbppctprtwadr01"="zcmrbppctprtwadr01.azurewebsites.net"
"zcmrbpbbaadr01"="zcmrbpbbaadr01.azurewebsites.net"
"zcmrbpersaadr01"="zcmrbpersaadr01.azurewebsites.net"
"zcmrbpfhaadr01"="zcmrbpfhaadr01.azurewebsites.net"
"zcmrbpmdraadr01"="zcmrbpmdraadr01.azurewebsites.net"
"zcmrbptrvaadr01"="zcmrbptrvaadr01.azurewebsites.net"
"zcmrbpmlnaadr01"="zcmrbpmlnaadr01.azurewebsites.net"
"zcmrbplkpwadr01" = "zcmrbplkpwadr01.azurewebsites.net"
 }
  app_insight_names =toset([
"zcmrbpptnaidr01",
"zcmrbppctprtaidr01",
"zcmrbpbbaidr01",
"zcmrbpersaidr01",
"zcmrbpfhaidr01",
"zcmrbpmdraidr01",
"zcmrbptrvaidr01",
"zcmrbpmlnaidr01",
"zcmrbppctadmaidr01",
"zcmrbplkpaidr01"
])
stg_acc_names = toset([
  "zcmrbpptnstrdr01",
  "zcmrbplogstrdr01"
 ])
 sql_servers = toset([
  "zcmrbpptnsqldr01",
  "zcmrbpsqldr01"
 ])
}

 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"
   for_each = local.app_insight_names
   name                = each.key
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
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"
  for_each = local.stg_acc_names
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier = "Standard"
  account_replication_type = var.account_replication_type
  env = var.env


  tags = merge(
    var.tags,
    { 
     res-function = "StorageAccount"
    }
  )
}

 

module "win-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"
   #?ref=feature/webapp_module"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   for_each = local.custom_dns_records
   name                                = each.key
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   resource_group_name = var.resource_group_name
   location            = var.location
   env = var.env
   storage_account_id = var.storage_account_id
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
  }


  module "win_web_app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"
   #?ref=feature/webapp_module"

   appservice_type = "function"
   subnet_id       = var.subnet_id
   name                                = var.application_name
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = "zcmrbppctadmaadr01"
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
 module "Custom_DNS"{
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
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }

    module "app-kv" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-key-vault"

  name = "zcmrbpptnkvdr01"
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

module "servicebus_namespace" {
  enabled = var.db_enabled
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_servicebus_namespace"
  name                = "zcmrbpadmsbdr01"
   resource_group_name = var.resource_group_name
   location            = var.location
    tags = merge(
    var.tags,
    {
     res-function = "ServiceBusNameSpace"
    }
  )
}
data "azuread_group" "dba_admin" {
   display_name = var.azuread_administrator_group_name
 }
 module "mssql-server" {
   enabled = var.db_enabled
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-mssql"
   for_each = local.sql_servers
   env = var.env
   name                = each.key
   resource_group_name = var.resource_group_name
   location            = var.location
   azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      res-function = "PAAS-SQL"
    }
  )
 }