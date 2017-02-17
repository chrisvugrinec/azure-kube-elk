#!/bin/bash
echo "docker reg url"
read durl
echo "docker reg username"
read dusername
echo "docker reg password"
read dpassword
kubectl create secret docker-registry dockerreg-secret --docker-server=$durl --docker-username=$dusername --docker-password=$dpassword --docker-email=chvugrin@microsoft.com
