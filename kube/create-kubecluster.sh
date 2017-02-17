#!/bin/bash

echo "make sure you entered the proper resourcegroup name in the script"
resourcegroup=vu-elk
id=$(cat /tmp/id)

azure group deployment create --name=$id --resource-group=$resourcegroup --template-file="/tmp/azuredeploy.json" --parameters-file="/tmp/azuredeploy.parameters.json"

echo "NOW DO THIS:"
echo "scp azureuser@a${id}z.westeurope.cloudapp.azure.com:~/.kube/config ~/.kube/config" 

