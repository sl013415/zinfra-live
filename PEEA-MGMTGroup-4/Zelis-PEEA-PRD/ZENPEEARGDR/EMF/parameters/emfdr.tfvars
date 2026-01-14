# Naming and Tagging Vars
location         = "centralus"
resource_group_name = "ZENPEEARGDR"
 subnet_id = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp02/providers/Microsoft.Network/virtualNetworks/zenpevnnetp02/subnets/PaaSApp-Integration-Net-PRD"
 lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
# zone_name = "testdomain.poc"
# # App Config Vars
 appservice_plan_name                = "ZENPEEAASPDR01"
 appservice_plan_resource_group_name = "ZENPEEARGDR"
# appservice_type    = "web"


# # Data Vars
 azuread_administrator_group_name = "Zelis DBA Group"
tags = {
location = "us-east2"
environment = "dr"
app-name = ""
cost-center = ""
organizational-owner = "PEEA"
application-owner = "peeateam@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "01/27/2023"
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
shared_key_vault_name = "ZENINFKVDR01"
shared_key_vault_resource_group_name = "ZENEETDRRGP"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "zenemffadr01.azurewebsites.net"
zone_name = "zelis.com"
application_name = "zenemffadr01"
record_type = "CNAME"
cert_enabled = "true"