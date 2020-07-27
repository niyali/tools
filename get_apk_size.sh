#!/bin/bash 

#
# Prerequisites: 
# - Bitrise app_slug for FxLite
# - build_number of 99% rollout Beta build 
# - personal BITRISE_TOKEN
#
# <Description> 
# To get the latest primary build size  
# usage: ./get_apk_size.sh
# expected result: apk_size: 6663482 ( 6.35479164123535156250 MB)
#

# get the build number of the latest primary build 
build_number=$(curl -X GET "https://api.bitrise.io/v0.1/apps/$app_slug/builds?workflow=primary" -H  "accept: application/json" -H  "Authorization: $BITRISE_TOKEN" | jq -r '.data[0].build_number')

# get the build slug 
build_slug=$(curl -X GET "https://api.bitrise.io/v0.1/apps/$app_slug/builds?sort_by=created_at&build_number=$build_number" -H  "accept: application/json" -H  "Authorization: $BITRISE_TOKEN" | jq -r '.data[].slug')

# download build log 
build_log_url=$(curl -X GET "https://api.bitrise.io/v0.1/apps/$app_slug/builds/$build_slug/log" -H  "accept: application/json" -H  "Authorization: $BITRISE_TOKEN" | jq '.expiring_raw_log_url' | sed 's/"//g') 

curl $build_log_url --output build.log 

# extract apk size 
apk_size=$(cat build.log | grep -A1 'python tools/metrics/apk_size.py focus webkit'  | grep -Eo [0-9]{7} | head -n 1)
apk_size_in_human=$( echo "$apk_size/1024/1024" | bc -l )
echo "apk_size: $apk_size ( $apk_size_in_human MB) "

# clean up 
rm build.log

