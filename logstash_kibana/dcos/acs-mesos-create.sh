#!/bin/bash

##########################################
#
# Name:        createAcsDcos.sh
# Description: a bash wrapper around the json template for creating
#    the azure container service. Roughly the acs contains 
#    the following components:
#    - a scaleset of x amount of machines/nodes for the master (x is parameterized value)
#    - a scaleset of x amount of machines/nodes for the agents  (x is parameterized value)
#    - an internal azure loadbalancer 
#    - an external azure loadbalancer 
#    - network security groups for securing differents vlans
#    - a public ip adress for accessing the master node(s)
#    - a public ip adress for accessing the agent node(s)
#    after running this initial script you will have a mesos with marathon environment (swarm not used here)
# Contact:     chrvugrin@microsoft.com, ver 1.0
#
##########################################

if [ "$#" -ne 5 ]
then
  echo "please provide the following parameters: "
  echo "- resourceGroup"
  echo "- region"
  echo "- sshuser"
  echo "- agentcount"
  echo "- groupName"
  exit 1
fi

resourceGroup=$1
region=$2
sshuser=$3
agentcount=$4
groupName=$5
rgExists=$(azure group list | grep -i $resourceGroup) 
nameExists=$(azure network public-ip list | grep -i dcos-master-ip-$groupName-mgmt)

cat acs-mesos-deploy.json | sed 's/XXX_USER_XXX/'$sshuser'/g' | sed 's/XXX_AGENTCOUNT_XXX/'$agentcount'/g' | sed 's/XXX_NAME_XXX/'$groupName'/g' >template.json

azure group create $resourceGroup -l $region

echo $nameExists
if  [ "$nameExists" == "" ]
then
  azure group deployment create -f template.json $resourceGroup
else
  echo "name $groupName already exists"
  exit 1
fi
