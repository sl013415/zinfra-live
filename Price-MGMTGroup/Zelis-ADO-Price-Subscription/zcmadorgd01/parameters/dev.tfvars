# Naming and Tagging Vars
location         = "eastus2"
resource_group_name = "zcmadorgd01"
subnet_id = "/subscriptions/a717d281-8389-448e-832b-3f5f1a7de11b/resourceGroups/zcmadorgnetp01/providers/Microsoft.Network/virtualNetworks/zcmadovnnetp01/subnets/ADO-AppConfig-NonProd"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
# # App Config Vars
account_replication_type = "ZRS"
# appservice_type    = "web"
env ="nonprod"
workspace_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/zccsrgd/providers/Microsoft.OperationalInsights/workspaces/workspace-zccsrgd-eus2"

# # Data Vars
#azuread_administrator_group_name = "Zelis DBA Group"
tags = {
location = "us-east2"
environment-stage = "development"
product = "PRIZM"
cost-center = ""
organizational-owner = "CCS"
application-owner = "CCS-DevOps@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "06/14/2024"
data-classification = "internal"
deployment-method = "IaC"
}
db_enabled = "true"
cert_enabled = "true"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
