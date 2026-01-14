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





variable "name" {
  description = "(Required) Name for Cognitive search"
  type        = string
}







variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource"
  default     = {}
}

   variable "env" {
   type        = string
   description = "(Required) env to select Subnet IDs for VNET Integration."
 }



variable "storage_account_name" {
  type        = string
  description = "storage_account name."
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
variable "account_name" {
  type        = string
  description = "Name of the Open AI."
  default     = ""
}