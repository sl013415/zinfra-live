
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
fn_app_names = {
"zenpmtfesffad01" = "zenpmtfesfstrd01"
"zenpmtbesffad01" = "zenpmtbesfstrd01"
}
 custom_dns_records = {
"zenpmtfesffad01" = "zenpmtfesffad01.azurewebsites.net"
"zenpmtbesffad01" = "zenpmtbesffad01.azurewebsites.net"

 }
}

module "app-rg" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-resourcegroup"
  name     = "ZENPMTSFRGD"
  location = var.location
  tags = merge(
    var.tags,
    {
      res-function = "ResourceGroup"
    }
  )
}

 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zenpmtsfaid01"
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
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  for_each = local.fn_app_names
  name                                = each.value
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  account_tier = "Standard"
  network_rules = local.storage_account_network_rules


  tags = merge(
    var.tags,
    { 
      res-function = "StorageAccount"
    }
  )
}
module "storage_account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                                = "zenpmtsfstrd01"
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  account_tier = "Standard"
  network_rules = local.storage_account_network_rules


  tags = merge(
    var.tags,
    { 
      res-function = "StorageAccount"
    }
  )
}

    module "app-kv" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-key-vault"

  name = "zenpmtsfkvd01"

  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
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

 module "win-fun-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "function"
   subnet_id       = var.subnet_id
   for_each = local.fn_app_names
   name                                = each.key
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = each.value
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
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
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     resource_group_name = module.app-rg.name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert  = var.cert_enabled
   }