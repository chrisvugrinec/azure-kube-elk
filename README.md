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

