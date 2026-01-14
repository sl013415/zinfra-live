

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


  variable "subscription_name" {
   description = "(Required) Subscription Name."
   type        = string
 }

 
  variable "billing_account_name" {
   description = "(Required) Billing account Name."
   type        = string
 }

  variable "billing_profile_name" {
   description = "(Required) Billing Profile Name."
   type        = string
 }

 
  variable "invoice_section_name" {
   description = "(Required) Invoice_section_name"
   type        = string
 }

 variable "workload" {
   description = "Workload"
   type = string
 }
 


