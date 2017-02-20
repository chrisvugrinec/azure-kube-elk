#!/bin/bash
yum install -y java-1.8.0-openjdk.x86_64
#wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.1.rpm
wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.4.0/elasticsearch-2.4.0.rpm
rpm -ivh elasticsearch-2.4.0.rpm
systemctl enable elasticsearch.service
