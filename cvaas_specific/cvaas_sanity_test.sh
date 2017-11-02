#!/bin/sh
#title           :cvaas_Sanity_test.sh
#description     :This program discover ElasticSearh and Redis IP then use them for test CVaaS
#author          :
#date            :
#version         :0.1
#usage           :./cvaas_sanity_test.sh dev142
#notes           : dev142 referes to the latest CVaaS Load, this script can be combined with Ansible 
#python_version  :2.7.6  
#=======================================================================

###
# Main body of script starts here
###

echo "Discover ElasticSearch IP [Sanity test]....\n"
   elasticsearch=$(docker inspect elasticsearch | grep 172.18.0 | grep IPAddress | awk -F'"' '{print $4}')

echo "Discover Queue IP [Sanity test]....\n"
   redis=$(docker inspect cvaas001$1_redis_1 | grep 172.18.0 | grep IPAddress | awk -F'"' '{print $4}')

echo "Load CVaaS vMME Template [Sanity test]....\n"
echo "Load CVaaS vMME Template [Sanity test]....\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
#echo $elasticsearch
#echo $redis
python tools/onap-dump.py -H $elasticsearch -p ericsson -d tools/data/master/vMME_Config_V4_Rev.1.00_07-07-2017.json >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

sleep 5

echo "Run CVaaS vMME Audit [Sanity test]....\n"
echo "Run CVaaS vMME Audit [Sanity test]....\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

python tools/onap-pipe.py -H $redis -d tools/data/config/vcvaas.config >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log 
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

sleep 5

echo "Stop one CVaaS Worker instance out of two [Sanity test]....\n"
echo "Stop one CVaaS Worker instance out of two [Sanity test]....\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

docker stop cvaas001$1_cvaas-worker_1 >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log  
sleep 5

echo "Re-Run CVaaS vMME Audit [Sanity test]....\n"
echo "Re-Run CVaaS vMME Audit [Sanity test]....\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

python tools/onap-pipe.py -H $redis -d tools/data/config/vcvaas.config >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
sleep 5

echo "Collect all Docker Container logs [Sanity test]....\n"
echo "Collect all Docker Container logs [Sanity test]....\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

echo "Docker CVaaS Images [Sanity test]....\n"
echo "Docker CVaaS Images [Sanity test]....\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
docker images  >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

echo "Docker CVaaS Containers [Sanity test]....\n"
echo "Docker CVaaS Containers [Sanity test]....\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
docker ps  >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

echo "=========ElasticSearch==================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
docker logs elasticsearch >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

echo "=========Redis==================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
docker logs cvaas001$1_redis_1 >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

echo "=========cvaas-queue==================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
docker logs cvaas001$1_cvaas-queue_1 >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

echo "=========cvaas-worker_1==================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
docker logs cvaas001$1_cvaas-worker_1 >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

echo "=========cvaas-worker_2==================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
docker logs cvaas001$1_cvaas-worker_2 >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

#docker-compose logs --tail=20000 >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.docker.log
#echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.docker.log

echo "Verify ES data [Sanity test]....\n"
echo "Verify ES data [Sanity test]....\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

curl 'http://0.0.0.0:9200/cvaas-report/_search/?size=1000&pretty=1' >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

###
# End of Script
###