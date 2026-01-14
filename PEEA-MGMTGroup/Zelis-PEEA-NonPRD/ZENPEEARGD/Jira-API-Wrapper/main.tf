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


  module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zenjapiaid01"
   resource_group_name = var.resource_group_name
   location            = var.location

   workspace_id = null

   tags = merge(
    var.tags,
    {
      Function = "App-Insights"
    }
  )
 }
module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                = "zenjapistrd01"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier = "Standard"
  network_rules = local.storage_account_network_rules


  tags = merge(
    var.tags,
    { 
      Function = "Storage-Account"
    }
  )
}

 module "win-fun-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "function"
   subnet_id       = var.subnet_id

   name                                = "zenjapifad01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = module.storage-account.name
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
     dotnet_version = "v6.0"
    current_stack  = "dotnet"
   }

    tags = merge(
    var.tags,
    {
      Function = "Function-App"
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

   }

     module "CustomDNS2"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record?ref=feature"
              providers = {
               aws = aws,
               azurerm = azurerm,
               azurerm.transversal = azurerm.certkvtsub
   }
     zone_name         = var.zone_name
     record_type =var.record_type
     custom_domain_verification_id = var.custom_domain_verification_id
     host_name = "dev-japi.zelis.com"
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name

   }