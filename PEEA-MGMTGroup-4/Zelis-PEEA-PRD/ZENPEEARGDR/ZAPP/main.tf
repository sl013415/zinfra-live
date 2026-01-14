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

   name                = "zenzappaidr01"
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

  name                = "zenzappstrdr01"
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

module "win-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id

   name                                = "ZENZAPPWADR02"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   #storage_account_name = module.storage-account.name
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
      Function = "windows-Web-App"
    }
  )
 }
module "cosmosdb_account" {
  enabled = var.db_enabled
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_cosmosdb_account"
  name                = "zenzappcosdr01"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind = var.kind
  tags = merge(
    var.tags,
    {
      Function = "Cosmos-DB"
    }
  )
}


 module "web-linuxapp" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_linux_web_app"

   appservice_type = "web"
   subnet_id       = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp02/providers/Microsoft.Network/virtualNetworks/zenpevnnetp02/subnets/PaaSApp-Integration-Net-PRD-Linux"

   name                                = "ZENZAPPWADR01"
   appservice_plan_name                = "ZENPEEAASPDR02"
   appservice_plan_resource_group_name = var.appservice_plan_resource_group_name

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
     node_version  = "16-lts"
   }

    tags = merge(
    var.tags,
    {
      Function = "Linux-Web-App"
    }
  )
 }


  module "CustomDNS"{
         providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
    source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
    zone_name         = var.zone_name
    location            = var.location
    record_type = var.record_type
    custom_domain_verification_id = var.custom_domain_verification_id
    application_name    = var.application_name
    appservice_plan_name                =  var.appservice_plan_name
    appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
    resource_group_name = var.resource_group_name
    shared_key_vault_name = var.shared_key_vault_name
    shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
    wildcard_cert_name = var.wildcard_cert_name
    new_cert = var.cert_enabled


  }
    module "CustomDNSLinux"{
             providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
    source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
    zone_name         = var.zone_name
    location            = var.location
    record_type = var.record_type
    custom_domain_verification_id = "20.84.141.6"
    application_name    = "ZENZAPPWADR01"
    appservice_plan_name                =  "ZENPEEAASPDR02"
    appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
    resource_group_name = var.resource_group_name
    shared_key_vault_name = var.shared_key_vault_name
    shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
    wildcard_cert_name = var.wildcard_cert_name
    new_cert = "true"


  }

  
 module "static_site" {
  enabled = var.db_enabled
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_static_site"
  name                = "ZENZAPPSWADR01"
  sku_tier = "Standard"
  sku_size = "Standard"
  resource_group_name = var.resource_group_name
  location            = var.location
   tags = merge(
    var.tags,
    {
      Function = "Static-Web-App"
    }
  )
}