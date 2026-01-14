

# 5.3 - region must be East US 2, or CentralUS for DR
variable "location" {
  description = "(Required) location - example: South Central US = southcentralus"
  type        = string
  default     = "eastus2"
  validation {
    condition     = contains(["eastus2", "centralus"], lower(var.location))
    error_message = "Location must be one of the following: eastus2, centralus."
  }
}
variable "resource_group_name" {
  description = "(Required) Resource Group Name."
  type        = string
}
variable "tags" {
  description = "(Optional) Additional tags to apply to the resource."
  type        = map(any)
  default     = {}
}
variable "workspace_id" {
  type        = string
  description = "(Optional) Specifies the id of a log analytics workspace resource"
  default     = null
}
variable "account_tier" {
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  type        = string
}
variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}

# #
# # Key Vault parameters
# # ---------------------------
variable "sku_name" {
  type        = string
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  default     = "standard"
}


variable "env" {
  type        = string
  description = "(Required) env to choose subnets in netowkr restriction for web App or function App."
  default     = ""
}

variable "appservice_plan_name" {
  description = "(Required) App Service Plan Name for the App Service."
  type        = string
}
variable "appservice_plan_resource_group_name" {
  description = "(Required) App Service Plan Resource Group Name."
  type        = string
}



# # 5.3 - region must be East US 2, or CentralUS for DR

# #
# # Key Vault parameters
# # --------------------------
variable "zone_name" {
  type        = string
  description = "Name of the Zone."
  default     = ""
}

variable "custom_domain_verification_id" {
  description = "(Required) custom_domain_verification_id."
  type        = string
}
variable "shared_key_vault_name" {
  type        = string
  description = "Name of the shared key vault which has the wildcard certificate"
}
variable "shared_key_vault_resource_group_name" {
  type        = string
  description = "Name of the resource group for the shared key vault which has the wildcard certificate"
}
variable "wildcard_cert_name" {
  type        = string
  description = "Name of the wildcard certificate in the shared key vault"
}

# #
# # Data Layer Variables
# # - storage account, mssql server, mssql database, mssql firewall rule (tbd)
# # ---------------------------------------------
variable "db_enabled" {
  type        = bool
  description = "(Optional) Specify whether to create a MSSQL resource or not. Defaults to true."
  default     = true
}
variable "cert_enabled" {
  type        = bool
  description = "(Optional) Specify whether to create a MSSQL resource or not. Defaults to true."
  default     = true
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

variable "storage_account_name" {
  type        = string
  description = "(Required)storage_account_name."
  default     = ""
}