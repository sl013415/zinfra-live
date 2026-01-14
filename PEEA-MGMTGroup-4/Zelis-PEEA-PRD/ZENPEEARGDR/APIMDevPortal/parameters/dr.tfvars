# Naming and Tagging Vars
location         = "centralus"
resource_group_name = "ZENPEEARGDR"
custom_domain_verification_id = "delightful-wave-0f465ce10.3.azurestaticapps.net"
subnet_name = "PaaSApp-Integration-Net-PRD-Static"
virtual_network_name ="zenpevnnetp02"
virtual_network_resource_group_name = "zenpergnetp02"
subnet_id = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp02/providers/Microsoft.Network/virtualNetworks/zenpevnnetp02/subnets/PaaSApp-Integration-Net-PRD"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust"
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust" 
workspace_id = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpeeargp/providers/Microsoft.OperationalInsights/workspaces/zenpeealawsp01"
env ="prod"
# # App Config Vars
appservice_plan_name                = "ZENPEEAASPDR01"
appservice_plan_resource_group_name = "ZENPEEARGDR"
# appservice_type    = "web"


# # Data Vars
#azuread_administrator_group_name = "Zelis DBA Group"
tags = {     
location = "us-central"
environment = "dr"
app-name = "APIM"
cost-center = ""
organizational-owner = "PEEA"
application-owner = "peeateam@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "09/08/2023"
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

shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
zone_name = "zelis.com"
application_name = "zenapimdpfadr01"
record_type = "CNAME"
cert_enabled = "false"
