# Naming and Tagging Vars
location         = "eastus2"

# product_id  = "RPA Python"
# environment = "dev"
# organization_name = "ENterprise"
# short_org_name    = "enrpa"
# #Network Config Vars
 subnet_id = "/subscriptions/c547b5ba-d67e-413c-a4b8-de7a87097bd9/resourceGroups/zenpargnetp01/providers/Microsoft.Network/virtualNetworks/zenpavnnetp01/subnets/PaaSApp-Integration-Net-PRD-linux"
 lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
# zone_name = "testdomain.poc"
# # App Config Vars
 appservice_plan_name                = "zenrpaapsp02"
 appservice_plan_resource_group_name = "zenrpargp"
 resource_group_name = "zenrpargp"
# appservice_type    = "web"


# # Data Vars
 azuread_administrator_group_name = "Zelis DBA Group"
tags = {
      
location = "us-east2"
environment = "prd"
app-name = ""
cost-center = ""
organizational-owner = "RPA"
application-owner = ""
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "02/14/2023"
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
database = { "zenrpasqldbp01" : {
      "max_size_gb" : "32",
      "collation": "SQL_Latin1_General_CP1_CI_AS",
      "license_type " :"LicenseIncluded",
      "read_scale" : "false"
      "min_capacity" : "1.0"
      "auto_pause_delay_in_minutes" : "-1"
      "sku_name"   : "GP_S_Gen5_2",
      "zone_redundant"   : "false",
      #"elastic_pool_id": "null",
      "create_mode": "Default"
       }
       }

cert_enabled = "true"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "20.22.102.71"
zone_name = "zelis.com"
application_name = "zenpyappwap01"
record_type = "A"