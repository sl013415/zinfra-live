
location         = "eastus2"
resource_group_name = "ZENPEEARGD"
subnet_id = "/subscriptions/5bf88ae2-570b-483c-95d4-018309ae1682/resourceGroups/zenpergnetd01/providers/Microsoft.Network/virtualNetworks/zenpevnnetd01/subnets/PaaSApp-Integration-Net-Dev"
lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
appservice_plan_name                = "ZENPEEAASPD01"
appservice_plan_resource_group_name = "ZENPEEARGD"

tags = {
      Product_ID  = "JiraAPI"
      Used_for    = "Dev"
      Support_group = "IS - Operations"
      Supported_by = "Dave Staudenmaier"
    }
db_enabled = "true"


shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "20.22.102.9"
zone_name = "zelis.com"
application_name = "zenjapifad01"
record_type = "A"
