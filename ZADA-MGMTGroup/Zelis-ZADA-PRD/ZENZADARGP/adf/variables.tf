

variable "location" {
  type        = string
  description = "(Required) The Azure region to deploy to. Recommendation is to set to the same location as the resource group."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Name of an existing resource group to deploy Private Endpoint."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource"
  default     = {}
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

