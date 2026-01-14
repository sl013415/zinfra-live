# Naming and Tagging Vars
location         = "centralus"
resource_group_name = "ZCCSRGDR"
 subnet_id = "/subscriptions/208d9d5e-b1ba-42e2-9dcf-a3ac58050bc9/resourceGroups/zcmrgnetp02/providers/Microsoft.Network/virtualNetworks/zcmvnnetp02/subnets/PaaSApp-Integration-Net"
 lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
# # App Config Vars
#account_replication_type = "ZRS"
 appservice_plan_name                = "zenccsapsdr01"
 appservice_plan_resource_group_name = "ZCCSRGDR"
# appservice_type    = "web"
env ="prod"
workspace_id = "/subscriptions/208d9d5e-b1ba-42e2-9dcf-a3ac58050bc9/resourceGroups/zccsrgdr/providers/Microsoft.OperationalInsights/workspaces/zenccslawsdr01"

# # Data Vars
#azuread_administrator_group_name = "Zelis DBA Group"
  tags= {
        Product= "Spark",
        business-unit= "PRICEOPTIMIZATION",
        compliance-framework= "HIPAA",
        application-owner= "CCS-DevOps@zelis.com"
        engineering-owner   = "dl-azure_support@zelis.com"
        environment-stage   = "production"
    }
#db_enabled = "true"
cert_enabled = "false"
shared_key_vault_name = "ZENINFKVP01"
shared_key_vault_resource_group_name = "ZENINFKV"
wildcard_cert_name = "ExternalAppSvcZelisWC"
custom_domain_verification_id = "zccsspkapiwadr01.azurewebsites.net"
zone_name = "zelis.com"
application_name = "zccsspkapiwadr01"
record_type = "CNAME"