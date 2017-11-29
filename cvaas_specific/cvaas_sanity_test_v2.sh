#!/bin/sh
#title           :cvaas_Sanity_test.sh
#description     :This program discover ElasticSearh and Redis IP then use them for test CVaaS
#author          :
#date            :
#version         :0.1
#usage           :./cvaas_sanity_test_v2.sh dev142
#notes           : dev142 referes to the latest CVaaS Load, this script can be combined with Ansible 
#python_version  :2.7.6  
#=======================================================================

###
# Script functions starts here
###

verify_docker()
{
    echo "Docker CVaaS Images [Sanity test]....\n"
        docker images  >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

    echo "Docker CVaaS Containers [Sanity test]....\n"
        docker ps  >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

}

load_cvaas_template()
{
    echo "Discover ElasticSearch IP [Sanity test]....\n"
        elasticsearch=$(docker inspect elasticsearch | grep 172.18.0 | grep IPAddress | awk -F'"' '{print $4}')
        #echo $elasticsearch
    echo "Load CVaaS vMME Template [Sanity test]....\n"
        python tools/onap-dump.py -H $elasticsearch -p ericsson -d tools/data/master/vMME_Config_V4_Rev.1.00_07-07-2017.json >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
    
    echo "Load CVaaS vMME Policy [Sanity test]....\n"
        python tools/onap-policy.py --host $elasticsearch -d tools/data/master/VNF-Policy_V1_Rev.1.00.json >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
}

run_cvaas_audit()
{
    echo "Discover Queue IP [Sanity test]....\n"
        redis=$(docker inspect cvaas001$1_redis_1 | grep 172.18.0 | grep IPAddress | awk -F'"' '{print $4}')
        #echo $redis
    echo "Run CVaaS vMME Audit [Sanity test]....\n"
        #python tools/onap-pipe.py -H $redis -d tools/data/config/vcvaas.config >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
        python tools/onap-pipe.py -H $redis -d tools/data/config/ConfigFile_from_export_20170530.txt >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
        sleep 5
}

stop_cvaas_worker()
{
    echo "Stop one CVaaS Worker instance out of two [Sanity test]....\n"
        docker stop cvaas001$1_cvaas-worker_2 >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
}

verify_elasticsearch()
{
    echo "Verify Report in ElasticSearch [Sanity test]....\n"
        curl 'http://0.0.0.0:9200/cvaas-report/_search/?size=1000&pretty=1' >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
}

dump_docker_logs()
{
    array_containers=$(docker-compose ps | tail -n +3 | awk '{print $1}')

    echo "Collect all Docker Container logs [Sanity test]....\n"
    echo "Collect all Docker Container logs [Sanity test]....\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
    #    docker-compose ps | tail -n +3 | awk '{print $1}' | xargs -n1 docker logs >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

    for i in ${array_containers}
      do
        echo "=========$i==================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
        docker logs $i >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log
        sleep 5
        echo "====================================\n" >> /home/ubuntu/cvaas-0.0.1.$1/cvaas-0.0.1.$1.log

      done

    }

###
# End of Functions
###

###
# Main body of script starts here
###
dev_rel=$1

    load_cvaas_template $dev_rel
    sleep 5
    
#    for i in {1..4}
#    do
#     echo "Running test $i times"
#     run_cvaas_audit $dev_rel
#        sleep 5
#    done
      run_cvaas_audit $dev_rel
        sleep 5

#    stop_cvaas_worker $dev_rel
#    sleep 5

    run_cvaas_audit $dev_rel
        sleep 5

    verify_elasticsearch $dev_rel
    sleep 5

    verify_docker $dev_rel
    sleep 5

    dump_docker_logs $dev_rel

###
# End of Script
###

