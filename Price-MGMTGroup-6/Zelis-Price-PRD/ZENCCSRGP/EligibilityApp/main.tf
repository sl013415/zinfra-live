locals {
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

  web_app_names = toset([
        "zcmelgaap01",
        "zcmelgconfaap01",
        "zcmelgwap01"      
  ])
  custom_dns_records = {
        zcmelgaap01 = "20.22.102.82"
        zcmelgconfaap01 = "20.22.102.82"
        zcmelgwap01 = "20.22.102.82"
    
   }
}

 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zcmelgaip01"
   resource_group_name = var.resource_group_name
   location            = var.location

   workspace_id = "/subscriptions/208d9d5e-b1ba-42e2-9dcf-a3ac58050bc9/resourceGroups/zccsrgp/providers/Microsoft.OperationalInsights/workspaces/zenccslawsp01"
   

   tags = merge(
    var.tags,
    {
     res-function = "AppInsights"
    }
  )
 }
# module "storage-account" {
#   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

#   name                = "zcmrbplogstru01"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   account_tier = "Standard"
#   network_rules = local.storage_account_network_rules


#   tags = merge(
#     var.tags,
#     { 
#      res-function = "StorageAccount"
#     }
#   )
# }

#  module "servicebus_namespace" {
#   enabled = var.db_enabled
#   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_servicebus_namespace"
#   name                = "zcmrbpadmsbu01"
#    resource_group_name = var.resource_group_name
#    location            = var.location
#     tags = merge(
#     var.tags,
#     {
#      res-function = "ServiceBusNameSpace"
#     }
#   )
# }
data "azuread_group" "dba_admin" {
   display_name = var.azuread_administrator_group_name
 }
 module "mssql-server" {
   enabled = var.db_enabled
   #databases = var.database
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-mssql"
   

   name                = "zcmelgsqlp01"
   resource_group_name = var.resource_group_name
   location            = var.location

   ip_restriction = local.ip_whitelist

   # Create a managed identity for the Azure SQL Server
   #identity_type            = var.identity_type
   azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      res-function = "PAAS-SQL"
    }
  )
 }

  module "app-kv" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-key-vault"

  name = "zcmelgkvp01"

  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  network_acls  = local.key_vault_network_acls
  tags = merge(
    var.tags,
    { 
      Function = "KeyVault"
    }
  )
}

module "win-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"
   appservice_type = "web"
   subnet_id       = var.subnet_id
   for_each = local.web_app_names
   name                                = each.key
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   resource_group_name = var.resource_group_name
   location            = var.location
   scm_ip_restriction = local.ip_whitelist
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