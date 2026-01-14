locals {
  # ip_whitelist = jsondecode(file("${path.module}/static/ip_whitelist.json"))

  # allowed_ip_list = [for k, v in local.ip_whitelist : trimsuffix(v.ip_address, "/32") if v.action == "Allow"]
  # key_vault_network_acls = {
  #   bypass                     = "AzureServices"
  #   default_action             = "Deny"
  #   ip_rules                   = local.allowed_ip_list
  #   virtual_network_subnet_ids = null # [var.subnet_id] Subnet requires service endpoints (SubnetsHaveNoServiceEndpointsConfigured)
  # }
  # storage_account_network_rules = {
  #   bypass                     = ["AzureServices"]
  #   default_action             = "Deny"
  #   ip_rules                   = local.allowed_ip_list
  #   subnet_ids = null # [var.subnet_id] Subnet requires service endpoints (SubnetsHaveNoServiceEndpointsConfigured)
  # }
  custom_dns_records = {
    "zcmrbpptnaap01"    = "20.22.102.82"
    "zcmrbppctprtwap01" = "20.22.102.82"
    "zcmrbpbbaap01"     = "20.22.102.82"
    "zcmrbpersaap01"    = "20.22.102.82"
    "zcmrbpfhaap01"     = "20.22.102.82"
    "zcmrbpmdraap01"    = "20.22.102.82"
    "zcmrbptrvaap01"    = "20.22.102.82"
    "zcmrbpmlnaap01"    = "20.22.102.82"
    "zcmrbplkpwap01"    = "20.22.102.82"
  }
  web_app_names = {
    "zcmrbpptnaap01"    = "zcmrbpptnaip01"
    "zcmrbppctprtwap01" = "zcmrbppctprtaip01"
    "zcmrbpbbaap01"     = "zcmrbpbbaip01"
    "zcmrbpersaap01"    = "zcmrbpersaip01"
    "zcmrbpfhaap01"     = "zcmrbpfhaip01"
    "zcmrbpmdraap01"    = "zcmrbpmdraip01"
    "zcmrbptrvaap01"    = "zcmrbptrvaip01"
    "zcmrbpmlnaap01"    = "zcmrbpmlnaip01"
    "zcmrbplkpwap01"    = "zcmrbplkpaip01"
  }
  # app_insight_names =toset([

  #  "zcmrbpptnaip01",
  #  "zcmrbppctprtaip01",
  #  "zcmrbpbbaip01",
  # "zcmrbpersaip01",
  # "zcmrbpfhaip01",
  # "zcmrbpmdraip01",
  #  "zcmrbptrvaip01",
  # "zcmrbpmlnaip01",
  # "zcmrbplkpaip01"
  # ])
  stg_acc_names = toset([
    "zcmrbpptnstrp01",
    "zcmrbplogstrp01"
  ])
  sql_servers = toset([
    "zcmrbpptnsqlp01",
    "zcmrbpsqlp01"
  ])
  custom_dns_rec = {
    zcmrbpbbaap01     = "rbp-benchmark-broker-prod.zelis.com"
    zcmrbppctprtwap01 = "rbp-precert-portal-prod.zelis.com"
    zcmrbplkpwap01    = "rbp-lookup-prod.zelis.com"


  }
}

module "app-insights" {
  source              = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-app-insights"
  for_each            = local.web_app_names
  name                = each.value
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
  for_each                 = local.stg_acc_names
  name                     = each.key
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

module "servicebus_namespace" {
  enabled             = var.db_enabled
  source              = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm_servicebus_namespace"
  name                = "zcmrbpadmsbp01"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = merge(
    var.tags,
    {
      res-function = "ServiceBusNameSpace"
      RBP_APP_Name = "rbp-admin-prod"
    }
  )
}
data "azuread_group" "dba_admin" {
  display_name = var.azuread_administrator_group_name
}
module "mssql-server" {
  enabled                  = var.db_enabled
  source                   = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-mssql"
  for_each                 = local.sql_servers
  name                     = each.key
  env                      = var.env
  resource_group_name      = var.resource_group_name
  location                 = var.location
  azuread_administrator_id = data.azuread_group.dba_admin.object_id

  tags = merge(
    var.tags,
    {
      res-function = "PAAS-SQL"
      RBP_APP_Name = "portunus-prod-sqlsrvr01"
    }
  )
}

module "win-web-app" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-windows-appservice"
  #?ref=feature/webapp_module"

  appservice_type                     = "web"
  subnet_id                           = var.subnet_id
  for_each                            = local.web_app_names
  name                                = each.key
  appservice_plan_name                = var.appservice_plan_name
  appservice_plan_resource_group_name = var.appservice_plan_resource_group_name
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  storage_account_id                  = var.storage_account_id
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

  application_stack = {
    dotnet_version = "v6.0"
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
  for_each                             = local.custom_dns_records
  application_name                     = each.key
  custom_domain_verification_id        = each.value
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}


module "win_web_app" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-windows-appservice"
  #?ref=feature/webapp_module"

  appservice_type                     = "function"
  subnet_id                           = var.subnet_id
  name                                = var.application_name
  appservice_plan_name                = var.appservice_plan_name
  appservice_plan_resource_group_name = var.appservice_plan_resource_group_name
  storage_account_name                = "zcmrbpptnstrp01"
  storage_account_id                  = var.storage_account_id
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  #scm_ip_restriction = local.ip_whitelist
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
    dotnet_version = "v6.0"
    current_stack  = "dotnet"
  }


  tags = merge(
    var.tags,
    {
      res-function = "WebApp"
    }
  )
}
module "Custom_DNS" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
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

module "app-kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-key-vault"

  name                = "zcmrbpptnkvp01"
  env                 = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  access_policy       = var.access_policy
  tags = merge(
    var.tags,
    {
      Function = "KeyVault"
    }
  )
}
module "Custom_DNS_2" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  for_each                             = local.custom_dns_rec
  application_name                     = each.key
  custom_domain_verification_id        = "20.22.102.82"
  host_name                            = each.value
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "Custom_DNS_Bench_ERS" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  host_name                            = "rbp-ers-prod.zelis.com"
  custom_domain_verification_id        = "zcmrbpersaap01.azurewebsites.net"
  application_name                     = "zcmrbpersaap01"
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "Custom_DNS_Bench_FairHealth" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  host_name                            = "rbp-fairhealth-prod.zelis.com"
  custom_domain_verification_id        = "zcmrbpfhaap01.azurewebsites.net"
  application_name                     = "zcmrbpfhaap01"
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "Custom_DNS_Bench_Lookup" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  host_name                            = "rbp-lookup-prod.zelis.com"
  custom_domain_verification_id        = "zcmrbplkpwap01.azurewebsites.net"
  application_name                     = "zcmrbplkpwap01"
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "Custom_DNS_Bench_Medicare" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  host_name                            = "rbp-medicare-prod.zelis.com"
  custom_domain_verification_id        = "zcmrbpmdraap01.azurewebsites.net"
  application_name                     = "zcmrbpmdraap01"
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "Custom_DNS_Bench_Milliman" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  host_name                            = "rbp-milliman-prod.zelis.com"
  custom_domain_verification_id        = "zcmrbpmlnaap01.azurewebsites.net"
  application_name                     = "zcmrbpmlnaap01"
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "Custom_DNS_Bench_Precert_adm" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  host_name                            = "rbp-precert-adm-prod.zelis.com"
  custom_domain_verification_id        = "zcmrbppctadmaap01.azurewebsites.net"
  application_name                     = "zcmrbppctadmaap01"
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "Custom_DNS_Bench_Precert_Portal" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  host_name                            = "rbp-precert-portal-prod.zelis.com"
  custom_domain_verification_id        = "zcmrbppctprtwap01.azurewebsites.net"
  application_name                     = "zcmrbppctprtwap01"
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}

module "Custom_DNS_Bench_Truven" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
  providers = {
    aws                 = aws,
    azurerm             = azurerm,
    azurerm.transversal = azurerm.certkvtsub
  }
  zone_name                            = var.zone_name
  record_type                          = var.record_type
  host_name                            = "rbp-truven-prod.zelis.com"
  custom_domain_verification_id        = "zcmrbptrvaap01.azurewebsites.net"
  application_name                     = "zcmrbptrvaap01"
  resource_group_name                  = var.resource_group_name
  appservice_plan_name                 = var.appservice_plan_name
  appservice_plan_resource_group_name  = var.appservice_plan_resource_group_name
  shared_key_vault_name                = var.shared_key_vault_name
  shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
  wildcard_cert_name                   = var.wildcard_cert_name
  new_cert                             = var.cert_enabled
}


module "app_kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-key-vault"

  name                = "zcmrbpkvp01"
  env                 = "prod"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  access_policy       = var.access_policy
  tags = merge(
    var.tags,
    {
      resource-function = "KeyVault"
    }
  )
}