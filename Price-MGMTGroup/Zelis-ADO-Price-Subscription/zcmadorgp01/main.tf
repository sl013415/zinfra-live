
#
# Create the Environment RG
# ===============================================
module "storage-account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-storage"

  name                = "zccsadostrp01"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env

  tags = merge(
    var.tags,
    { 
      res-function = "StorageAccount"
    }
  )
}

 module "app-kv" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-key-vault"

  name = "zccsadokvp01"
  env = var.env
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name      = var.sku_name
  access_policy = var.access_policy
  tags = merge(
    var.tags,
    { 
      res-function = "KeyVault"
    }
  )
}



