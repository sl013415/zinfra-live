terraform {
  required_providers {
    azurerm = ">=3.15.1, <4.0.0"
    
  }
  backend  "azurerm" {
    subscription_id      = "a717d281-8389-448e-832b-3f5f1a7de11b"
    resource_group_name  = "zenadotfrg"
    storage_account_name = "zccsadotfstatestrd01"
    container_name       = "tfstate"
    key                  = "ADO-MGMTGroup/Zelis-ADO-Price/zcmadorgd01/terraform/terraform.tfstate"
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