location         = "eastus2"
resource_group_name = "zenrpaoairgu"
name                = "zenrpacbcgsu01"
sku                 = "basic"
sku_name = "Basic"
partition_count = 1
replica_count = 1
redis_cache_name = "zenrpacbrcu01"
capacity = 1
family = "C"
local_authentication_enabled = true
authentication_failure_mode  = "http403"
virtual_network_name = "zenpavnnetnp01"
virtual_network_resource_group_name="zenpargnetnp01"
private_endpoint_name = "zenrpacbpeu01"
subnet_name = "OAI-Net-NonPRD"
subnet_id = "/subscriptions/fb4dc091-1772-420f-aeb9-5b3b0ceaf06a/resourceGroups/zenpargnetnp01/providers/Microsoft.Network/virtualNetworks/zenpavnnetnp01/subnets/PaaSApp-Integration-Net-NonPRD-linux"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
private_service_connection_name = "zenrpacbpscu01"
subresource_names = ["searchService"]
redis_cache_private_service_connection_name = "zenrpacbrcpscu01"
redis_cache_subresource_names = ["redisCache"]
redis_cache_private_endpoint_name = "zenrpacbrcpeu01"
sql_server_name = "zenrpacbsqlu01"
cosmosdb_account_name = "zenrpacbcosu01"
storage_account_name = "zenrpacbstru01"
data_factory_name = "zenrpaadfu01"
app_insights_name = "zenrpacbbeaiu01"
key_vault_name ="zenrpacbkvu01"
account_name = "zenrpaoaiu01"
workspace_id = "/subscriptions/fb4dc091-1772-420f-aeb9-5b3b0ceaf06a/resourceGroups/zenrpargu/providers/Microsoft.OperationalInsights/workspaces/zenrpalawsu01"
kind = "GlobalDocumentDB"
env = "nonprod"
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

 appservice_plan_name                = "zenrpaapsu02"
 appservice_plan_resource_group_name = "zenrpargu"
 cert_enabled = "false"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
#custom_domain_verification_id = "20.22.102.82"
zone_name = "zelis.com"
application_name = "zenrpacbfewau01"
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
  tags= {
        Product= "RPA",
        business-unit= "ZEIT",
        compliance-framework= "PCI",
        application-owner= "dl-azure_support@zelis.com"
        engineering-owner   = "dl-azure_support@zelis.com"
        environment-stage   = "non-production"
    }