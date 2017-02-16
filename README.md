# Azure DCOS Elk

This contains the sources for the following youtube flic:

This is in my opinion a valid scenario of running an ELK stack on Azure.
This repo contains the following:
* A dcos/mesosphere cluster which hosts the Logstash and Kibana instances
* Scripts for creating and expanding your elastic search cluster. 
* A demo webapp which is configured to use this ELK solution (seeing is believing :)


The Elastic search machines will be rolled out with ARM templates in combination with custom made extensions The Extensions are resonsible for installing and configuring the Elastic Search Cluster.

