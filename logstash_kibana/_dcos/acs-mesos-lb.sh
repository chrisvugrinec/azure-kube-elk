#!/bin/bash

##########################################
#
# Name:        acs-mesos-lb.sh 
# Description: 
#   - Does stuff for you on azure so you can see the haproxy
#     which comes with your marathon-lb install
# Contact:     chrvugrin@microsoft.com, ver 1.0
#
##########################################

if [ "$#" -ne 1 ]
then
  echo "please provide the following parameters: "
  echo "- resourcegroup"
  exit 1
fi
resourcegroup=$1

# only install if not already installed
lbInstall=`dcos package list | grep -i marathon-lb`
if [ "$lbInstall" == "" ]
then
  dcos package install marathon-lb
fi

lbName=$(azure group show $resourcegroup | grep -i lb | grep agent | grep Name | sed 's/^.*[:][ ]//')
azure network lb rule create -g $resourcegroup --lb-name  $lbName -n haproxy -p tcp -f 9090 -b 9090

nsgName=$(azure network nsg list -g $resourcegroup| grep agent | grep public | awk '{print $2}')
azure network nsg rule create -g $resourcegroup -a $nsgName -n haproxy-rule -c Allow -p Tcp -r Inbound -y 410 -f Internet -u 9090


