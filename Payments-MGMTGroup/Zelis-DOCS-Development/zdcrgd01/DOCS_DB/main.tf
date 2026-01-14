data "azuread_group" "dba_admin" {
   display_name = var.azuread_administrator_group_name
 }
 module "mssql-server" {
   env = var.env
   enabled = var.db_enabled
   source = "git::https://dev.azure.com/Zelis-CloudPractice/Azure-CloudAutomation/_git/zelis_TF_PAAS_Modules//Modules//azurerm-mssql"
   name                = var.sql_server_name
   databases = var.database
   resource_group_name = var.resource_group_name
   location            = var.location
   azuread_administrator_id = data.azuread_group.dba_admin.object_id
   administrator_login_name = var.azuread_administrator_group_name
    tags = merge(
    var.tags,
    {
      resource-function = "PAAS-SQL"
    }
  )
 }