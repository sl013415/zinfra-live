data "azuread_group" "dba_admin" {
   display_name = var.azuread_administrator_group_name
 }
module "mssql-server" {
   enabled = var.db_enabled
   source = "git::https://github.com/ZelisEnt/zelis_TF_PAAS_Modules.git//Modules//azurerm-mssql?ref=feature/integrate_network_restriction_n_health_check"
   name                = var.sql_server_name
   env = var.env
   resource_group_name = var.resource_group_name
   location            = var.location
   azuread_administrator_id = data.azuread_group.dba_admin.object_id

    tags = merge(
    var.tags,
    {
      res-function = "PAAS-SQL"
    }
  )
 }