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
 variable "identity_type" {
   type        = string
   description = "(Optional) The type of identity to use for the resource. Possible values are SystemAssigned, UserAssigned, None. Defaults to None."
   default     = ""
 }


 variable "azuread_administrator_group_name" {
   type        = string
   description = "(Required) AAD group name to assign as administrator for the Azure SQL Server."
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
 
 variable "azuread_authentication_only" {
  type        = bool
  description = "(Optional) Specifies whether only AD Users and administrators (e.g. azuread_administrator.0.login_username) can be used to login, or also local database users (e.g. administrator_login). When true, the administrator_login and administrator_login_password properties can be omitted"
  default     = true
}


#ADF
variable "name" {
  description = " Name for VM"
  type        = string
}
variable "virtual_network_resource_group_name" {
  description = "(Required) virtual_network_resource_group_name"
  type        = string
}
variable "virtual_network_name" {
  description = "(Required) virtual_network_name"
  type        = string
}
variable "subnet_name" {
  type = string
  description = "(Required) Name of the subnet"
}