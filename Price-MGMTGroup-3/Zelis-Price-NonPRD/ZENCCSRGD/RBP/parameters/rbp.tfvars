# Naming and Tagging Vars
location         = "eastus2"
resource_group_name = "ZCCSRGD"
subnet_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/zcmrgnetd01/providers/Microsoft.Network/virtualNetworks/zcmvnnetd01/subnets/PaaSApp-Integration-Net-Dev-2"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"

# # App Config Vars
appservice_plan_name                = "zenccsapsd03"
appservice_plan_resource_group_name = "ZCCSRGD"

# appservice_type    = "web"
workspace_id ="/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/ZCCSRGD/providers/Microsoft.OperationalInsights/workspaces/Workspace-ZCCSRGD-EUS2"
account_replication_type = "GRS"
account_tier = "Standard"
env = "nonprod"
storage_account_id ="/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/ZCCSRGD/providers/Microsoft.Storage/storageAccounts/zcmrbplogstrd01"

# # Data Vars
azuread_administrator_group_name = "Zelis DBA Group"

# # tags
tags = {
location = "us-east2"
environment = "dev"
app-name = "RBP"
cost-center = ""
organizational-owner = "CCS"
application-owner = "CCS-DevOps@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "12/04/2023"
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

db_enabled = "true"
cert_enabled = "false"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "20.119.144.7"
zone_name = "zelis.com"
application_name = "zcmrbppctadmaad01"
record_type = "CNAME"

rbp_bb = {
    app_name = "zcmrbpbbaad01"
    ai_name = "zcmrbpbbaid01"
    custom_dns_1 = "zcmrbpbbaad01.zelis.com"
    custom_dns_2 = "rbp-benchmark-broker-dev.zelis.com"
}

rbp_ers = {
    app_name = "zcmrbpersaad01"
    ai_name = "zcmrbpersaid01"
    custom_dns_1 = "zcmrbpersaad01.zelis.com"
}

rbp_ptn_kv = "zcmrbpptnkvd01" 