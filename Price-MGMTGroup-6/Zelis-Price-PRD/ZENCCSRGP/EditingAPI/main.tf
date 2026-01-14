
# Create the Environment RG
# ===============================================
module "app-rg" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-resourcegroup"
  name     = "ZCCSRGP"
  location = var.location
  tags = merge(
    var.tags,
    {
      res-function = "ResourceGroup"
    }
  )
}

module "Windows-appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "zenccsapsp01"

  resource_group_name = module.app-rg.name
  location            = module.app-rg.location

  sku_name = "P2v3"
  os_type  = "Windows"
  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
      res-function = "AppSVCPlan"
    }
  )
}
module "Linux-appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "zenccsapsp02"

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
      res-function = "AppSVCPlan"
    }
  )
}





 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zccseapiaip01"
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
   workspace_id =  var.workspace_id

   tags = merge(
    var.tags,
    {
      res-function = "AppInsights"
    }
  )
 }
module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                = "zccseapistrp01"
   resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  account_tier = var.account_tier
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
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_servicebus_namespace"
  name                = "zccseapisbp01"
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
    tags = merge(
    var.tags,
    {
      res-function = "ServiceBusNameSpace"
    }
  )
}
 module "app-kv" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-key-vault"

  name = "zccseapikvp01"
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

module "win-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   env = var.env
   name                                = "zccseapiwap01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
   storage_account_id = module.storage-account.id
  #health_check_path                       = "/heartbeat" 
  health_check_eviction_time_in_min       = 5
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
     dotnet_version  = "v7.0"
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
   module "Custom_DNS_2"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     host_name = "PriZemApi.zelis.com"
     record_type = "CNAME"
     custom_domain_verification_id = "zccseapiwap01.azurewebsites.net"
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = "false"
  }