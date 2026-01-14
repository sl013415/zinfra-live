terraform {
  required_providers {
    azurerm = ">=3.15.1, <4.0.0"
    
  }
  backend  "azurerm" {
    subscription_id      = "5129001f-5fc6-4a22-9e42-70ef99374bd4"
    resource_group_name  = "zentfrg"
    storage_account_name = "zenstrtfstatep01"
    container_name       = "tfstate"
    key                  = "PEEA-MGMTGroup/Zelis-PEEA-NonPRD/ZENPEEARGD/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  # subscription_id = "00000000-0000-0000-0000-000000000000"
  # client_id       = "00000000-0000-0000-0000-000000000000"
  # client_secret   = var.client_secret
  # tenant_id       = "00000000-0000-0000-0000-000000000000"
}
