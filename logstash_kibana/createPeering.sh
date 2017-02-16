#!/bin/bash
echo "resourcegroup"
read rg
echo "listing networks in resourcegroup: "$rg
azure network vnet list $rg --json | jq -r '.[].name'
echo ""
echo "==========================="
echo ""
echo "VNET name FROM"
read vnetFROM
echo ""
echo "VNET name TO"
read vnetTO

echo ""
cp peer-template.json  peer$vnetFROM-2-$vnetTO.json
cp peer-template.json  peer$vnetTO-2-$vnetFROM.json

sed -in 's/SOURCEVNET/'$vnetFROM'/g' peer$vnetFROM-2-$vnetTO.json
sed -in 's/DESTINATIONVNET/'$vnetTO'/g' peer$vnetFROM-2-$vnetTO.json

sed -in 's/SOURCEVNET/'$vnetTO'/g' peer$vnetTO-2-$vnetFROM.json 
sed -in 's/DESTINATIONVNET/'$vnetFROM'/g' peer$vnetTO-2-$vnetFROM.json

echo "creating peerings between vnets $vnetFROM and $vnetTO....."
echo ""
azure group deployment create -f peer$vnetTO-2-$vnetFROM.json $rg
azure group deployment create -f peer$vnetFROM-2-$vnetTO.json $rg

rm -f *.jsonn
