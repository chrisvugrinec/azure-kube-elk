#!/bin/sh
#=========================================
#
#       file:   createAzureLogin.sh
#       author: chvugrin@microsoft.com
#       description:
#                You will create a certificate, for automatic login...
#                This is intended to show how automation is possible with certificate
#
#=========================================
if [[ -f x1 ]]
then
  rm x1 x3 privkey.pem  cert*
fi
# make sure you do this 1st
azure login
echo "your app name"
read app
openssl req -x509 -days 3650 -newkey rsa:2048 -out cert.pem -nodes -subj "/CN=$app"
sed '1d' cert.pem >cert.pem.modified

#sed -i '$d' cert.pem.modified
cat cert.pem.modified | sed '$ d' >cert.pem.modified2
mv cert.pem.modified2 cert.pem.modified
cat privkey.pem cert.pem > certificate.pem
cert=$(cat cert.pem.modified)
azure ad sp create -n $app --cert-value "$cert" >x1


tenantId=$(azure account show | grep Tenant | sed 's/^.*[: ]//g')
# this assumes the 1st subscription, you can hardcode this as well...find out which subscription by doing: azure account list
subscription=$(azure account show | grep ID | grep -v Tenant | sed 's/^.*[: ]//')



echo "tenantID: $tenantId"
echo "subscription: $subscription"
echo ""
# Appearantly we need some more time link
echo "waiting 10 seconds"
sleep 10
objectId=$(cat x1 | grep Object | sed 's/^.*[:]//' | sed 's/^.*[ ]//')
azure role assignment create --objectId $objectId -o Contributor -c /subscriptions/$subscription/
azure ad sp show -c $app >x3
newObjectId=$(cat x3 | grep "Service Principal Names" -A 2 | tail -1 | sed 's/^.*[ ]//' )

#cleanup
rm -f x1  x3  privkey.pem cert.pem cert.pem.modified
thumbprint=$(openssl x509 -in certificate.pem -fingerprint -noout | sed 's/SHA1 Fingerprint=//g'  | sed 's/://g')
echo "Now you can use the following command to automatically login via a script: loginToAzure.sh  (works only in combination with generated certificate.pem"
echo "azure login --service-principal --tenant $tenantId -u $newObjectId --certificate-file certificate.pem --thumbprint $thumbprint" >loginToAzure.sh
chmod 700 loginToAzure.sh
