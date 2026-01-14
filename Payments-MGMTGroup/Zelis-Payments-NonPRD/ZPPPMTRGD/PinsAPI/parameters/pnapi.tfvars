# Naming and Tagging Vars
resource_group_name = "ZPPPMTRGD"
location         = "eastus2"

# Storage Account
storage_account_name = "zpppnapistrd01"
env = "nonprod"

# App Service Config Vars
appservice_plan_resource_group_name = "ZPPPMTRGD"
appservice_plan_name                = "zpppnapiaspd01"
# appservice_type    = "web"

# App Service - Windows
subnet_id = "/subscriptions/19519360-08c5-4bf0-ab37-5b4a7c811f16/resourceGroups/zpprgnetd01/providers/Microsoft.Network/virtualNetworks/zppmvnnetd01/subnets/PaaSApp-Integration-Net-Dev-3"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 




# Naming and Tagging Vars
tags = {
location = "us-east2"
environment = "dev"
app-name = "PinsAPI"
cost-center = ""
organizational-owner = "PMT"
application-owner = ""
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "12/05/2023"
data-classification = ""
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

cert_enabled = "true"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "zpppnapiaad01.azurewebsites.net"
zone_name = "zelis.com"
application_name = "zpppnapiaad01"
record_type = "CNAME"