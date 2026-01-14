variable "apim_name" {
  type          = string  
  description   = "api management name"  
}    


variable "resource_group_name" {
  type          = string  
  description   = "api management resource_group_name"
}    
variable "pip_resource_group_name" {
  type          = string  
  description   = "api management Pip resource_group_name"
}  
variable "location" {
  type          = string  
  description   = "api management location"  
  #default       = "westeurope"
}    

variable "client_id" {
  type = string
  description = "Client ID for AAD Identity Management"

}
variable "client_secret" {
  type = string
  description = "Client secret in KV for AAD Identity Management"
 
}
variable "allowed_tenants" {
  type = list(string)
  description = "Allowed Tenants for AAD Identity Management"
 default = ["Zelis Healthcare"]
}
variable "apim_sku_name" {
  type          = string  
  description   = "api management sku"  
  default       = "Developer_1"
}    

variable "apim_publisher_name" {
  type          = string  
  description   = "api management publisher neam"  
}    

variable "apim_publisher_email" {
  type          = string  
  description   = "api management publisher email"  
}    

variable "pip_name" {
  type          = string  
  description   = "api management publisher email"  
}    




variable "developer_portal_host_name" {
  type          = list  
  description   = "api management developer portal host name"  
 
} 


variable "gateway_host_name" {
  type          = list
  description   = "api management, gateway host name"  
  #default       = "dev-api.nonprod.contoso.com"
} 

################# Custom domain name configuration ############################
variable "requires_custom_host_name_configuration" {
  type          = bool  
  description   = "true if requires custom host name configuration, otherwise false (default is false)"   
  #default       =  true
} 

variable "wildcard_certificate_key_vault_name" {
  type          = string  
  description   = "keyvault name which holds a certificate to configure apim custom domain"   
} 


variable "wildcard_certificate_key_vault_resource_group_name" {
  type          = string  
  description   = "resource_group name of keyvault which holds a certificate to configure apim custom domain"   
} 

variable "wildcard_certificate_name" {
  type          = string  
  description   = "keyvault certificate name which will be used to configure apim custom domain"  
} 

##############*********************************************************************************************

variable "apim_virtual_network_type" {
  type          = string  
  description   = "api management virtual network type"  
  default       = "Internal"
} 




variable "apim_subnet_id" {
  type          = string  
  description   = "api management virtual network subnet id, (requires if APIM network type is Internal) " 
}



variable "tags" {
  description   = "api management resource tags"  

}
 variable "additional_location"{
 description = " Additional Location with Zone and subnet info"
 }
variable "zones" {
  type          = list 
  description   = "Zones"
} 