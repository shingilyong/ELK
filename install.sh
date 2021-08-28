#!/bin/bash


# root 권한
sudo su

# Java 설치
sudo yum update -y 
sudo yum install -y java-1.8.0



# rpm import
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

# elasticsearch repo 작성
echo -e "[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
" > /etc/yum.repos.d/elasticsearch.repo

# ElasticSearch 설치
yum install -y --enablerepo=elasticsearch elasticsearch

# Elasticsearch 실행
systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch

# logstash repo 작성
echo -e "[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/logstash.repo

# logstash 설치
yum install logstash -y

# logstash 실행
systemctl start logstash
systemctl enable logstash

# kibana repo 작성
echo -e "[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/kibana.repo

# kibana 설치
yum install kibana -y

# kibana 실행
systemctl start kibana
systemctl enable kibana

