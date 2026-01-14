terraform {
  required_providers {
    azurerm = ">=3.15.1, <4.0.0"
    
  }
  backend  "azurerm" {
    subscription_id      = "32f1779e-aa94-45e0-b724-ee3a7affd045"
    resource_group_name  = "zenadotfrg"
    storage_account_name = "zenstrtfstated01"
    container_name       = "tfstate"
    key                  = "ADO-MGMTGroup/Zelis-ADO-Price/terraform/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
# provider "azurerm" {
#   alias="certkvtsub"
#   features {}
#   subscription_id = "f64ca80b-42ff-479f-96db-69b4e50f5703"
# }
#  provider "aws" {
#    region = "us-east-2"
#  }