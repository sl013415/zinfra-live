location         = "eastus2"
resource_group_name = "ZENZADARGD"
sql_server_name = "zenadfsqld01"
env = "nonprod"
# # Data Vars
azuread_administrator_group_name = "Zelis DBA Group"
# Naming and Tagging Vars
 tags= {
        Product= "ZADA",
        business-unit= "ZDI",
        compliance-framework= "PCI",
        application-owner= "ZeDWSupport@zelis.com"
        engineering-owner   = "dl-azure_support@zelis.com"
        environment-stage   = "development"
    }