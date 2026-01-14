
location         = "eastus2"
resource_group_name = "ZCCSRGP"
azuread_administrator_group_name = "Zelis DBA Group"
env = "prod"
azuread_authentication_only = false
tags = {
      
location = "us-east2"
environment = "prd"
app-name = "IMPACTANALYSIS"
cost-center = ""
organizational-owner = "CCS"
application-owner = "ImpactAnalysisTeam@zelis.com"
engineering-owner = "dl-azure_support@zelis.com"
deployment-date = "03/27/2023"
data-classification = ""
deployment-method = "IaC"
iac-repo-id = ""
latest-release-version = ""
backup-policy = ""
end-of-life = ""
operating-system = ""
project-id = ""
shutdown-schedule = "None"
    }
db_enabled = "true"

#ADF
name   = "zcmiaadfp01"
virtual_network_resource_group_name  = "zcmrgnetp01"
virtual_network_name = "zcmvnnetp01"
subnet_name = "ADF-Integration-IA"
