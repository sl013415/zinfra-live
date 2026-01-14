 
 module "appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = var.appservice_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name = var.sku_name
  os_type  = "Windows"

  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
      res-function = "AppSvcPlan"
    }
  )
}
 module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"
  
  name                = var.storage_account_name
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
module "win_web_app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "function"
   subnet_id       = var.subnet_id
   name                                = var.application_name
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = module.storage-account.name
   storage_account_id = module.storage-account.id
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
     res-function = "FunctionApp"
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
 