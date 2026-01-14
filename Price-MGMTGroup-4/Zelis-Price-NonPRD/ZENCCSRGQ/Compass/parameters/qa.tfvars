location         = "eastus2"
resource_group_name = "ZCCSRGQ"
 subnet_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/zcmrgnetd01/providers/Microsoft.Network/virtualNetworks/zcmvnnetd01/subnets/PaaSApp-Integration-Net-QA"
 lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
# # App Config Vars
#account_replication_type = "ZRS"
 appservice_plan_name                = "zenccsapsq01"
 appservice_plan_resource_group_name = "ZCCSRGQ"
# appservice_type    = "web"
env ="nonprod"
workspace_id = "/subscriptions/28d5fce1-5074-44b5-b372-6738d84565aa/resourceGroups/zccsrgd/providers/Microsoft.OperationalInsights/workspaces/workspace-zccsrgd-eus2"

# # Data Vars
#azuread_administrator_group_name = "Zelis DBA Group"
 tags= {
        Product= "Compass",
        business-unit= "PRICEOPTIMIZATION",
        compliance-framework= "HIPAA",
        application-owner= "CCS-DevOps@zelis.com",
        engineering-owner   = "dl-azure_support@zelis.com",
        environment-stage   = "development"
    }
#db_enabled = "true"
cert_enabled = "false"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "zcmcmpfaq01.azurewebsites.net"
zone_name = "zelis.com"
application_name = "zcmcmpfaq01"
record_type = "CNAME"