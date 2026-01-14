module "app-rg" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-resourcegroup"
  name     = "ZENPEEARGDR"
  location = var.location
  tags = merge(
    var.tags,
    {
      res-function = "ResourceGroup"
    }
  )
}


module "Windows-appservice-plan" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-appservice-plan"

  name = "ZENPEEAASPDR01"

 resource_group_name = module.app-rg.name
 location            = module.app-rg.location

  sku_name = "S2"
  os_type  = "Windows"
  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
      Function = "Windows-App-SVC-Plan"
    }
  )
}
module "Linux-appservice-plan" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-appservice-plan"

  name = "ZENPEEAASPDR02"

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
      Function = "Linux-App-SVC-Plan"
    }
  )
}

 data "azuread_group" "dba_admin" {
   display_name = var.azuread_administrator_group_name
 }

 module "mssql-server" {
   enabled = var.db_enabled
   #databases = var.database
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-mssql"
   

   name                = "zenemfsqldr01"
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location

   #ip_restriction = local.ip_whitelist

   # Create a managed identity for the Azure SQL Server
   identity_type            = var.identity_type
   azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      Function = "MS-SQL-Server"
    }
  )
 }
 module "app-insights" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-app-insights"

   name                = "zenemfaidr01"
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location

   workspace_id = null

   tags = merge(
    var.tags,
    {
      Function = "App-Insights"
    }
  )
 }

module "storage-account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-storage"

  name                = "zenemfstrdr01"
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  account_tier = "Standard"
  #network_rules = local.storage_account_network_rules
  tags = merge(
    var.tags,
    { 
      Function = "Storage-Account"
    }
  )
}

 module "app-kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-key-vault"

  name = "zenemfkvdr01"

  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  #network_acls  = local.key_vault_network_acls
   tags = merge(
    var.tags,
    { 
      Function = "Key-Vault"
    }
  )
}

 module "win-fun-app" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-windows-appservice"

   appservice_type = "function"
   subnet_id       = var.subnet_id

   name                                = "zenemffadr01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = module.storage-account.name
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
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
     dotnet_version = "6"
    current_stack  = "dotnet"
   }

    tags = merge(
    var.tags,
    {
      Function = "Function-App"
    }
  )
 }

 module "servicebus_namespace" {
  enabled = var.db_enabled
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm_servicebus_namespace"
  name                = "zenemfsbdr01"
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
    tags = merge(
    var.tags,
    {
      Function = "EMF Service Bus Name Space"
    }
  )
}

 module "base-win-fun-app" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-windows-appservice"

   appservice_type = "function"
   subnet_id       = var.subnet_id

   name                                = "zenemfbefadr01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = module.storage-account.name
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
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
     dotnet_version = "6"
    current_stack  = "dotnet"
   }

    tags = merge(
    var.tags,
    {
      Function = "Function-App"
    }
  )
 }
  module "CustomDNS"{
         providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
    source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
    zone_name         = var.zone_name
    location            = module.app-rg.location
    record_type = var.record_type
    custom_domain_verification_id = var.custom_domain_verification_id
    application_name    = var.application_name
    appservice_plan_name                =  var.appservice_plan_name
    appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
    resource_group_name = module.app-rg.name
    shared_key_vault_name = var.shared_key_vault_name
    shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
    wildcard_cert_name = var.wildcard_cert_name
    new_cert = var.cert_enabled


  }

  module "CustomDNS_EMF"{
         providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
    source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
    zone_name         = var.zone_name
    host_name             = "zema.zelis.com"
    location            = var.location
    record_type = var.record_type
    custom_domain_verification_id = var.custom_domain_verification_id
    application_name    = var.application_name
    appservice_plan_name                =  var.appservice_plan_name
    appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
    resource_group_name = var.resource_group_name
    shared_key_vault_name = var.shared_key_vault_name
    shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
    wildcard_cert_name = var.wildcard_cert_name
    new_cert = var.cert_enabled


  }
    module "CustomDNSbase"{
             providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
    source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
    zone_name         = var.zone_name
    #host_name= "zema-backend.zelis.com"
    location            = var.location
    record_type = "CNAME"
    custom_domain_verification_id = "zenemfbefadr01.azurewebsites.net"
    application_name    = "zenemfbefadr01"
    appservice_plan_name                =  var.appservice_plan_name
    appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
    resource_group_name = var.resource_group_name
    shared_key_vault_name = var.shared_key_vault_name
    shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
    wildcard_cert_name = var.wildcard_cert_name
    new_cert = "false"
     
  }

  module "CustomDNSbase_2"{
             providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
    source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//aws_route53_zone_record"
    zone_name         = var.zone_name
    host_name= "zema-backend.zelis.com"
    location            = var.location
    record_type = "CNAME"
    custom_domain_verification_id = "zenemfbefadr01.azurewebsites.net"
    application_name    = "zenemfbefadr01"
    appservice_plan_name                =  var.appservice_plan_name
    appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
    resource_group_name = var.resource_group_name
    shared_key_vault_name = var.shared_key_vault_name
    shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
    wildcard_cert_name = var.wildcard_cert_name
    new_cert = "false"
     
  }

  