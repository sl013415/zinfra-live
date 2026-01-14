locals {

  ip_whitelist = jsondecode(file("${path.module}/static/ip_whitelist.json"))

  allowed_ip_list = [for k, v in local.ip_whitelist : trimsuffix(v.ip_address, "/32") if v.action == "Allow"]
  key_vault_network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = local.allowed_ip_list
    virtual_network_subnet_ids = null # [var.subnet_id] Subnet requires service endpoints (SubnetsHaveNoServiceEndpointsConfigured)
  }
  storage_account_network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = local.allowed_ip_list
    subnet_ids = null # [var.subnet_id] Subnet requires service endpoints (SubnetsHaveNoServiceEndpointsConfigured)
  }
}
# module "azurecaf-app" {
#   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules/azurecaf-naming"

#   product_id = "Enterprise"
#   resource_types = [
#     "azurerm_resource_group",
#     "azurerm_app_service_plan",
#     "azurerm_key_vault",
#     "azurerm_application_insights",
#     "azurerm_storage_account",
#   ]
#   location = var.location

#   prefix                 = var.prefix
#   short_application_name = var.short_org_name
#   application_name       = var.organization_name
#   environment            = var.environment
# }

#
# Create the Environment RG
# ===============================================
module "org-rg" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules/azurerm-resourcegroup"

  name     = "zenrpargd01"
  location = var.location

    tags = merge(
    var.tags,
    {
      res-function = "ResourceGroup"
    }
  )
}

module "appservice-plan" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "zenrpaaspd01"

  resource_group_name = module.org-rg.name
  location            = module.org-rg.location

  sku_name = "B1"
  os_type  = "Windows"

  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
      res-function = "AppSvcPlan"
    }
  )
}
module "appservice-plan-linux" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-appservice-plan"

  name = "zenrpaaspd02"

  resource_group_name = module.org-rg.name
  location            = module.org-rg.location

  sku_name = "B1"
  os_type  = "Linux"

  worker_count             = null
  per_site_scaling_enabled = false
  zone_balancing_enabled   = false

  tags = merge(
    var.tags,
    {
      res-function = "AppSvcPlan"
    }
  )
}


data "azuread_group" "dba_admin" {
  display_name = var.azuread_administrator_group_name
}

module "mssql-server" {
  enabled = var.db_enabled

  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-mssql"


  name                = "zenrpasqld01"
  resource_group_name = module.org-rg.name
  location            = module.org-rg.location

  ip_restriction = local.ip_whitelist

  # Create a managed identity for the Azure SQL Server
  identity_type            = var.identity_type
  azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      res-function = "PAAS-SQL"
    }
  )
}
module "app-insights" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-app-insights"

  name                = "zenrpaaid01"
   resource_group_name = module.org-rg.name
  location            = module.org-rg.location

  workspace_id = null

    tags = merge(
    var.tags,
    {
      res-function = "AppInsights"
    }
  )
}
module "win-webapp" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_linux_web_app"

  appservice_type = var.appservice_type
  subnet_id       = var.subnet_id

  name                                = "zenpyappwad01"
  appservice_plan_name                = var.appservice_plan_name
  appservice_plan_resource_group_name = var.appservice_plan_resource_group_name

  resource_group_name = module.org-rg.name
  location            = module.org-rg.location
  
  # scm_ip_restriction  = var.scm_ip_restriction
  scm_ip_restriction = local.ip_whitelist
  ip_restriction = {
    "NVA Subnet" = {
      priority                  = 200
      action                    = "Allow"
      virtual_network_subnet_id = var.lz_subnet_id
    }
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app-insights.instrumentation_key
  }

  application_stack = {
    python_version = "3.11"
    current_stack  = "python"
  }

    tags = merge(
    var.tags,
    {
      res-function = "WebApp"
    }
  )
}

module "app-kv" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-key-vault"

  name = "zenrpakvd01"

  resource_group_name = module.org-rg.name
  location            = module.org-rg.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  network_acls  = local.key_vault_network_acls
  tags = merge(
    var.tags,
    { 
      res-function = "KeyVault"
    }
  )
}
