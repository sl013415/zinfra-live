module "app-insights" {
  source              = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-app-insights"
  name                = "zccsprovapiaip01"
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
module "storage-account" {
  source                   = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-storage"
  name                     = "zccsprovapistrp01"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  env                      = var.env


  tags = merge(
    var.tags,
    {
      res-function = "StorageAccount"
    }
  )
}

module "win-web-app" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-windows-appservice"
  #?ref=feature/webapp_module"

  appservice_type                     = "web"
  subnet_id                           = var.subnet_id
  name                                = var.application_name
  appservice_plan_name                = var.appservice_plan_name
  appservice_plan_resource_group_name = var.appservice_plan_resource_group_name
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  storage_account_name                = module.storage-account.name
  storage_account_id                  = module.storage-account.id
  env                                 = var.env
  #scm_ip_restriction = local.ip_whitelist
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

  # site_config {
  #   ip_restriction_default_action     = "Deny"
  #   scm_ip_restriction_default_action = "Deny"
  # }

  application_stack = {
    dotnet_version = "v8.0"
    current_stack  = "dotnet"
  }


  tags = merge(
    var.tags,
    {
      res-function = "WebApp"
    }
  )
}


module "CustomDNS" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  application_name                     = var.application_name
  custom_domain_verification_id        = var.custom_domain_verification_id
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "CustomDNS_2" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  host_name                            = "providerapi-prod.zelis.com"
  application_name                     = var.application_name
  custom_domain_verification_id        = var.custom_domain_verification_id
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}
   