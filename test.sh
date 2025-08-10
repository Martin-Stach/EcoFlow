#!/bin/bash

# use EcoFlow API to switch a Ecoflow Smart Plug - https://developer-eu.ecoflow.com/us/document/introduction
# written by Sven Erbe - mail@sven-erbe.de - 30/01/2023 based of https://github.com/Mark-Hicks/ecoflow-api/blob/main/examples/Get-efAPI.ps1


# URL="https://api.ecoflow.com"
URL="https://api-e.ecoflow.com"
QuotaPathALL="/iot-open/sign/device/quota/all"
QuotaPath="/iot-open/sign/device/quota"

# Replace with valid access/secret keys and device SN

accesskey="6gQ1E2A13aNLSJEFiDMlgrEHbcpWa7So"
secretkey="9CirCBQO3J6ksHQI3LYOUAtSn5CIWD1G"
# sn="HWABZ0123456789"
sn="HW51ZEH4SF685360"

# cmdCode="WN511_SOCKET_SET_PLUG_SWITCH_MESSAGE"
cmdCode="WN511_SET_SUPPLY_PRIORITY_PACK"

# params="plugSwitch=1"
body="{\"sn\":\"${sn}\",\"cmdCode\":\"${cmdCode}\",\"params\":{\"supplyPriority\":0}}"

# generate nonce and timestamp

nonce=`echo $((RANDOM % (999999 - 100000 + 1) + 100000))`
timestamp=`echo $(date +"%s%3N")`

# str for generating of the signiture
str="cmdCode=${cmdCode}&params.${params}&sn=${sn}&accessKey=${accesskey}&nonce=${nonce}&timestamp=${timestamp}"

sign=`echo -n "${str}" | openssl dgst -sha256 -hmac "${secretkey}" -binary | od -An -v -tx1 | tr -d ' \n'`

echo "trying curl"

# curl -X PUT "${URL}${QuotaPath}?sn=${sn}" \
# -H 'Content-Type:application/json;charset=UTF-8' \
# -H "accessKey:6gQ1E2A13aNLSJEFiDMlgrEHbcpWa7So" \
# -H "timestamp:1754837926739" \
# -H "nonce:844636" \
# -H "sign:d7d925b65fb759b5a212e2c28f90941056aa7c9cc739113bcca535b7ce530d9f" \
# -d $body 

curl -X PUT "${URL}${QuotaPath}?sn=${sn}" \
-H 'Content-Type:application/json;charset=UTF-8' \
-H "accessKey:${accesskey}" \
-H "timestamp:${timestamp}" \
-H "nonce:${nonce}" \
-H "sign:${sign}" \
-d $body \
-v
``