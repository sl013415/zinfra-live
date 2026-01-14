

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

  variable "resource_group_name" {
   description = "(Required) Resource Group Name."
   type        = string
 }
# #
# # Key Vault parameters
# # ---------------------------
# variable "sku_name" {
#   type        = string
#   description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
#   default     = "standard"
# }

# variable "access_policy" {
#   description = "(Optional) A list of up to 16 objects describing access policies, as described below."
#   type = list(object({
#     object_id               = string
#     certificate_permissions = list(string)
#     key_permissions         = list(string)
#     secret_permissions      = list(string)
#   }))
#   default = []
# }

 variable "application_name" {
   description = "(Required) Product/Application name which will be set as tag per policy."
   type        = string
 }

# variable "short_app_name" {
#   description = "(Required) Shortened Product/Application name which will be used as body of the name."
#   type        = string
# }

 variable "appservice_plan_name" {
   description = "(Required) App Service Plan Name for the App Service."
   type        = string
 }
 variable "appservice_plan_resource_group_name" {
   description = "(Required) App Service Plan Resource Group Name."
   type        = string
 }
# variable "appservice_type" {
#   type        = string
#   description = "(Required) Type of App Service to create. Possible values include: 'web' or 'function'."
#   validation {
#     condition     = contains(["web", "function"], lower(var.appservice_type))
#     error_message = "App Service type must be one of the following: 'web' or 'function'."
#   }
# }
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

variable "record_type" {
  description = "CNAME or A Record."
  type        = string
}
# # 5.3 - region must be East US 2, or CentralUS for DR

# #
# # Key Vault parameters
# # --------------------------



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
 variable "database" {
  type        = map(any)
  description = "(Optional) Specify whether to create a MSSQL resource or not. Defaults to true."
  default     = {}
}
 variable "identity_type" {
   type        = string
   description = "(Optional) The type of identity to use for the resource. Possible values are SystemAssigned, UserAssigned, None. Defaults to None."
   default     = ""
 }
# variable "identity_ids" {
#   type        = set(string)
#   description = "(Optional) The identity IDs to use for the Azure SQL Server. Valid values are: SystemAssigned, UserAssigned, None"
#   default     = []
# }

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
