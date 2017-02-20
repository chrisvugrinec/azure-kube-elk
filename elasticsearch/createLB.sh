subid=$(azure account show --json | jq -r '.[].id')
echo "RESOURCEGROUP"
read rg
cp loadbalancer.json $rg-loadbalancer.json
sed -in 's/XXX_SUB_XXX/'$subid'/g' $rg-loadbalancer.json
sed -in 's/XXX_RG_XXX/'$rg'/g' $rg-loadbalancer.json

azure group deployment create --template-file $rg-loadbalancer.json $rg

rm -f *.jsonn
