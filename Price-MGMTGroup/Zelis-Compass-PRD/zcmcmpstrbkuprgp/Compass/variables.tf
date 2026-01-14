

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

  variable "env" {
   description = "(Required) Environments for network restrictions."
   type        = string
 }


  variable "resource_group_name" {
   description = "(Required) Resource Group Name."
   type        = string
 }
variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}