#!/bin/bash

resourcegroup=vu-elk2
id=$(cat /tmp/id)

azure group deployment create --name=$id --resource-group=$resourcegroup --template-file="/tmp/azuredeploy.json" --parameters-file="/tmp/azuredeploy.parameters.json"
echo "scp azureuser@a${id}z.westeurope.cloudapp.azure.com:~/.kube/config ~/.kube/config" >~/kube-msg.txt

