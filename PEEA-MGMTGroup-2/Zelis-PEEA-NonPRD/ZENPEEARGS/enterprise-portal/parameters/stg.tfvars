# Naming and Tagging Vars
location         = "eastus2"
env = "nonprod"
resource_group_name = "ZENPEEARGS"
subnet_id = "/subscriptions/5bf88ae2-570b-483c-95d4-018309ae1682/resourceGroups/zenpergnetd01/providers/Microsoft.Network/virtualNetworks/zenpevnnetd01/subnets/PaaSApp-Integration-Net-STG"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
vnet_name = "zenpevnnetd01"
subnet_name = "PaaSApp-Integration-Net-STG-Static"
virtual_network_resource_group_name = "zenpergnetd01"

# zone_name = "testdomain.poc"
# # App Config Vars
appservice_plan_name                = "ZENPEEAASPS01"
appservice_plan_resource_group_name = "ZENPEEARGS"
# appservice_type    = "web"


# # Data Vars
#azuread_administrator_group_name = "Zelis DBA Group"
tags = {
      Product_ID  = "Enterprise Portal"
      Used_for    = "Staging"
      Support_group = "IS - Operations"
      Supported_by = "Dave Staudenmaier"
    }
db_enabled = "true"
cert_enabled = "true"
azuread_administrator_group_name = "Zelis DBA Group"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "20.22.102.74"
zone_name = "zelis.com"
application_name = "zeneppfas01"
record_type = "A"
static_webapp_private_service_connection_name = "zeneppscs01"
static_webapp_private_endpoint_name="zeneppepss01"
static_webapp_subresource_names = ["staticSites"]