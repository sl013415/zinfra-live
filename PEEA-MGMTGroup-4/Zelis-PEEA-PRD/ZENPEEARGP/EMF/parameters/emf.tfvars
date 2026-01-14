# Naming and Tagging Vars
location         = "eastus2"
resource_group_name = "ZENPEEARGP"
 subnet_id = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp01/providers/Microsoft.Network/virtualNetworks/zenpevnnetp01/subnets/PaaSApp-Integration-Net-PRD"
 lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
# zone_name = "testdomain.poc"
# # App Config Vars
 appservice_plan_name                = "ZENPEEAASPP01"
 appservice_plan_resource_group_name = "ZENPEEARGP"
# appservice_type    = "web"


# # Data Vars
 azuread_administrator_group_name = "Zelis DBA Group"
tags = {
      Application = "EMF"
      Product_ID  = "Enterprise PEEA"
      Used_for    = "Production"
    }

db_enabled = "true"
cert_enabled = "true"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "ZENEMFFAP01.azurewebsites.net"
zone_name = "zelis.com"
application_name = "ZENEMFFAP01"
record_type = "CNAME"