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

variable "redis_cache_private_endpoint_name" {
  description = "(Required) Name for Private Endpoint for redis_cache "
  type        = string
}
variable "redis_cache_private_service_connection_name" {
  type        = string
  description = "(Required) Name of private service connection name for redis_cache."
}

variable "redis_cache_subresource_names" {
  type        = list(string)
  description = "(Required) List of an subresource_names to link Private Endpoint to redis_cache."
}


variable "redis_cache_name" {
  description = "(Required) Name for redis cache"
  type        = string
}


variable "sku_name" {
  type        = string
  description = "Sku for Redis Cache."
}


variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource"
  default     = {}
}
variable "capacity" {
  type        = string
  description = "capacity for Redis Cache."
}
variable "family" {
  type        = string
  description = "family for Redis Cache."
}
