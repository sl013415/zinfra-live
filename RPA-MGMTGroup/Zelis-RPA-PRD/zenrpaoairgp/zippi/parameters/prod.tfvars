location         = "eastus2"
resource_group_name = "zenrpaoairgp"
name                = "zenrpacbcgsp01"
sku                 = "basic"
sku_name = "Basic"
partition_count = 1
replica_count = 1
redis_cache_name = "zenrpacbrcp01"
capacity = 1
family = "C"
local_authentication_enabled = true
authentication_failure_mode  = "http403"
virtual_network_name = "zenpavnnetp01"
virtual_network_resource_group_name="zenpargnetp01"
private_endpoint_name = "zenrpacbpep01"
subnet_name = "OAI-Net-PRD"
subnet_id = "/subscriptions/c547b5ba-d67e-413c-a4b8-de7a87097bd9/resourceGroups/zenpargnetp01/providers/Microsoft.Network/virtualNetworks/zenpavnnetp01/subnets/PaaSApp-Integration-Net-PRD-linux"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
private_service_connection_name = "zenrpacbpscp01"
subresource_names = ["searchService"]
redis_cache_private_service_connection_name = "zenrpacbrcpscp01"
redis_cache_subresource_names = ["redisCache"]
redis_cache_private_endpoint_name = "zenrpacbrcpep01"
sql_server_name = "zenrpacbsqlp01"
cosmosdb_account_name = "zenrpacbcosp01"
storage_account_name = "zenrpacbstrp01"
data_factory_name = "zenrpaadfp01"
app_insights_name = "zenrpacbbeaip01"
key_vault_name ="zenrpacbkvp01"
account_name = "zenrpaoaip01"
workspace_id = "/subscriptions/c547b5ba-d67e-413c-a4b8-de7a87097bd9/resourceGroups/zenrpargp/providers/Microsoft.OperationalInsights/workspaces/zenrpalawsp01"
kind = "GlobalDocumentDB"
env = "prod"
database = { "OAICBDB" : {
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

# # Data Vars
azuread_administrator_group_name = "Zelis DBA Group"
# Naming and Tagging Vars
tags = {
location = "us-east2"
environment = "prd"
app-name = "OAI"
cost-center = ""
organizational-owner = "RPA"
application-owner = "RPA@zelis.com"
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
 appservice_plan_name                = "zenrpaapsp02"
 appservice_plan_resource_group_name = "zenrpargp"
 cert_enabled = "false"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
#custom_domain_verification_id = "20.22.102.82"
zone_name = "zelis.com"
application_name = "zenrpacbfewap01"
record_type = "CNAME"
deployment = {
    gpt4T = {
      name = "gpt4T"
     model_format    = "OpenAI"
    model_name     = "gpt-4"
    model_version  = "1106-Preview"
    scale_type      = "Standard"
    },
    gpt35T_16k = {
      name = "gpt35T_16k"
     model_format    = "OpenAI"
    model_name     = "gpt-35-turbo-16k"
    model_version  = "0613"
    scale_type      = "Standard"
    }
  }