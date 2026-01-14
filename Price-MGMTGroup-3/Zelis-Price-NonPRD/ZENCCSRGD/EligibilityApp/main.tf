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
        "zcmelgaad01",
        "zcmelgconfaad01",
        "zcmelgwad01"      
  ])
  custom_dns_records = {
        zcmelgaad01 = "zcmelgaad01.azurewebsites.net"
        zcmelgconfaad01 = "zcmelgconfaad01.azurewebsites.net"
        zcmelgwad01 = "zcmelgwad01.azurewebsites.net"  
   }
}

 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zcmelgaid01"
   resource_group_name = var.resource_group_name
   location            = var.location

   workspace_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/ZCCSRGD/providers/Microsoft.OperationalInsights/workspaces/Workspace-ZCCSRGD-EUS2"
   

   tags = merge(
    var.tags,
    {
     res-function = "AppInsights"
    }
  )
 }

data "azuread_group" "dba_admin" {
   display_name = var.azuread_administrator_group_name
 }
 module "mssql-server" {
   enabled = var.db_enabled
   #databases = var.database
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-mssql"
   

   name                = "zcmelgsqld01"
   resource_group_name = var.resource_group_name
   location            = var.location
    env = var.env
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

  name = "zcmelgkvd01"
  env = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  network_acls  = local.key_vault_network_acls
  tags = merge(
    var.tags,
    { 
      res-function = "KeyVault"
    }
  )
}

module "win-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"
   appservice_type = "web"
   env = var.env
   subnet_id       = var.subnet_id
   for_each = local.web_app_names
   name                                = each.key
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   resource_group_name = var.resource_group_name
   location            = var.location
   scm_ip_restriction = local.ip_whitelist
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