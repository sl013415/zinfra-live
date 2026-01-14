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

variable "resource_group_name" {
  type        = string
  description = "(Required) Name of an existing resource group to deploy Private Endpoint."
}





variable "name" {
  description = "(Required) Name for Cognitive search"
  type        = string
}

variable "key_vault_name" {
  description = "(Required) key_vault_name which will be set as tag per policy."
  type        = string
}

variable "kv_sku_name" {
  type        = string
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  default     = "standard"
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
  default     = "Standard"
}
variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "ZRS"
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


variable "storage_account_id" {
  type        = string
  description = "(Required)storage_account_id  for storing diagnostic setting for  web App or function App."
  default     = "ZRS"
}


