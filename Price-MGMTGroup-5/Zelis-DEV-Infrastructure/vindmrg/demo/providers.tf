terraform {
  required_providers {
    azurerm = ">=3.15.1, <4.0.0"
    
  }
  backend  "azurerm" {
    subscription_id      = "5129001f-5fc6-4a22-9e42-70ef99374bd4"
    resource_group_name  = "zentfrg"
    storage_account_name = "zenstrtfstatep01"
    container_name       = "tfstate"
    key                  = "CCS-MGMTGroup/Zelis-DEV-Infrastructure/vindmrg/demo/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
provider "azurerm" {
  alias="certkvtsub"
  features {}
  subscription_id = "f64ca80b-42ff-479f-96db-69b4e50f5703"
}
 provider "aws" {
   region = "us-east-2"
 }