variable "virtual_network_name" {
  description = "(Required) Name for VNET"
  type        = string
}
variable "virtual_network_resource_group_name" {
  type        = string
  description = "(Required) Name of an existing resource group where the VNET exists."
}

variable "location" {
  type        = string
  description = "(Required) The Azure region to deploy to. Recommendation is to set to the same location as the resource group."
}
variable "subnet_name" {
  type        = string
  description = "(Required) subnet name to create the end point."
}
variable "private_endpoint_name" {
  description = "(Required) Name for Private Endpoint"
  type        = string
}
variable "resource_group_name" {
  type        = string
  description = "(Required) Name of an existing resource group to deploy Private Endpoint."
}

variable "private_service_connection_name" {
  type        = string
  description = "(Required) Name of private service connection name for cognitive search."
}
# variable "private_connection_resource_id" {
#   type        = string
#   description = "ID of an existing resource  to link Private Endpoint to cognitive search."
#   default = null
# }
variable "subresource_names" {
  type        = list(string)
  description = "(Required) List of an subresource_names to link Private Endpoint to for cognitive search."
}
variable "redis_cache_private_endpoint_name" {
  description = "(Required) Name for Private Endpoint for redis_cache "
  type        = string
}
variable "redis_cache_private_service_connection_name" {
  type        = string
  description = "(Required) Name of private service connection name for redis_cache."
}
# variable "redis_cache_private_connection_resource_id" {
#   type        = string
#   description = "ID of an existing resource  to link Private Endpoint to redis_cache."
#   default = null
# }
variable "redis_cache_subresource_names" {
  type        = list(string)
  description = "(Required) List of an subresource_names to link Private Endpoint to redis_cache."
}

variable "name" {
  description = "(Required) Name for Cognitive search"
  type        = string
}
variable "redis_cache_name" {
  description = "(Required) Name for redis cache"
  type        = string
}
variable "key_vault_name" {
  description = "(Required) key_vault_name which will be set as tag per policy."
  type        = string
}
variable "authentication_failure_mode" {
  type        = string
  description = "set this to http403 for using both AzureAD and API Keys."
}
variable "local_authentication_enabled" {
  type        = string
  description = "set this to true for using both AzureAD and API Keys."
}
 variable "kv_sku_name" {
   type        = string
   description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
   default     = "standard"
 }

 variable "access_policy" {
   description = "(Optional) A list of up to 16 objects describing access policies, as described below."
   type = list(object({
     object_id               = string
     certificate_permissions = list(string)
     key_permissions         = list(string)
     secret_permissions      = list(string)
   }))
   default = []
 }

variable "sku" {
  type        = string
  description = "Sku for cognitive search."
}
variable "sku_name" {
  type        = string
  description = "Sku for Redis Cache."
}

variable "replica_count" {
  type        = string
  description = "replica_count for cognitive search."
}
variable "partition_count" {
  type        = string
  description = "partition_count for cognitive search."
}
variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource"
  default     = {}
}
variable "capacity" {
  type        = string
  description = "capacity for Redis Cache."
}
variable "family" {
  type        = string
  description = "family for Redis Cache."
}
 variable "db_enabled" {
  type        = bool
   description = "(Optional) Specify whether to create a MSSQL resource or not. Defaults to true."
   default     = true
 }
   variable "env" {
   type        = string
   description = "(Required) env to select Subnet IDs for VNET Integration."
 }
  variable "azuread_administrator_group_name" {
   type        = string
   description = "(Required) AAD group name to assign as administrator for the Azure SQL Server."
 }
 variable "sql_server_name" {
  type        = string
  description = "ms sql server name."
}
 variable "database" {
  type        = map(any)
  description = "(Optional) Specify whether to create a MSSQL resource or not. Defaults to true."
  default     = {}
}
 variable "cosmosdb_account_name" {
  type        = string
  description = "ms sql server name."
}
variable "storage_account_name" {
  type        = string
  description = "storage_account name."
}
variable "app_insights_name" {
  type        = string
  description = "app insights name."
}

variable "account_tier" {
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  type        = string
  default = "Standard"
}
variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}

variable "kind" {
  type        = string
  description = "(Required) The location to deploy resources to."
}
variable "cosmosdb_virtual_network_rule_subnet_ids" {
  type = list(string)
  description = "(Optional) cosmos_db subnet ids for network restriction. "
  default     = []
}
variable "workspace_id" {
  type        = string
  description = "(Required) workspace id for app insights."
}
variable "subnet_id" {
   type        = string
   description = "(Required) Subnet ID for VNET Integration."
 }
 variable "lz_subnet_id" {
   type        = string
   description = "(Required) Subnet ID for VNET Integration."
 }
 
 variable "lz_DR_subnet_id" {
   type        = string
   description = "(Required) Subnet ID for VNET Integration."
 }

variable "application_name" {
  description = "(Required) Product/Application name which will be set as tag per policy."
  type        = string
}
variable "data_factory_name" {
  description = "(Required) Data Factory name which will be set as tag per policy."
  type        = string
}
variable "record_type" {
  description = "CNAME or A Record."
  type        = string
}

variable "storage_account_id" {
  type        = string
  description = "(Required)storage_account_id  for storing diagnostic setting for  web App or function App."
  default = ""
}
variable "zone_name" {
  type        = string
  description = "Name of the Zone."
  default     = "zelis.com"
}

# variable "custom_domain_verification_id" {
#   description = "(Required) custom_domain_verification_id."
#   type        = string
# }
variable "shared_key_vault_name" {
  type = string
  description = "Name of the shared key vault which has the wildcard certificate"
}
variable "shared_key_vault_resource_group_name" {
  type = string
  description = "Name of the resource group for the shared key vault which has the wildcard certificate"
}
variable "wildcard_cert_name" {
  type = string
  description = "Name of the wildcard certificate in the shared key vault"
}
 variable "appservice_plan_name" {
   description = "(Required) App Service Plan Name for the App Service."
   type        = string
 }
 variable "appservice_plan_resource_group_name" {
   description = "(Required) App Service Plan Resource Group Name."
   type        = string
 }
 variable "cert_enabled" {
  type        = bool
   description = "(Optional) Specify whether to create a MSSQL resource or not. Defaults to true."
   default     = true
 }
  variable "custom_subdomain_name" {
  type        = string
  default     = ""
  description = "The subdomain name used for token-based authentication. Changing this forces a new resource to be created. Leave this variable as default would use a default name with random suffix."
}
variable "deployment" {
  type = map(object({
    name            = string
    model_format    = string
    model_name      = string
    model_version   = string
    scale_type      = string
    rai_policy_name = optional(string)
  }))
}
variable "account_name" {
  type        = string
  description = "Name of the Open AI."
  default     = ""
}