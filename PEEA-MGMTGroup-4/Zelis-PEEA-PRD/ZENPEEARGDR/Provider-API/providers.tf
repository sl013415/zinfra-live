terraform {
  required_providers {
    azurerm = ">=3.15.1, <4.0.0"
      azapi = {
      source = "Azure/azapi"
    }
    
  }
  backend  "azurerm" {
    subscription_id      = "5129001f-5fc6-4a22-9e42-70ef99374bd4"
    resource_group_name  = "zentfrg"
    storage_account_name = "zenstrtfstatep01"
    container_name       = "tfstate"
    key                  = "PEEA-MGMTGroup/Zelis-PEEA-NonPRD/ZENPEEARGDR/provider-API/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
provider "azurerm" {
  alias="certkvtsub"
  features {}
  subscription_id = "31a91300-2f34-49ae-a24b-0c536b73e0b9"
}
 provider "aws" {
   region = "us-east-2"
 }