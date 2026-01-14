  
  apim_name                 = "ZENPEAPIMQ01"
  apim_publisher_name       = "zelis"
  apim_publisher_email      = "admin@zelis.com"
  apim_sku_name             = "Developer_1"
  apim_virtual_network_type = "Internal"
location = "eastus2"
resource_group_name = "ZENPEEARGQ"
pip_resource_group_name ="zenpergnetd01"
  # if requires_custom_host_name_configuration is true 
  #then below custom host parameter require otherwise you can leave it blank
  requires_custom_host_name_configuration = true
  developer_portal_host_name              = ["qa-developer.zelis.com"]
  gateway_host_name                       = ["qa-api.zelis.com"]
  pip_name = "zenpeapimq01-mgmt-pia"
  wildcard_certificate_key_vault_name     = "ZENINFKVP01"
  wildcard_certificate_name               = "apim-zelis-com-wildcard"
  wildcard_certificate_key_vault_resource_group_name = "ZENINFKV"
 apim_subnet_id ="/subscriptions/5bf88ae2-570b-483c-95d4-018309ae1682/resourceGroups/zenpergnetd01/providers/Microsoft.Network/virtualNetworks/zenpevnnetd01/subnets/APIM-Integration-Net-QA"
 client_id           = "998346d2-38b4-4f7f-9ffb-da26b058146f"
 client_secret       = "ZENPEAPIMQ01"
 allowed_tenants     = ["2829b063-3f75-4df6-b16d-605d30d1b7a2"]
 

    tags = {  
location = "us-east2"
environment = "QA"
app-name = ""
#cost-center = ""
organizational-owner = "PEEA"
application-owner = "peeateam@zelis.com"
engineering-owner = "dl-azure_support@zelis.com" 
deployment-date = "03/27/2023"
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
 zones = []