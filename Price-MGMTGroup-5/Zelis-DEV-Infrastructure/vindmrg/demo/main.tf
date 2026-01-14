
#
# Create the Environment RG
# ===============================================
module "app-rg" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-resourcegroup"
  name     = "vindmrg"
  location = var.location
  tags = merge(
    var.tags,
    {
      res-function = "Resource-Group"
    }
  )
}

module "Windows-appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "vinapsdm01"

  resource_group_name = module.app-rg.name
  location            = module.app-rg.location

  sku_name = "S2"
  os_type  = "Windows"
  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
      res-function = "Windows-App-SVC-Plan"
    }
  )
}




 module "app-insights" {
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

   name                = "vinaidm01"
   resource_group_name = module.app-rg.name
   location            = module.app-rg.location

   workspace_id = null

   tags = merge(
    var.tags,
    {
      res-function = "App Insights"
    }
  )
 }


 
module "storage-account" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-storage"

  name                = "vinstrdm01"
  resource_group_name = module.app-rg.name
  location            = module.app-rg.location
  account_tier = "Standard"
  tags = merge(
    var.tags,
    { 
      res-function = "Storage-Account"
    }
  )
}

#  module "win_demo_app" {
#    source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-windows-appservice"
  

#    appservice_type = "web"
#    subnet_id       = var.subnet_id
#    name                                = "vindm02"
#    appservice_plan_name                =  var.appservice_plan_name
#    appservice_plan_resource_group_name =  var.appservice_plan_resource_group_name
#    storage_account_id = "/subscriptions/f64ca80b-42ff-479f-96db-69b4e50f5703/resourceGroups/vintestvm/providers/Microsoft.Storage/storageAccounts/vinteststrdiag"
#    health_check_path ="/api/v1.0/pings"
#    health_check_eviction_time_in_min = "5"
#    resource_group_name = var.resource_group_name
#    location            = var.location
#    #scm_ip_restriction = local.ip_whitelist
#    env = var.env
#    ip_restriction = {
#      "LZ Subnet" = {
#        priority                  = 200
#        action                    = "Allow"
#        virtual_network_subnet_id = var.lz_subnet_id
#      },
#        "LZ DR Subnet" = {
#        priority                  = 210
#        action                    = "Allow"
#        virtual_network_subnet_id = var.lz_DR_subnet_id
#      }
#    }

#   application_stack = {
#      dotnet_version  = "v6.0"
#     current_stack  = "dotnet"
#    }


#     tags = merge(
#     var.tags,
#     {
#      res-function = "WebApp"
#     }
#   )
#  }

 # added comment