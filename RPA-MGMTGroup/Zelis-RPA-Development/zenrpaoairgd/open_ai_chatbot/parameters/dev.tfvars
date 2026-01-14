location         = "eastus2"
resource_group_name = "zenrpaoairgd"
name                = "zenrpacbcgsd01"
sku                 = "basic"
sku_name = "Basic"
partition_count = 1
replica_count = 1
redis_cache_name = "zenrpacbrcd01"
capacity = 1
family = "C"
local_authentication_enabled = true
authentication_failure_mode  = "http403"
virtual_network_name = "zenpavnnetd01"
virtual_network_resource_group_name="zenpargnetd01"
private_endpoint_name = "zenrpacbped01"
subnet_name = "OAI-Net-DEV"
subnet_id = "/subscriptions/a83e8185-1a93-47ea-b589-273f5cf62d49/resourceGroups/zenpargnetd01/providers/Microsoft.Network/virtualNetworks/zenpavnnetd01/subnets/PaaSApp-Integration-Net-Dev-linux"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
private_service_connection_name = "zenrpacbpscd01"
subresource_names = ["searchService"]
redis_cache_private_service_connection_name = "zenrpacbrcpscd01"
redis_cache_subresource_names = ["redisCache"]
redis_cache_private_endpoint_name = "zenrpacbrcped01"
sql_server_name = "zenrpacbsqld01"
cosmosdb_account_name = "zenrpacbcosd01"
storage_account_name = "zenrpacbstrd01"
data_factory_name = "zenrpaadfd01"
app_insights_name = "zenrpacbbeaid01"
workspace_id = "/subscriptions/a83e8185-1a93-47ea-b589-273f5cf62d49/resourceGroups/zenrpargd01/providers/Microsoft.OperationalInsights/workspaces/zenrpalawsd01"
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
      "storage_account_type" : "Local",
      "create_mode": "Default"
       }
       }

# # Data Vars
azuread_administrator_group_name = "Zelis DBA Group"
# Naming and Tagging Vars
 tags= {
        Product= "Open AI",
        business-unit= "ZEIT",
        compliance-framework= "PCI",
        application-owner= "RPA@zelis.com"
        engineering-owner   = "dl-azure_support@zelis.com"
        environment-stage   = "development"
    }

 appservice_plan_name                = "zenrpaaspd02"
 appservice_plan_resource_group_name = "zenrpargd01"
 cert_enabled = "true"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
#custom_domain_verification_id = "20.22.102.82"
zone_name = "zelis.com"
application_name = "zenrpacbfewad01"
record_type = "CNAME"