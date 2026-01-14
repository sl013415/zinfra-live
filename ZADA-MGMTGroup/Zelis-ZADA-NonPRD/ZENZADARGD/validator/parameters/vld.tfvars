
location         = "eastus2"
resource_group_name = "ZENZADARGD"
subnet_id = "/subscriptions/f852f855-7d2d-4ceb-87b2-77e1db6263e6/resourceGroups/zendargnetd01/providers/Microsoft.Network/virtualNetworks/zendavnnetd01/subnets/PaaSApp-Integration-Net-Dev"
 azuread_administrator_group_name = "Zelis DBA Group"
 env = "nonprod"
 tags= {
        Product= "ADF",
        business-unit= "ZDI",
        compliance-framework= "PCI",
        application-owner= "ZeDWSupport@zelis.com"
        engineering-owner   = "dl-azure_support@zelis.com"
        environment-stage   = "development"
    }
db_enabled = "true"
azuread_authentication_only = false

# shared_key_vault_name = "ZENINFKVP01"
# shared_key_vault_resource_group_name = "ZENINFKV"
# wildcard_cert_name = "ExternalAppSvcZelisWC"
# custom_domain_verification_id = "20.22.102.76"
# zone_name = "zelis.com"
# application_name = "zenjapifap01"
# record_type = "A"
