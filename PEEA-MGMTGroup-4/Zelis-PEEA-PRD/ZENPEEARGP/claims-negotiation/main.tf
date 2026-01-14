
module "Custom_DNS" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  #host_name = "myhealthbill.zelis.com"
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  custom_domain_verification_id        = "white-dune-040bf5e0f.5.azurestaticapps.net"
  application_name                     = var.application_name
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "Custom_DNS_2" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  host_name = "myhealthbill.zelis.com"
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  custom_domain_verification_id        = var.custom_domain_verification_id
  application_name                     = var.application_name
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "static_site" {
  enabled = var.db_enabled
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_static_site"
  name                = "zencneswap01"
  
  resource_group_name = var.resource_group_name
  custom_domain_verification_id = "white-dune-040bf5e0f.5.azurestaticapps.net"
  host_name = "myhealthbill.zelis.com"
  record_type = "CNAME"
  location            = var.location
  zone_name = var.zone_name
  sku_tier = "Standard"
  sku_size = "Standard"
   tags = merge(
    var.tags,
    {
      res-function = "StaticWebApp"
    }
  )
}

module "private_endpoint_static_webapp" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_private_endpoint"
  
virtual_network_name = var.virtual_network_name
virtual_network_resource_group_name= var.virtual_network_resource_group_name
private_endpoint_name = var.static_webapp_private_endpoint_name
subnet_name = var.subnet_name
location            = var.location
resource_group_name = var.resource_group_name
private_service_connection_name = var.static_webapp_private_service_connection_name
private_connection_resource_id = module.static_site.id
subresource_names = var.static_webapp_subresource_names
 tags = merge(
    var.tags,
    {
     res-function = "PrivateEndpoint"
    }
  )
  
}