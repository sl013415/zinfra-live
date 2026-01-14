# Naming and Tagging Vars
location         = "eastus2"
resource_group_name = "zenrpargu"
 subnet_id = "/subscriptions/a83e8185-1a93-47ea-b589-273f5cf62d49/resourceGroups/zenpargnetd01/providers/Microsoft.Network/virtualNetworks/zenpavnnetd01/subnets/PaaSApp-Integration-Net-UAT-Linux"
 lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
# zone_name = "testdomain.poc"
# # App Config Vars
 appservice_plan_name                = "zenrpaapsu02"
 appservice_plan_resource_group_name = "zenrpargu"
# appservice_type    = "web"


# # Data Vars
 azuread_administrator_group_name = "Zelis DBA Group"
tags = {
      Product_ID  = "RPA"
      Used_for    = "UAT"
        Support_group = "IS - Operations"
      Supported_by = "Michael Halpin"
    }
db_enabled = "true"
cert_enabled = "true"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "zenpyappwau01.azurewebsites.net"
zone_name = "zelis.com"
application_name = "zenpyappwau01"
record_type = "CNAME"