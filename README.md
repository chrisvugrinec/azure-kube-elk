# Azure DCOS Elk

This contains the sources for the following youtube flic:

This is in my opinion a valid scenario of running an ELK stack on Azure.
This repo contains the following:
* A kubernetes cluster which hosts the Logstash and Kibana instances and demo app
* Scripts for creating and expanding your elastic search cluster. 
* A demo webapp which is configured to use this ELK solution (seeing is believing :)

The Elastic search machines will be rolled out with ARM templates in combination with custom made extensions The Extensions are resonsible for installing and configuring the Elastic Search Cluster.

* git clone https://github.com/chrisvugrinec/azure-kube-elk.git
* creating elasticsearch cluster
  * cd elasticsearch
  * ./createVM.sh (make as many vm's as you like, make sure you use the same resourcegroup and different vm-names each time)
  * now edit the minimale elasticsearch config (elasticsearch.yml)  and copy this to each machine in /etc/elasticsearch
  * after editing the file, restart the service with the following command: systemctl restart eleasticsearch
  * now create an internal loadbalancer: ./createLB.sh
  * there is one step I couldnt script...linking the availability set to the loadbalancer..you have to do this via the portal --> LB --> elastic-lb --> backend pools --> elastic-lb-backendpool --> Add machines ..that's it (will need to have a look at it later) . Test the Load Balancer from the Kube Master ..do: curl http://11.11.0.100:9200/_cluster/health you can find node information with this URL http://11.11.0.100:9200/nodes
  * if all works (you see in the INTERNAL loadbalancer all your eleastic nodes) then you can disable all the public IP addresses per elastic node, this way only internal traffic is allowed
* creating kube cluster
  * cd kube
  * docker build -t test:1.0 .  (if you like to build the image yourself..if not..just skip to the folllowing command)
  * docker run -it test:1.0 bash
  * cd /opt/kube/
  * ./create-azureaccount.sh
  * login to azure
  * fill in app name
  * select azure account
  * go to portal --> azure active directory --> app registrations --> select your newly created app
  * create key: in the app, select keys and create a new one....copy the keyvalue    
  * ./loginToAzure.sh
  * edit the config-kubecluster.sh and fill in the clientid and clientsecret variables..you can find them in the portal (client id corresponds with application id). ALSO make sure that that you escape the / character in the password...meaning / becomes \/
  * edit the create-kubecluster.sh and fill in the resourcegroup
  * ./config-kubecluster.sh
  * ./create-kubecluster.sh
* vneet peering (making sure the different vnets can talk to eachother)
  * cd vnet
  * ./create-vnetpeer.sh
* get kubectl working on your machine (required!)
  * scp azureuser@[ YOUR KUBE MASTER ]:~/.kube/config ~/.kube/config
* deploy and configure logstash
  * cd logstash
  * check conf/logstash.conf
  * if you used the default stuff like in this demo..no config is needed..you can just use the existing image defined in the logstash-app.yaml
  * deploy logstash with the following command: kubectl create -f logstash-app.yaml
  * ./expose-svc
* deploy and configure kibana
  * cd kibana
  * check the kibana-app.yaml
  * if you used the default stuff like in this demo..no config is needed..you can just use the existing image defined in the kibana-app.yaml
  * deploy kibana with the following command: kubectl create -f kibana-app.yaml
  * ./expose-svc
* deploy and configure the springbootapp
  * cd java-springbootapp
  * check the log4j.properties file src/main/resources/log4j.properties 
  * build the app wiht the following command: gradle build
  * java -jar build/libs/gs-spring-boot-0.1.0.jar
  * goto http://localhost:8080  and see the app...in the log you will see some log messages appear
  * check your kubectl logs -f [logstash] and check the kibana to see your logging appear
