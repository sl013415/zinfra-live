data "azurerm_client_config" "current" {}
module "network_restriction_policy"{
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//network_restriction"
  env = var.env
  subscriptionid = data.azurerm_client_config.current.subscription_id
}
locals {
  ip_whitelist = module.network_restriction_policy.ip_whitelist
  subnet_list = concat(module.network_restriction_policy.wvd_subnets , module.network_restriction_policy.iaas_subnets )
  vnet_integrated_whitelist = {

  for item in local.subnet_list  : item.name => {

    action = "Allow"

    virtual_network_subnet_id = item.id

}
  }
allowed_ip_list = {for k, v in local.ip_whitelist : k => {
 #ip_address = trimsuffix(v.ip_address, "/32")
 ip_address =v.ip_address
 action = v.action
 priority = v.priority
 } 
 }
webapp_network_restriction = merge(local.vnet_integrated_whitelist , local.allowed_ip_list)
subnet_ids = [
  for subnet in local.subnet_list: 
subnet.id

]
ip_rules = [ for k,v in  local.ip_whitelist : trimsuffix(v.ip_address, "/32")]
  key_vault_network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = local.ip_rules
    virtual_network_subnet_ids = local.subnet_ids
  }
  storage_account_network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = local.ip_rules
    subnet_ids = local.subnet_ids
  }
}
module "storage-account_oracle" {
  source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-storage"

  name                = "zcmorbkstrp01"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier = "Standard"
  account_replication_type = var.account_replication_type
  network_rules = local.storage_account_network_rules
  env = var.env

  tags = merge(
    var.tags,
    { 
      res-function = "StorageAccount"
    }
  )
}