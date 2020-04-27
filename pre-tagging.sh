#!/bin/bash 

#
# Prerequisites: 
# - Bitrise app_slug for FxLite
# - build_number of 99% rollout Beta build 
# - personal BITRISE_TOKEN
#
# <Description> 
# To get GIT_CLONE_COMMIT_HASH and Branch 
# usage: ./pre-tagging.sh build_number
# 

build_number=$1

build_slug=$(curl -X GET "https://api.bitrise.io/v0.1/apps/$app_slug/builds?sort_by=created_at&build_number=$1" -H  "accept: application/json" -H  "Authorization: $BITRISE_TOKEN" | jq -r '.data[].slug')

curl -X GET "https://api.bitrise.io/v0.1/apps/$app_slug/builds/$build_slug/log" -H  "accept: application/json" -H  "Authorization: $BITRISE_TOKEN" | jq '.expiring_raw_log_url' | xargs wget -O build.log 

commit_hash=$(cat build.log | grep -A1 HASH | grep value | awk '{print $2}')
branch=$(cat build.log | grep -w "Branch:"  | awk '{print $3}')

echo "Commit_Hash: "$commit_hash
echo "Branch: "$branch

# clean up 
rm build.log

