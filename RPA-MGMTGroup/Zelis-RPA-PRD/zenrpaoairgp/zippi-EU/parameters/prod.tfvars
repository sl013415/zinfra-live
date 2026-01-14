location         = "eastus"
resource_group_name = "zenrpaoairgp"
name                = "zenrpacbcgsp11"
sku                 = "basic"
sku_name = "Basic"
partition_count = 1
replica_count = 1
redis_cache_name = "zenrpacbrcp11"
capacity = 1
family = "C"
local_authentication_enabled = true
authentication_failure_mode  = "http403"
virtual_network_name = "zenpargnetp03"
virtual_network_resource_group_name="zenpargnetp01"
private_endpoint_name = "zenrpacbpep11"
subnet_name = "OAI-Net-PRD-EastUS"
subnet_id = "/subscriptions/c547b5ba-d67e-413c-a4b8-de7a87097bd9/resourceGroups/zenpargnetp01/providers/Microsoft.Network/virtualNetworks/zenpargnetp03/subnets/PaaSApp-Integration-Net-PRD-linux-EastUS"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
private_service_connection_name = "zenrpacbpscp11"
subresource_names = ["searchService"]
redis_cache_private_service_connection_name = "zenrpacbrcpscp11"
redis_cache_subresource_names = ["redisCache"]
redis_cache_private_endpoint_name = "zenrpacbrcpep11"
sql_server_name = "zenrpacbsqlp11"
cosmosdb_account_name = "zenrpacbcosp11"
storage_account_name = "zenrpacbstrp11"
data_factory_name = "zenrpaadfp11"
app_insights_name = "zenrpacbbeaip11"
key_vault_name ="zenrpacbkvp11"
account_name = "zenrpaoaip11"
workspace_id = "/subscriptions/c547b5ba-d67e-413c-a4b8-de7a87097bd9/resourceGroups/zenrpaoairgp/providers/Microsoft.OperationalInsights/workspaces/zenrpalawsp11"
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
location = "us-east"
environment = "prd"
app-name = "OAI"
cost-center = ""
organizational-owner = "RPA"
application-owner = "RPA@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "12/15/2023"
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
 appservice_plan_name                = "zenrpaapsp12"
 appservice_plan_resource_group_name = "zenrpargp"
 cert_enabled = "false"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
#custom_domain_verification_id = "20.22.102.82"
zone_name = "zelis.com"
application_name = "zenrpacbfewap11"
record_type = "CNAME"
deployment = {
#     gpt4T = {
#       name = "gpt4T"
#      model_format    = "OpenAI"
#     model_name     = "gpt-4"
#     model_version  = "1106-Preview"
#     scale_type      = "Standard"
#     },
    gpt35T_16k = {
      name = "gpt35T_16k"
     model_format    = "OpenAI"
    model_name     = "gpt-35-turbo-16k"
    model_version  = "0613"
    scale_type      = "Standard"
    }
  }