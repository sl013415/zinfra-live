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
#azuread_administrator_group_name = "Zelis DBA Group"
tags = {
      Product_ID  = "Enterprise Portal"
      Used_for    = "Disaster Recovery"
      Support_group = "IS - Operations"
      Supported_by = "Dave Staudenmaier"
    }
db_enabled = "true"
#kind = "GlobalDocumentDB"
azuread_administrator_group_name = "Zelis DBA Group"
shared_key_vault_name = "ZENINFKVDR01"
shared_key_vault_resource_group_name = "ZENEETDRRGP"
wildcard_cert_name = "ExternalAppSvcZelisWC"
#custom_domain_verification_id = "20.84.141.5"
zone_name = "zelis.com"
application_name = "zeneppcnefadr01"
record_type = "CNAME"
cert_enabled = "false"
env = "prod"
custom_domain_verification_id = "zeneppcnefadr01.azurewebsites.net"