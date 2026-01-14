  env = "prod"
  apim_name                 = "zenpeasbxapimp01"
  apim_publisher_name       = "zelis"
  apim_publisher_email      = "admin@zelis.com"
  apim_sku_name             = "Developer_1"
  apim_virtual_network_type = "Internal"
location = "eastus2"
resource_group_name = "ZENPEEARGP"
pip_resource_group_name ="zenpergnetp01"
  # if requires_custom_host_name_configuration is true 
  #then below custom host parameter require otherwise you can leave it blank
  requires_custom_host_name_configuration = true
  developer_portal_host_name              = ["sandbox-developer.zelis.com"]
  management_host_name = [ "sandbox-apimgmt.zelis.com"]
  gateway_host_name                         = ["sandbox-api.zelis.com"]
  pip_name = "zenpeasbxapimp01-mgmt-pia"
  wildcard_certificate_key_vault_name     = "ZENINFKVP01"
  wildcard_certificate_name               = "apim-zelis-com-wildcard"
  wildcard_certificate_key_vault_resource_group_name = "ZENINFKV"
 apim_subnet_id ="/subscriptions/d4b3a18f-3efa-468e-8f52-0defd34c17bd/resourceGroups/zenpergnetp01/providers/Microsoft.Network/virtualNetworks/zenpevnnetp01/subnets/APIM-Integration-Net"
 client_id           = "c2257d61-0c74-450f-a730-790e55252db4"
 client_secret       = "zenpeasbxapimp01"
 allowed_tenants     = ["2829b063-3f75-4df6-b16d-605d30d1b7a2"]
 zones = [ ]

    tags = {  
location = "us-east2"
environment = "PRD"
app-name = ""
#cost-center = ""
organizational-owner = "PEEA"
application-owner = "peeateam@zelis.com"
engineering-owner = "dl-azure_support@zelis.com" 
deployment-date = "09/22/2023"
#data-classification = "internal"
deployment-method = "IaC"
iac-repo-id = ""
latest-release-version = ""
backup-policy = ""
end-of-life = ""
#operating-system = ""
project-id = ""
shutdown-schedule = "None"
    }


additional_location = {}