
 
data "azuread_group" "dba_admin" {
  display_name = var.azuread_administrator_group_name
}

module "mssql-server" {
   enabled = var.db_enabled
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-mssql" 

   name                = "zcmiasqlp01"
   resource_group_name = var.resource_group_name    
   location            = var.location
   env = var.env
  azuread_authentication_only = var.azuread_authentication_only

   # Create a managed identity for the Azure SQL Server
   identity_type            = var.identity_type
   azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      res-function = "PAAS-SQL"
    }
  )
 }

  module "adf" {
  source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm_data_factory"
   name   = var.name
   location   = var.location
  virtual_network_resource_group_name  = var.virtual_network_resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name = var.subnet_name
  resource_group_name = var.resource_group_name
  tags = merge(
    var.tags,
    {
     res-function = "ADF"
    }
  )
}