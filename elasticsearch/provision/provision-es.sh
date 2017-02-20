#!/bin/bash
yum install -y java-1.8.0-openjdk.x86_64
#wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.3.noarch.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.1.rpm
rpm -ivh elasticsearch-5.2.1.rpm
systemctl enable elasticsearch.service
