locals {
  ip_whitelist = jsondecode(file("${path.module}/static/ip_whitelist.json"))

  allowed_ip_list = [for k, v in local.ip_whitelist : trimsuffix(v.ip_address, "/32") if v.action == "Allow"]
  key_vault_network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = local.allowed_ip_list
    virtual_network_subnet_ids = null # [var.subnet_id] Subnet requires service endpoints (SubnetsHaveNoServiceEndpointsConfigured)
  }
  storage_account_network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = local.allowed_ip_list
    subnet_ids = null # [var.subnet_id] Subnet requires service endpoints (SubnetsHaveNoServiceEndpointsConfigured)
  }

  web_app_names = toset([
        "zcmrbpptnaau01",
        "zcmrbpbbaau01",
        "zcmrbpersaau01",
        "zcmrbpfhaau01",
        "zcmrbpmdraau01",
        "zcmrbpmlnaau01",
        "zcmrbptrvaau01",
        "zcmrbppctwau01",
        "zcmrbplkpwau01"        
  ])
   app_insight_names = toset([
"zcmrbpptnaiu01",
"zcmrbpbbaiu01",
"zcmrbpersaiu01",
"zcmrbpfhaiu01",
"zcmrbpmdraiu01",
"zcmrbpmlnaiu01",
"zcmrbptrvaiu01",
"zcmrbppctaiu01",
"zcmrbplkpaiu01",
"zcmrbppradmaiu01",
"zcmrbpcbsaaiu01"      
  ])
  custom_dns_records = {
        zcmrbpptnaau01 = "20.22.102.82"
        zcmrbpbbaau01 = "20.22.102.82"
        zcmrbpersaau01= "20.22.102.82"
        zcmrbpfhaau01= "20.22.102.82"
        zcmrbpmdraau01= "20.22.102.82"
        zcmrbpmlnaau01= "20.22.102.82"
        zcmrbptrvaau01= "20.22.102.82"
        zcmrbppctwau01= "20.22.102.82"
        zcmrbplkpwau01= "20.22.102.82"
        #zcmrbppradmaau01 = "20.22.102.82"
        #zcmrbppradmaau01 = "zcmrbppradmaau01.azurewebsites.net"
    #.azurewebsites.net"
   }
     custom_dns_rec = {
        zcmrbplkpwau01 = "rbp-lookup-uat.zelis.com"
        zcmrbpbbaau01 = "rbp-benchmark-broker-uat.zelis.com"
        zcmrbppctwau01 = "rbp-precert-portal-uat.zelis.com"
    
   }
}

 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"
   for_each = local.app_insight_names
   name                                = each.key
   #name                = "zcmrbpptnaiu01"
   resource_group_name = var.resource_group_name
   location            = var.location

   workspace_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/ZCCSRGD/providers/Microsoft.OperationalInsights/workspaces/Workspace-ZCCSRGD-EUS2"

   tags = merge(
    var.tags,
    {
     res-function = "AppInsights"
    }
  )
 }
module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                = "zcmrbplogstru01"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier = "Standard"
  network_rules = local.storage_account_network_rules


  tags = merge(
    var.tags,
    { 
     res-function = "StorageAccount"
    }
  )
}

 module "servicebus_namespace" {
  enabled = var.db_enabled
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_servicebus_namespace"
  name                = "zcmrbpadmsbu01"
   resource_group_name = var.resource_group_name
   location            = var.location
    tags = merge(
    var.tags,
    {
     res-function = "ServiceBusNameSpace"
    }
  )
}
data "azuread_group" "dba_admin" {
   display_name = var.azuread_administrator_group_name
 }
 module "mssql-server" {
   enabled = var.db_enabled
   #databases = var.database
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-mssql"
   

   name                = "zcmrbpsqlu01"
   resource_group_name = var.resource_group_name
   location            = var.location

   ip_restriction = local.ip_whitelist

   # Create a managed identity for the Azure SQL Server
   #identity_type            = var.identity_type
   azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      res-function = "PAAS-SQL"
    }
  )
 }

module "win-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"
   #?ref=feature/webapp_module"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   for_each = local.web_app_names
   name                                = each.key
  #name                                = "zcmrbpptnaau01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   #storage_account_name = module.storage-account.name
   resource_group_name = var.resource_group_name
   location            = var.location
   scm_ip_restriction = local.ip_whitelist
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

  #  app_settings = {
  #    "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app-insights.instrumentation_key
  #  }

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
     #custom_domain_verification_id = var.custom_domain_verification_id
     #application_name    = var.application_name
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


  module "win_web_app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"
   #?ref=feature/webapp_module"

   appservice_type = "function"
   subnet_id       = var.subnet_id
  name                                = "zcmrbppradmaau01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = module.storage-account.name
   resource_group_name = var.resource_group_name
   location            = var.location
   scm_ip_restriction = local.ip_whitelist
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

  #  app_settings = {
  #    "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app-insights.instrumentation_key
  #  }

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
 module "Custom_DNS"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = var.record_type
     custom_domain_verification_id = "20.22.102.82"
     application_name    = "zcmrbppradmaau01"
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }

   module "Custom_DNS_2"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = "CNAME"
     for_each = local.custom_dns_rec
     #for_each = { for i, v in local.custom_dns_rec : i => v }
     application_name    = each.key
     custom_domain_verification_id = "${each.key}.azurewebsites.net"
     host_name = each.value
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }



   module "win_fn_app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"
   #?ref=feature/webapp_module"

   appservice_type = "function"
   subnet_id       = var.subnet_id
  name                                = "zcmrbpcbsafau01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_name = module.storage-account.name
   resource_group_name = var.resource_group_name
   location            = var.location
   scm_ip_restriction = local.ip_whitelist
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
     res-function = "WebApp"
    }
  )
 }
 module "Custom-DNS"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = "CNAME"
     custom_domain_verification_id = "zcmrbpcbsafau01.azurewebsites.net"
     application_name    = "zcmrbpcbsafau01"
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }
