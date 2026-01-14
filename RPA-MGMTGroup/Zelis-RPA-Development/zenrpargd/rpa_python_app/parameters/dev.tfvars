# Naming and Tagging Vars
application_name = "RPA Python"
short_app_name   = "enrpa"
location         = "eastus2"

product_id  = "RPA Python"
environment = "dev"
organization_name = "ENterprise"
short_org_name    = "enrpa"
#Network Config Vars
subnet_id = "/subscriptions/a83e8185-1a93-47ea-b589-273f5cf62d49/resourceGroups/zenpargnetd01/providers/Microsoft.Network/virtualNetworks/zenpavnnetd01/subnets/PaaSApp-Integration-Net-Dev"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
zone_name = "testdomain.poc"
# App Config Vars
appservice_plan_name                = "zenrpaaspd01"
appservice_plan_resource_group_name = "zenrpargd01"
appservice_type    = "web"


# Data Vars
azuread_administrator_group_name = "Zelis DBA Group"
tags = {
      
location = "us-east2"
environment = "dev"
app-name = ""
cost-center = ""
organizational-owner = "RPA"
application-owner = "RPA@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "07/18/2023"
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