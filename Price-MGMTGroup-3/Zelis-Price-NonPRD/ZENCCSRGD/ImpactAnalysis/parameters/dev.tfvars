
resource_group_name = "ZCCSRGD"
location         = "eastus2"

storage_account_name = "zcmiastrd01"

app_insights_name = "zcmiaaid01"
workspace_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/zccsrgd/providers/Microsoft.OperationalInsights/workspaces/workspace-zccsrgd-eus2"

env ="nonprod"
win_web_app_name = "zcmiarbewad01"
lin_web_app_name = "zcmiarfewad01"
win_fun_app_name = "zcmiarfad01"


# azuread_administrator_group_name = "Zelis DBA Group"

# azuread_authentication_only = false

# db_enabled = "true"

# #ADF
# name   = "zcmiaadfd01"
# virtual_network_resource_group_name  = "zcmrgnetp01"
# virtual_network_name = "zcmvnnetp01"
# subnet_name = "ADF-Integration-IA"




# Naming and Tagging Vars
 subnet_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/zcmrgnetd01/providers/Microsoft.Network/virtualNetworks/zcmvnnetd01/subnets/PaaSApp-Integration-Net-Dev-2"
 lin_subnet_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/zcmrgnetd01/providers/Microsoft.Network/virtualNetworks/zcmvnnetd01/subnets/PaaSApp-Integration-Net-Dev-linux"
 lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
# # App Config Vars
#account_replication_type = "ZRS"
 appservice_plan_name                = "zenccsapsd03"
 appservice_plan_resource_group_name = "ZCCSRGD"

 lin_asp_name = "zenccsapsd02"
 lin_asp_rg_name = "ZCCSRGD"
# appservice_type    = "web/function"


# # Data Vars
#azuread_administrator_group_name = "Zelis DBA Group"

tags = {
location = "us-east2"
environment = "dev"
app-name = "ImpactAnalysisReimagined"
cost-center = ""
organizational-owner = "CCS"
application-owner = "CCS-DevOps@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "01/30/2024"
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
#db_enabled = "true"
cert_enabled = "false"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "zccsspkwad01.azurewebsites.net"
zone_name = "zelis.com"
application_name = ""
record_type = "CNAME"
