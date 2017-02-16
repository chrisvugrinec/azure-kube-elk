#!/bin/bash

resourcegroup=$1
id=$(cat /opt/puppet/id)

azure group deployment create --name=$id --resource-group=$resourcegroup --template-file="azuredeploy.json" --parameters-file="azuredeploy.parameters.json"
echo "scp azureuser@a${id}z.westeurope.cloudapp.azure.com:~/.kube/config ~/.kube/config" >~/kube-msg.txt

