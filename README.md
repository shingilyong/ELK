# ELK
ELK 구축하는 과정을 Terraform으로 자동화 해보자!

# elasticsearch.yml 설정
$ vi /etc/elasticsearch/elasticsearch.yml

network.host : 0.0.0.0\n
http.port : 9200\n
discovery.seed.hosts:["127.0.0.1"]\n

# kibana.yml 설정
server.host: "0.0.0.0"