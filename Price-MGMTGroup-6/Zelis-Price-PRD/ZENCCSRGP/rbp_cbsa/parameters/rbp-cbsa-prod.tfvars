
resource_group_name = "ZCCSRGP"
location         = "eastus2"

storage_account_name = "zcmrbplogstrp01"

app_insights_name = "zcmrbpcbsaaip01"
workspace_id = "/subscriptions/208d9d5e-b1ba-42e2-9dcf-a3ac58050bc9/resourceGroups/zccsrgp/providers/Microsoft.OperationalInsights/workspaces/ZENCCSLAWSP01"

env ="prod"

win_fun_app_name = "zcmrbpcbsafap01"

# Naming and Tagging Vars
subnet_id = "/subscriptions/208d9d5e-b1ba-42e2-9dcf-a3ac58050bc9/resourceGroups/zcmrgnetp01/providers/Microsoft.Network/virtualNetworks/zcmvnnetp01/subnets/PaaSApp-Integration-Net-2"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"

#App Service Plan
appservice_plan_name                = "zenccsaspp03"
appservice_plan_resource_group_name = "ZCCSRGP"

#tags
tags = {
location = "us-east2"
environment = "prd"
app-name = "RBP-CBSA"
cost-center = ""
organizational-owner = "CCS"
application-owner = "CCS-DevOps@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "02/28/2024"
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
application_name = "zcmrbpcbsafap01"
custom_domain_verification_id = "zcmrbpcbsafap01.azurewebsites.net"
record_type = "CNAME"
