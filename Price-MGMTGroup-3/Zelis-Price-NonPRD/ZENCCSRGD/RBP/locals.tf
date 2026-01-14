locals {  
 custom_dns_records = {
"zcmrbpptnaad01" = "zcmrbpptnaad01.azurewebsites.net"
"zcmrbppctprtwad01" = "zcmrbppctprtwad01.azurewebsites.net"
"zcmrbpbbaad01" = "zcmrbpbbaad01.azurewebsites.net"
"zcmrbpersaad01" = "zcmrbpersaad01.azurewebsites.net"
"zcmrbpfhaad01" = "zcmrbpfhaad01.azurewebsites.net"
"zcmrbpmdraad01" = "zcmrbpmdraad01.azurewebsites.net"
"zcmrbptrvaad01" = "zcmrbptrvaad01.azurewebsites.net"
"zcmrbpmlnaad01" = "zcmrbpmlnaad01.azurewebsites.net"
"zcmrbplkpwad01" = "zcmrbplkpwad01.azurewebsites.net"
 }
web_app_names = {
"zcmrbpptnaad01" = "zcmrbpptnaid01"
"zcmrbppctprtwad01" = "zcmrbppctprtaid01"
"zcmrbpbbaad01" = "zcmrbpbbaid01"
"zcmrbpersaad01" = "zcmrbpersaid01"
"zcmrbpfhaad01" = "zcmrbpfhaid01"
"zcmrbpmdraad01" = "zcmrbpmdraid01"
"zcmrbptrvaad01" = "zcmrbptrvaid01"
"zcmrbpmlnaad01" = "zcmrbpmlnaid01"
"zcmrbplkpwad01"= "zcmrbplkpaid01"
}
# app_insight_names =toset([
  
#  "zcmrbpptnaid01",
#  "zcmrbppctprtaid01",
#  "zcmrbpbbaid01",
# "zcmrbpersaid01",
# "zcmrbpfhaid01",
# "zcmrbpmdraid01",
#  "zcmrbptrvaid01",
# "zcmrbpmlnaid01",
# "zcmrbplkpaid01"
# ])
stg_acc_names = toset([
  "zcmrbpptnstrd01",
  "zcmrbplogstrd01"
 ])
 sql_servers = toset([
  "zcmrbpptnsqld01",
  "zcmrbpsqld01"
 ])
    custom_dns_rec = {
        zcmrbpbbaad01 = "rbp-benchmark-broker-dev.zelis.com"
        zcmrbppctprtwad01 = "rbp-precert-portal-dev.zelis.com"
        zcmrbplkpwad01 = "rbp-lookup-dev.zelis.com"
   }
}