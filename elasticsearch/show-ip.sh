#!/bin/bash
echo "resourcegroup"
read rg
for nic in $(azure network nic list $rg --json | jq -r '.[].name')
do
  echo $nic
  azure network nic show $rg $nic --json | jq -r '.ipConfigurations[].privateIPAddress'
done
