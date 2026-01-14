
module "storage-account" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules/azurerm-storage"
  name                =var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  env = var.env
  is_hns_enabled = true


  tags = merge(
    var.tags,
    { 
     res-function = "Offshore-StorageAccount"
    }
  )
}

