#!/bin/bash

numberofnodes=$1

# Gather stuff needed for keys in template
tmpkey=`echo $(cat ~/.ssh/id_rsa.pub)`
sshKey=$(echo "$tmpkey" | sed 's/\//\\\//g')


#clientid=$(cat /etc/puppetlabs/puppet/azure.conf | grep client_id | sed 's/[\"]//g' | sed 's/^.*[:] //')
#clientsecret=$(cat /etc/puppetlabs/puppet/azure.conf | grep client_secret | sed 's/[\"]//g' | sed 's/^.*[:] //')


id=$(base64 /dev/urandom | tr -d '/+' | dd bs=8 count=1 2>/dev/null)
echo $id >/opt/puppet/id

if [ -d ~/go/src/github.com/Azure/acs-engine/ ]
then 
  rm -rf ~/go/src/github.com/Azure/acs-engine/
fi

export GOPATH=/root/go
go get github.com/Azure/acs-engine
go get all
cd $GOPATH/src/github.com/Azure/acs-engine
go build

cp ~/go/src/github.com/Azure/acs-engine/examples/kubernetes.json /opt/puppet/acs-kube-template.json
cd /opt/puppet
sed -in "s/keyData\": \"\"/keyData\": \"$sshKey\"/g" acs-kube-template.json
sed -in "s/servicePrincipalClientID\": \"\"/servicePrincipalClientID\": \"$clientid\"/g" acs-kube-template.json
sed -in "s/servicePrincipalClientSecret\": \"\"/servicePrincipalClientSecret\": \"$clientsecret\"/g" acs-kube-template.json
sed -in "s/dnsPrefix\": \"\"/dnsPrefix\": \"a${id}z\"/g" acs-kube-template.json
sed -in "s/\"count\": 3,/\"count\": $numberofnodes,/" acs-kube-template.json

cd ~/go/src/github.com/Azure/acs-engine
./acs-engine /opt/puppet/acs-kube-template.json
cp _output/Kubernetes*/azuredeploy* /opt/puppet/
