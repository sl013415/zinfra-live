

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

  variable "sku_name" {
   type        = string
   description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
   default     = "standard"
 }

 variable "env" {
   type = string
   
 }

variable "workspace_id" {
  type        = string
  description = "(Optional) Specifies the id of a log analytics workspace resource"
  default     = null
}
variable "account_tier" {
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard"
}
variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}

   


