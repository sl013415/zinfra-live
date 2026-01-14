module "redis_cache" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_redis_cache"

  name                = var.redis_cache_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku_name
  capacity = var.capacity
  family = var.family
  tags = merge(
    var.tags,
    {
     res-function = "RedisCache"
    }
  )
}

module "private_endpoint_redis" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_private_endpoint"
  depends_on = [
    module.redis_cache
  ]
virtual_network_name = var.virtual_network_name
virtual_network_resource_group_name= var.virtual_network_resource_group_name
private_endpoint_name = var.redis_cache_private_endpoint_name
subnet_name = var.subnet_name
location            = var.location
resource_group_name = var.resource_group_name
private_service_connection_name = var.redis_cache_private_service_connection_name
private_connection_resource_id = module.redis_cache.id
subresource_names = var.redis_cache_subresource_names
 tags = merge(
    var.tags,
    {
     res-function = "PrivateEndpoint"
    }
  )
  
}