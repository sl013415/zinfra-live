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
# Create the Environment RG
# ===============================================
module "app-rg" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-resourcegroup"
  name     = "zenrpargp"
  location = var.location
  tags = merge(
    var.tags,
    {
      Function = "Resource Group"
    }
  )
}

module "Windows-appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "zenrpaapsp01"

  resource_group_name = module.app-rg.name
  location            = module.app-rg.location

  sku_name = "S2"
  os_type  = "Windows"
  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
      Function = "Windows App SVC Plan"
    }
  )
}
module "Linux-appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "zenrpaapsp02"

  resource_group_name = module.app-rg.name
  location            = module.app-rg.location

  sku_name = "B1"
  os_type  = "Linux"
  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

   tags = merge(
    var.tags,
    {
      Function = "Linux App SVC Plan"
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
   

   name                = "zenrpasqlp01"
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location

   ip_restriction = local.ip_whitelist

   # Create a managed identity for the Azure SQL Server
   identity_type            = var.identity_type
   azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      Function = "MS SQL Server"
    }
  )
 }
 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zenrpaaip01"
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location

   workspace_id = null

   tags = merge(
    var.tags,
    {
      Function = "App Insights"
    }
  )
 }
 module "win-linuxapp" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_linux_web_app"

   appservice_type = "web"
   subnet_id       = var.subnet_id

   name                                = "zenpyappwap01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name

   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
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
     python_version = "3.9"
     #current_stack  = "python"
   }

    tags = merge(
    var.tags,
    {
      Function = "Python Web App"
    }
  )
 }
  module "app-kv" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-key-vault"

  name = "zenrpakvp01"

  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  network_acls  = local.key_vault_network_acls
  tags = merge(
    var.tags,
    { 
      Function = "Key-Vault"
    }
  )
}
module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                = "zenrpastrp01"
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  account_tier = "Standard"
  network_rules = local.storage_account_network_rules


  tags = merge(
    var.tags,
    { 
      res-function = "Storage-Account"
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
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }