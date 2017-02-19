#!/bin/bash



# Gather stuff needed for keys in template
tmpkey=`echo $(cat ~/.ssh/id_rsa.pub)`
sshKey=$(echo "$tmpkey" | sed 's/\//\\\//g')


echo "make sure you entered the proper values in the script:"
echo "- clientid"
echo "- clientsecret"
echo "- numberofnodes"

clientid="34e0e4f3-d330-42ab-bf91-164030063f13"
clientsecret="01TmHlw9feylLTUgqSZK9VsRwVDNO9o5svSu94J7MSM="
numberofnodes=3

#id=$(base64 /dev/urandom | tr -d '/+' | tr 'A-Z' 'a-z' | dd bs=8 count=1 2>/dev/null)
id=$(uuid)
echo $id >/tmp/id

if [ -d ~/go/src/github.com/Azure/acs-engine/ ]
then 
  rm -rf ~/go/src/github.com/Azure/acs-engine/
fi

export GOPATH=~/go
go get github.com/Azure/acs-engine
go get all
cd $GOPATH/src/github.com/Azure/acs-engine
go build

cp ~/go/src/github.com/Azure/acs-engine/examples/kubernetes.json /tmp/acs-kube-template.json
cd /tmp/
sed -in "s/keyData\": \"\"/keyData\": \"$sshKey\"/g" acs-kube-template.json
sed -in "s/servicePrincipalClientID\": \"\"/servicePrincipalClientID\": \"$clientid\"/g" acs-kube-template.json
sed -in "s/servicePrincipalClientSecret\": \"\"/servicePrincipalClientSecret\": \"$clientsecret\"/g" acs-kube-template.json
sed -in "s/dnsPrefix\": \"\"/dnsPrefix\": \"a${id}z\"/g" acs-kube-template.json
sed -in "s/\"count\": 3,/\"count\": $numberofnodes,/" acs-kube-template.json

cd ~/go/src/github.com/Azure/acs-engine
./acs-engine /tmp/acs-kube-template.json
cp _output/Kubernetes*/azuredeploy* /tmp/
