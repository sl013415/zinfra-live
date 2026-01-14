  env = "prod"
  apim_name                 = "ZENPEAPIMP01"
  apim_publisher_name       = "zelis"
  apim_publisher_email      = "admin@zelis.com"
  apim_sku_name             = "Premium_3"
  apim_virtual_network_type = "Internal"
location = "eastus2"
resource_group_name = "ZENPEEARGP"
pip_resource_group_name ="zenpergnetp01"
  # if requires_custom_host_name_configuration is true 
  #then below custom host parameter require otherwise you can leave it blank
  requires_custom_host_name_configuration = true
  developer_portal_host_name              = ["developer.zelis.com"]
  management_host_name = ["apimgmt.zelis.com"]
  gateway_host_name                         = ["api.zelis.com","sandbox-api.zelis.com"]
  pip_name = "zenpeapimp01-mgmt-pia"
  wildcard_certificate_key_vault_name     = "ZENINFKVP01"
  wildcard_certificate_name               = "apim-zelis-com-wildcard"
  wildcard_certificate_key_vault_resource_group_name = "ZENINFKV"
 apim_subnet_id ="/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp01/providers/Microsoft.Network/virtualNetworks/zenpevnnetp01/subnets/APIM-Integration-Net"
 client_id           = "b8cc7452-f760-485c-90e3-e90346a03c6d"
 client_secret       = "ZENPEAPIMP01"
 allowed_tenants     = ["2829b063-3f75-4df6-b16d-605d30d1b7a2"]
 zones = [1,2,3]

    tags = {  
location = "us-east2"
environment = "PRD"
app-name = "APIM"
#cost-center = ""
organizational-owner = "PEEA"
application-owner = "peeateam@zelis.com"
engineering-owner = "dl-azure_support@zelis.com" 
deployment-date = "04/05/2023"
compliance-framework = "HIPAA"
deployment-method = "IaC"
#iac-repo-id = ""
latest-release-version = ""
backup-policy = ""
end-of-life = ""
business-unit = "I&E"
#project-id = ""
shutdown-schedule = "None"
    }


additional_location = {
# eastus2 = {
# capacity = 3
# zones = [1,2,3]
# public_ip_address_id = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp01/providers/Microsoft.Network/publicIPAddresses/zenpeapimp01-mgmt-pia"
# subnet_id = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp01/providers/Microsoft.Network/virtualNetworks/zenpevnnetp01/subnets/APIM-Integration-Net"

# },

centralus = {
capacity = 1
zones = [1]
public_ip_address_id = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp02/providers/Microsoft.Network/publicIPAddresses/zenpeapimp02-mgmt-pia"
subnet_id = "/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp02/providers/Microsoft.Network/virtualNetworks/zenpevnnetp02/subnets/APIM-Integration-Net"
}
}