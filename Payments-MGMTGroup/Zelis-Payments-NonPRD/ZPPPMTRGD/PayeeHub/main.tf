# Storage account

module "storage-account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-storage"
  name                =var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env
  #is_hns_enabled = true


  tags = merge(
    var.tags,
    { 
     res-function = "StorageAccount"
    }
  )
}

module "Windows-appservice-plan" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-appservice-plan"

  name                = "zppphubapsd01"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "S1"
  os_type  = "Windows"

  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
      res-function = "Windows App SVC Plan"
    }
  )
}

 module "app-insights" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-app-insights"

   name                = "zppphubaid01"
   resource_group_name = var.resource_group_name
   location            = var.location

   workspace_id = null

   tags = merge(
    var.tags,
    {
      res-function = "App Insights"
    }
  )
 }


module "win-web-app" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id

   name                                = "zppphubwad01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   #storage_account_name = module.storage-account.name
   storage_account_id = module.storage-account.id
   resource_group_name = var.resource_group_name
   location            = var.location
   env=var.env
   #scm_ip_restriction = local.ip_whitelist
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
     dotnet_version  = "v7.0"
    current_stack  = "dotnet"
   }


    tags = merge(
    var.tags,
    {
      res-function = "windows-Web-App"
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