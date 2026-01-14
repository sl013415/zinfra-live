
#
# Create the Environment RG
# ===============================================
module "app-rg" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-resourcegroup"
  name     = "ZCCSRGQ"
  location = var.location
  tags = merge(
    var.tags,
    {
      res-function = "ResourceGroup"
    }
  )
}

module "Windows-appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "zenccsapsq01"

  resource_group_name = module.app-rg.name
  location            = module.app-rg.location

  sku_name = "S3"
  os_type  = "Windows"
  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
      res-function = "AppSVCPlan"
    }
  )
}
module "Linux-appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "zenccsapsq02"

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
      res-function = "AppSVCPlan"
    }
  )
}





 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "zccseapiaiq01"
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location

   workspace_id = var.workspace_id

   tags = merge(
    var.tags,
    {
      res-function = "AppInsights"
    }
  )
 }
module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                = "zccseapistrq01"
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  account_tier = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env


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
  name                = "zccseapisbq01"
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
    tags = merge(
    var.tags,
    {
      res-function = "ServiceBusNameSpace"
    }
  )
}
 module "app-kv" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-key-vault"

  name = "zccseapikvq01"

   env = var.env
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  tags = merge(
    var.tags,
    { 
      res-function = "KeyVault"
    }
  )
}

module "win-web-app" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   env = var.env
   name                                = "zccseapiwaq01"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
  storage_account_id = module.storage-account.id
  health_check_path                       = "/heartbeat" 
  health_check_eviction_time_in_min       = 5
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
     dotnet_version  = "v7.0"
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


 module "Custom_DNS_qa1"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     host_name = "PriZemApi-qa1.zelis.com"
     record_type = "A"
     custom_domain_verification_id = "20.22.102.81"
     application_name    = var.application_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = "false"
  }
  module "win-web-app2" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id
  env = var.env
   name                                = "zccseapiwaq02"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   storage_account_id = module.storage-account.id
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
   health_check_path                       = "/heartbeat" 
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
     dotnet_version  = "v7.0"
    current_stack  = "dotnet"
   }


    tags = merge(
    var.tags,
    {
      res-function = "WebApp"
    }
  )
 }
 
 
  module "CustomDNS2"{
    source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = "A"
     custom_domain_verification_id ="20.22.102.81"
     application_name    ="zccseapiwaq02"
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = false

  }
  
module "Custom_DNS_qa2"{
     source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     host_name = "PriZemApi-qa2.zelis.com"
     record_type = "A"
     custom_domain_verification_id = "20.22.102.81"
     application_name    = "zccseapiwaq02"
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = "false"
  }
    module "win-web-app3" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   env = var.env
   name                                = "zccseapiIAwaq02"
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location
   storage_account_id = module.storage-account.id
   health_check_path                       = "/heartbeat" 
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
     dotnet_version  = "v7.0"
    current_stack  = "dotnet"
   }


    tags = merge(
    var.tags,
    {
      res-function = "WebApp"
    }
  )
 }
 
 
  module "CustomDNS3"{
    source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = "A"
     custom_domain_verification_id ="20.22.102.81"
     application_name    = "zccseapiIAwaq02"
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = false

  }