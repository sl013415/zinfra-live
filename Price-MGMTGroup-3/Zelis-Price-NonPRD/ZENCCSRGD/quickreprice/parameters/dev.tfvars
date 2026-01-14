
resource_group_name = "ZCCSRGD"
location         = "eastus2"

storage_account_name = "zcmqrstrd01"

app_insights_name = "zcmqraid01"
workspace_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/zccsrgd/providers/Microsoft.OperationalInsights/workspaces/workspace-zccsrgd-eus2"

env ="nonprod"

win_fun_app_name = "zcmqrfad01"

# Naming and Tagging Vars
subnet_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/zcmrgnetd01/providers/Microsoft.Network/virtualNetworks/zcmvnnetd01/subnets/PaaSApp-Integration-Net-Dev-2"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"

#App Service Plan
appservice_plan_name                = "zenccsapsd03"
appservice_plan_resource_group_name = "ZCCSRGD"

#tags
tags = {
location = "us-east2"
environment = "dev"
app-name = "QuickReprice"
cost-center = ""
organizational-owner = "CCS"
application-owner = "CCS-DevOps@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "02/09/2024"
data-classification = "internal"
deployment-method = "IaC"
iac-repo-id = ""
latest-release-version = ""
backup-policy = ""
end-of-life = ""
operating-system = ""
project-id = ""
shutdown-schedule = "None"
}

# Custom DNS
cert_enabled = "false"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
zone_name = "zelis.com"
application_name = "ingest-quickreprice-dev"
custom_domain_verification_id = "zcmqrfad01.azurewebsites.net"
record_type = "CNAME"
