data "azuread_group" "dba_admin" {
  display_name = var.azuread_administrator_group_name
}

module "mssql-server" {
  enabled = var.db_enabled
  #databases = var.database
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-mssql"


  name                = "zeneppsqlq01"
  resource_group_name = var.resource_group_name
  location            = var.location
  env                 = var.env
  #ip_restriction = local.ip_whitelist

  # Create a managed identity for the Azure SQL Server
  identity_type            = var.identity_type
  azuread_administrator_id = data.azuread_group.dba_admin.object_id

  tags = merge(
    var.tags,
    {
      Function = "MS-SQL Server"
    }
  )
}

module "app-insights" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-app-insights"

  name                = "zeneppaiq01"
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

module "static_site" {
  enabled                       = var.db_enabled
  source                        = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_static_site"
  name                          = "zeneppswaq01"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  custom_domain_verification_id = var.custom_domain_verification_id
  record_type                   = var.record_type
  sku_tier                      = "Standard"
  zone_name                     = var.zone_name
  tags = merge(
    var.tags,
    {
      Function = "Static-Web-App"
    }
  )
}

module "static_site_2" {
  enabled                       = var.db_enabled
  source                        = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_static_site"
  name                          = "zeneppemlswaq01"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  custom_domain_verification_id = "black-sky-09690f30f.5.azurestaticapps.net"
  host_name = "qa-verification.zelis.com"
  record_type = "CNAME"
  
  sku_tier                      = "Standard"
  zone_name                     = var.zone_name
  tags = merge(
    var.tags,
    {
      Function = "StaticWebApp"
    }
  )
}

module "private_endpoint_static_webapp" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_private_endpoint"
  
virtual_network_name = var.vnet_name
virtual_network_resource_group_name= var.virtual_network_resource_group_name
private_endpoint_name = var.static_webapp_private_endpoint_name
subnet_name = var.subnet_name
location            = var.location
resource_group_name = var.resource_group_name
private_service_connection_name = var.static_webapp_private_service_connection_name
private_connection_resource_id = module.static_site_2.id
subresource_names = var.static_webapp_subresource_names
 tags = merge(
    var.tags,
    {
     res-function = "PrivateEndpoint"
    }
  )
  
}
module "storage-account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-storage"

  name                = "zeneppstrq01"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier        = "Standard"
  env                 = var.env
  #network_rules = local.storage_account_network_rules
  # containers = [
  #   {
  #     name        = "tfstate",
  #     access_type = "container"
  #   }
  # ]

  tags = merge(
    var.tags,
    {
      Function = "Storage-Account"
    }
  )
}
module "win-fun-app" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-windows-appservice"

  appservice_type                     = "function"
  subnet_id                           = var.subnet_id
  env                                 = var.env
  name                                = "zeneppfaq01"
  appservice_plan_name                = var.appservice_plan_name
  appservice_plan_resource_group_name = var.appservice_plan_resource_group_name
  storage_account_name                = module.storage-account.name
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  storage_account_id                  = module.storage-account.id
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
module "CustomDNS" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  custom_domain_verification_id        = var.custom_domain_verification_id
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  application_name                     = var.application_name
  resource_group_name                  = var.resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled

}
module "app-kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-key-vault"

  name                = "zeneppkvq01"
  env                 = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  access_policy       = var.access_policy
  #network_acls  = local.key_vault_network_acls
  tags = merge(
    var.tags,
    {
      Function = "Key-Vault"
    }
  )
}


 module "Custom_DNS_2"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     host_name = "qa-entport.zelis.com"
     record_type = "CNAME"
     custom_domain_verification_id = "zeneppfaq01.azurewebsites.net"
     application_name    = "zeneppfaq01"
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = "false"
  }

