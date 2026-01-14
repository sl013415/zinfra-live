

module "Windows-appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "ZENPEEAASPP01"

  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name = "P1v2"
  os_type  = "Windows"
  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
     res-function = "WindowsAppSVCPlan"
    }
  )
}
module "Linux-appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "ZENPEEAASPP02"

  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name = "S1"
  os_type  = "Linux"
  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

   tags = merge(
    var.tags,
    {
      res-function = "LinuxAppSVCPlan"
    }
  )
}