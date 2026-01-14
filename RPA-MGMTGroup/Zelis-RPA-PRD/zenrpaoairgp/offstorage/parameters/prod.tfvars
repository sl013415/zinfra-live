location         = "eastus2"
resource_group_name = "zenrpaoairgp"
name                = "zenrpacbcgsp01"
virtual_network_name = "zenpavnnetp01"
virtual_network_resource_group_name="zenpargnetp01"
subnet_name = "OAI-Net-PRD"
subnet_id = "/subscriptions/c547b5ba-d67e-413c-a4b8-de7a87097bd9/resourceGroups/zenpargnetp01/providers/Microsoft.Network/virtualNetworks/zenpavnnetp01/subnets/PaaSApp-Integration-Net-PRD-linux"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
storage_account_name = "zenrpaoffstrp01"
key_vault_name ="zenrpacbkvp01"
account_name = "zenrpaoaip01"
workspace_id = "/subscriptions/c547b5ba-d67e-413c-a4b8-de7a87097bd9/resourceGroups/zenrpargp/providers/Microsoft.OperationalInsights/workspaces/zenrpalawsp01"

env = "prod"

# Naming and Tagging Vars
tags = {
location = "us-east2"
environment = "prd"
app-name = "OAI"
cost-center = ""
organizational-owner = "RPA"
application-owner = "RPA@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "09/24/2024"
data-classification = "internal"
deployment-method = "IaC"
 }
 