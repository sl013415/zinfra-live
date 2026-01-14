
 module "apim" {
   
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_api_management_api"
   #?ref=feature"
              providers = {
               aws = aws,
               azurerm = azurerm,
               azurerm.transversal = azurerm.certkvtsub
   }
    location                  = var.location
    apim_name                      = var.apim_name 
    apim_publisher_email           = var.apim_publisher_email
    apim_publisher_name            = var.apim_publisher_name
    resource_group_name       = var.resource_group_name
    apim_sku_name                  = var.apim_sku_name 
    apim_virtual_network_type      = var.apim_virtual_network_type 
    pip_name               = var.pip_name
    zones = var.zones
    pip_resource_group_name =var.pip_resource_group_name
    apim_subnet_id = var.apim_subnet_id
    additional_location = var.additional_location 
    requires_custom_host_name_configuration = var.requires_custom_host_name_configuration
    wildcard_certificate_key_vault_name = var.wildcard_certificate_key_vault_name
    wildcard_certificate_key_vault_resource_group_name = var.wildcard_certificate_key_vault_resource_group_name
    wildcard_certificate_name = var.wildcard_certificate_name
    gateway_host_name = var.gateway_host_name
    management_host_name = var.management_host_name
    developer_portal_host_name = var.developer_portal_host_name
    client_id           = var.client_id
    client_secret           = var.client_secret
    allowed_tenants     = var.allowed_tenants
    tags = merge(
    var.tags,
    {
      res-function = "APIM"
    }
  )
 }

   module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zenpeapimaip01"
   resource_group_name = var.resource_group_name
   location            = var.location

   workspace_id = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpeeargp/providers/Microsoft.OperationalInsights/workspaces/zenpeealawsp01"

   tags = merge(
    var.tags,
    {
     res-function = "AppInsights"
    }
  )
 }
    module "app-kv" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-key-vault"

  name = "zenpeapimkvp01"
  env = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  
  tags = merge(
    var.tags,
    { 
      Function = "KeyVault"
    }
  )
}