locals {
  app_insight_names = toset([
  "zenrpacbbeaiu01",
  "zenrpacbfeaiu01"
 ])
 web_app_be_names = toset([   
"zenrpacbbewau01",
"zenrpacbbewau02",
"zenrpacbbewau03",
"zenrpacbbewau04",
"zenrpacbbewau05",
"zenrpacbbewau06"     
  ])
}



module "search_service" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_search_service"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  partition_count = var.partition_count
  replica_count = var.replica_count
  local_authentication_enabled = var.local_authentication_enabled
  authentication_failure_mode  = var.authentication_failure_mode
  tags = merge(
    var.tags,
    {
     res-function = "CognitiveSearch"
    }
  )
}
module "private_endpoint" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_private_endpoint"
  depends_on = [
    module.search_service
  ]
virtual_network_name = var.virtual_network_name
virtual_network_resource_group_name= var.virtual_network_resource_group_name
private_endpoint_name = var.private_endpoint_name
subnet_name = var.subnet_name
location            = var.location
resource_group_name = var.resource_group_name
private_service_connection_name = var.private_service_connection_name
private_connection_resource_id = module.search_service.id
subresource_names = var.subresource_names
 tags = merge(
    var.tags,
    {
     res-function = "PrivateEndpoint"
    }
  )
  
}
module "redis_cache" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_redis_cache"

  name                = var.redis_cache_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku_name
  capacity = var.capacity
  family = var.family
  tags = merge(
    var.tags,
    {
     res-function = "RedisCache"
    }
  )
}

module "private_endpoint_redis" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_private_endpoint"
  depends_on = [
    module.redis_cache
  ]
virtual_network_name = var.virtual_network_name
virtual_network_resource_group_name= var.virtual_network_resource_group_name
private_endpoint_name = var.redis_cache_private_endpoint_name
subnet_name = var.subnet_name
location            = var.location
resource_group_name = var.resource_group_name
private_service_connection_name = var.redis_cache_private_service_connection_name
private_connection_resource_id = module.redis_cache.id
subresource_names = var.redis_cache_subresource_names
 tags = merge(
    var.tags,
    {
     res-function = "PrivateEndpoint"
    }
  )
  
}

data "azuread_group" "dba_admin" {
   display_name = var.azuread_administrator_group_name
 }
 module "mssql-server" {
   env = var.env
   enabled = var.db_enabled
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-mssql"
   name                = var.sql_server_name
   databases = var.database
   resource_group_name = var.resource_group_name
   location            = var.location
   azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      res-function = "PAAS-SQL"
    }
  )
 }

 module "cosmosdb_account" {
  env = var.env
  enabled = var.db_enabled
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_cosmosdb_account"
  name                = var.cosmosdb_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  kind = var.kind
  tags = merge(
    var.tags,
    {
      res-function = "CosmosDB"
    }
  )
}

module "storage-account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-storage"
  name                =var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env
  is_hns_enabled = true


  tags = merge(
    var.tags,
    { 
     res-function = "StorageAccount"
    }
  )
}

module "app-insights" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-app-insights"
  for_each = local.app_insight_names
   name                = each.key
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

 module "lin_web_app_fe" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_linux_web_app"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   name                                = var.application_name
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
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
     node_version  = "18-lts"
    current_stack  = "node"
   }


    tags = merge(
    var.tags,
    {
     res-function = "WebApp"
    }
  )
 }
  module "Custom_DNS"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = var.record_type
     custom_domain_verification_id = "${module.lin_web_app_fe.web_app_name}.azurewebsites.net"
     application_name    = module.lin_web_app_fe.web_app_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }
    module "Custom_DNS_zippi"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     host_name = "zippi-uat.zelis.com"
     record_type = var.record_type
     custom_domain_verification_id = "${module.lin_web_app_fe.web_app_name}.azurewebsites.net"
     application_name    = module.lin_web_app_fe.web_app_name
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }
module "lin_web_app_be" {
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_linux_web_app"

   appservice_type = "web"
   subnet_id       = var.subnet_id
   for_each = local.web_app_be_names
   name                                = each.key
   appservice_plan_name                =  var.appservice_plan_name
   appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
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
     python_version  = "3.11"
    current_stack  = "python"
   }


    tags = merge(
    var.tags,
    {
     res-function = "WebApp"
    }
  )
 }
  module "Custom_DNS_2"{
     source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/aws_route53_zone_record"
     providers = {
              aws = aws,
              azurerm = azurerm,
              azurerm.transversal = azurerm.certkvtsub
  }
     zone_name         = var.zone_name
     record_type = var.record_type
     for_each = local.web_app_be_names
     application_name    = each.key
     custom_domain_verification_id = "${each.key}.azurewebsites.net"
     resource_group_name = var.resource_group_name
     appservice_plan_name                =  var.appservice_plan_name
     appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
     shared_key_vault_name = var.shared_key_vault_name
     shared_key_vault_resource_group_name = var.shared_key_vault_resource_group_name
     wildcard_cert_name = var.wildcard_cert_name
     new_cert = var.cert_enabled
  }


 module "adf" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_data_factory"
   name   = var.data_factory_name
   location   = var.location
  virtual_network_resource_group_name  = var.virtual_network_resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name = var.subnet_name
  resource_group_name = var.resource_group_name
  tags = merge(
    var.tags,
    {
     res-function = "ADF"
    }
  )
}

   module "app-kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-key-vault"

  name = var.key_vault_name
  env = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.kv_sku_name
  access_policy = var.access_policy
  tags = merge(
    var.tags,
    { 
      res-function = "KeyVault"
    }
  )
}
module cognitive_account {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm_cognitive_account"
  location                           = var.location
  account_name                       = var.account_name
  resource_group_name                = var.resource_group_name
  custom_subdomain_name              = var.account_name
   tags = merge(
    var.tags,
    {
     res-function = "OAI"
    }
  )
 deployment = var.deployment
}