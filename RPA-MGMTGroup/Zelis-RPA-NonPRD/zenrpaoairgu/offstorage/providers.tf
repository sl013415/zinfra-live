terraform {
  required_providers {
    azurerm = ">=3.15.1, <4.0.0"
    
  }
  backend  "azurerm" {
    subscription_id      = "fb4dc091-1772-420f-aeb9-5b3b0ceaf06a"
    resource_group_name  = "zenadotfrg"
    storage_account_name = "zenzrntfstrp01"
    container_name       = "tfstate"
    key                  = "RPA-MGMTGroup/Zelis-RPA-NonPRD/zenrpaoairgu/offstorage/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
provider "azurerm" {
  alias="certkvtsub"
  features {}
  subscription_id = "5129001f-5fc6-4a22-9e42-70ef99374bd4"
}
 provider "aws" {
   region = "us-east-2"
 }