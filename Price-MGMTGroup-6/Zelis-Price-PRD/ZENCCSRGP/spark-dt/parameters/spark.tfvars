# Naming and Tagging Vars
location         = "eastus2"
resource_group_name = "ZCCSRGP"
 subnet_id = "/subscriptions/208d9d5e-b1ba-42e2-9dcf-a3ac58050bc9/resourceGroups/zcmrgnetp01/providers/Microsoft.Network/virtualNetworks/zcmvnnetp01/subnets/PaaSApp-Integration-Net"
 lz_subnet_id ="/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetp01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetp01/subnets/Net-Trust" 
lz_DR_subnet_id = "/subscriptions/3a07ea8c-0ac8-43d6-a21e-ed467d8ef56b/resourceGroups/zenlzrgnetdr01/providers/Microsoft.Network/virtualNetworks/zenlzvnnetdr01/subnets/Net-Trust"
# # App Config Vars
account_replication_type = "GRS"
 appservice_plan_name                = "zenccsapsp01"
 appservice_plan_resource_group_name = "ZCCSRGP"
# appservice_type    = "web"
env ="prod"
workspace_id = "/subscriptions/208d9d5e-b1ba-42e2-9dcf-a3ac58050bc9/resourceGroups/zccsrgp/providers/Microsoft.OperationalInsights/workspaces/zenccslawsp01"

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
custom_domain_verification_id = "zccsspkdtwap01.azurewebsites.net"
zone_name = "zelis.com"
application_name = "zccsspkdtwap01"
record_type = "CNAME"