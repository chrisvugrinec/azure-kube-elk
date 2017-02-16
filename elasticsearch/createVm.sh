echo "resourcegroup: "
read rg
azure group create $rg westeurope
echo "elastic name:"
read elname
if [ ! -f pass.txt ]
then
  echo "passwd"
  read pass
else
  pass=$(cat pass.txt)
fi
id=$(base64 /dev/urandom | tr -d '/+' | dd bs=6 count=1 2>/dev/null)
sa_name=$(echo "$rg-$elname-$id" | sed 's/-//g' | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')
cp vm.parameters.json $rg-$elname.json
sed -in 's/virtualMachines_elastic_uri_value/\"'$sa_name'\"/g' $rg-$elname.json
sed -in 's/virtualMachines_elastic_adminPassword_value/\"'$pass'\"/g' $rg-$elname.json
sed -in 's/virtualMachines_elastic_name_value/\"'$rg-$elname'\"/g' $rg-$elname.json
sed -in 's/networkInterfaces_elastic_name_value/\"'$rg-$elname-nic'\"/g' $rg-$elname.json
sed -in 's/networkSecurityGroups_elastic_nsg_name_value/\"'$rg-$elname-nsg'\"/g' $rg-$elname.json
sed -in 's/publicIPAddresses_elastic_ip_name_value/\"'$rg-$elname-$id'\"/g' $rg-$elname.json
sed -in 's/virtualNetworks_name_value/\"'$rg-vnet'\"/g' $rg-$elname.json

azure group deployment create --template-file vm.json --parameters-file $rg-$elname.json $rg
