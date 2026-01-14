terraform {
  required_providers {
    azurerm = ">=3.15.1, <4.0.0"
    azapi = {
      source = "Azure/azapi"
    }

  }
  backend "azurerm" {
    subscription_id      = "8cd6f7a7-7407-423c-9896-98900c199a19"
    resource_group_name  = "zenadotfrg"
    storage_account_name = "zenzsctfstrp01"
    container_name       = "tfstate"
    key                  = "SecOps-MGMTGroup/Zelis-SecOps-NonPRD/ZENSOPSRGD/SecOps/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
provider "azurerm" {
  alias = "certkvtsub"
  features {}
  subscription_id = "5129001f-5fc6-4a22-9e42-70ef99374bd4"
}
provider "aws" {
  region = "us-east-2"
}