
# Previously 'application_name'
variable "organization_name" {
  description = "(Required) Organization name to provision the Application Environment on behalf of."
  type        = string
}

variable "short_org_name" {
  description = "(Optional) Shortened Organization name which will be used as body of the name. If none is provided, will be generated with organization_name"
  type        = string
  default     = null
}

variable "product_id" {
  description = "(Required) Product/Application ID for the policy."
  type        = string
}

variable "prefix" {
  description = "(Optional) Prefix to set for the resource names. Defaults to 'az'."
  type        = string
  default     = "z"
}

variable "environment" {
  description = "(Required) Numerical representation of the environment"
  type        = string
  validation {
    condition     = contains(["uat", "dev", "prod", "qa"], lower(var.environment))
    error_message = "Environment must be of values uat, dev, qa or prod."
  }
}

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

variable "tags" {
  description = "(Optional) Additional tags to apply to the resource."
  type        = map(any)
  default     = {}
}


#
# Key Vault parameters
# ---------------------------
variable "sku_name" {
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

variable "application_name" {
  description = "(Required) Product/Application name which will be set as tag per policy."
  type        = string
}

variable "short_app_name" {
  description = "(Required) Shortened Product/Application name which will be used as body of the name."
  type        = string
}

variable "appservice_plan_name" {
  description = "(Required) App Service Plan Name for the App Service."
  type        = string
}
variable "appservice_plan_resource_group_name" {
  description = "(Required) App Service Plan Resource Group Name."
  type        = string
}
variable "appservice_type" {
  type        = string
  description = "(Required) Type of App Service to create. Possible values include: 'web' or 'function'."
  validation {
    condition     = contains(["web", "function"], lower(var.appservice_type))
    error_message = "App Service type must be one of the following: 'web' or 'function'."
  }
}
 variable "zone_name" {
  type        = string
  description = "(Required) DNS Zone Name."
  default     = null
 }

# 5.3 - region must be East US 2, or CentralUS for DR

#
# Key Vault parameters
# --------------------------



#
# Data Layer Variables
# - storage account, mssql server, mssql database, mssql firewall rule (tbd)
# ---------------------------------------------
variable "db_enabled" {
  type        = bool
  description = "(Optional) Specify whether to create a MSSQL resource or not. Defaults to true."
  default     = true
}
variable "identity_type" {
  type        = string
  description = "(Optional) The type of identity to use for the resource. Possible values are SystemAssigned, UserAssigned, None. Defaults to None."
  default     = ""
}
variable "identity_ids" {
  type        = set(string)
  description = "(Optional) The identity IDs to use for the Azure SQL Server. Valid values are: SystemAssigned, UserAssigned, None"
  default     = []
}

variable "azuread_administrator_group_name" {
  type        = string
  description = "(Required) AAD group name to assign as administrator for the Azure SQL Server."
}

variable "subnet_id" {
  type        = string
  description = "(Required) Subnet ID for VNET Integration."
}
variable "lz_subnet_id" {
  type        = string
  description = "(Required) Subnet ID for VNET Integration."
}
