#!/bin/bash

##########################################
#
# Name:        deploy.sh
# Description: Deploys a docker image on the ACS
# Contact:     chrvugrin@microsoft.com, ver 1.0
#
##########################################

if [ "$#" -ne 4 ]
then
  echo "please provide the following parameters: "
  echo "- jsonappfile"
  echo "- resourcegroupname"
  echo "- serviceport"
  echo "- rulenr"
  exit 1
fi
jsonappfile=$1
resourcegroupname=$2
serviceport=$3
rulenr=$4

# deploy app
dcos marathon app add $jsonappfile

# config loadbalancer for app
lbName=$(azure group show $resourcegroupname | grep -i lb | grep agent | grep Name | sed 's/^.*[:][ ]//')
appName=`echo $jsonappfile | sed 's/.json//'`
azure network lb rule create -g $resourcegroupname -l $lbName -n $appName -p tcp -f $serviceport -b $serviceport

# config network security
nsgName=$(azure network nsg list -g $resourcegroupname | grep agent | grep public | awk '{print $2}')
azure network nsg rule create -g $resourcegroupname -a $nsgName -n $appName-rule -c Allow -p Tcp -r Inbound -y $rulenr -f Internet -u $serviceport 
