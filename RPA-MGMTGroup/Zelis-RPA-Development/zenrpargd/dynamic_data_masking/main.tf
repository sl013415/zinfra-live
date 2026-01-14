data "azurerm_client_config" "current" {}
module "network_restriction_policy"{
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//network_restriction"
  env = var.env
  subscriptionid = data.azurerm_client_config.current.subscription_id
}
locals {
  ip_whitelist = module.network_restriction_policy.ip_whitelist
  subnet_list = concat(module.network_restriction_policy.wvd_subnets , module.network_restriction_policy.iaas_subnets )
  vnet_integrated_whitelist = {

  for item in local.subnet_list  : item.name => {

    action = "Allow"

    virtual_network_subnet_id = item.id

}
  }
allowed_ip_list = {for k, v in local.ip_whitelist : k => {
 #ip_address = trimsuffix(v.ip_address, "/32")
 ip_address =v.ip_address
 action = v.action
 priority = v.priority
 } 
 }
webapp_network_restriction = merge(local.vnet_integrated_whitelist , local.allowed_ip_list)
subnet_ids = [
  for subnet in local.subnet_list: 
subnet.id

]

  key_vault_network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = local.allowed_ip_list
    virtual_network_subnet_ids = local.subnet_ids
  }
  storage_account_network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = local.allowed_ip_list
    subnet_ids = local.subnet_ids
  }
  web_app_names = toset([
        "zendmwad01",
        "zendmapid01"     
  ])
    custom_dns_records = {
     zendmwad01 = "zendmwad01.azurewebsites.net"
     zendmapid01 = "zendmapid01.azurewebsites.net"
   }
}
module "appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "zenrpaaspd03"

  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name = "B1"
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
   scm_ip_restriction = local.webapp_network_restriction
   ip_restriction = {
     "LZ Subnet" = {
       priority                  = 200
       action                    = "Allow"
       virtual_network_subnet_id = var.lz_subnet_id
     }
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