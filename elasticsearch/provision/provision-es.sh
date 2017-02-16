#!/bin/bash
yum install -y java-1.8.0-openjdk.x86_64
wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.3.noarch.rpm
rpm -ivh elasticsearch-1.7.3.noarch.rpm
systemctl enable elasticsearch.service
