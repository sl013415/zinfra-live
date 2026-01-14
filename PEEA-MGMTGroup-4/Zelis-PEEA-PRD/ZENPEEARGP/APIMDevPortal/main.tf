
 module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage?ref=feature/integrate_network_restriction_n_health_check"
  name                = "zenapimdpstrp01"
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
 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zenapimdpaip01"
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

  module "static_site" {
  enabled = var.db_enabled
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_static_site"
  name                = "zenadpswap01"
  resource_group_name = var.resource_group_name
  zone_name = var.zone_name
  record_type = var.record_type
  custom_domain_verification_id = var.custom_domain_verification_id
  location            = var.location
  sku_tier = "Standard"
  sku_size = "Standard"
   tags = merge(
    var.tags,
    {
      res-function = "StaticWebApp"
    }
  )
}

module "private_endpoint_2" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_private_endpoint"
  depends_on = [
    module.static_site
  ]
virtual_network_name = var.virtual_network_name
virtual_network_resource_group_name= var.virtual_network_resource_group_name
private_endpoint_name = "zenadppep01"
subnet_name = var.subnet_name
location            = var.location
resource_group_name = var.resource_group_name
private_service_connection_name = "zenadppscp01"
private_connection_resource_id = module.static_site.id
subresource_names = ["staticSites"]
 tags = merge(
    var.tags,
    {
     res-function = "PrivateEndpoint"
    }
  )
  
}

module "win_fn_app" {
   depends_on = [
    module.storage-account
  ]
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice?ref=feature/integrate_network_restriction_n_health_check"
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
     custom_domain_verification_id ="${var.application_name}.azurewebsites.net"
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }
  module "Custom_DNS2"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     host_name = "devportalsignupapi.zelis.com"
     record_type = var.record_type
     custom_domain_verification_id ="mimcrls.impervadns.net"
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }
 