
For running CVaaS GUI @Moffzilla Docker Registry

     docker run --net=cvaas001dev148_default -d -p 5000:5000 --privileged=true -e ELASTICHOST={{ElasticSearch IP}}:9200  --name cvaas-gui moffzilla/cvaas-gui:dev340 /bin/bash -c "./web/run.sh 172.18.0.6"

Example:

    docker run --net=cvaas001dev148_default -d -p 5000:5000 --privileged=true -e ELASTICHOST=172.18.0.3:9200  --name cvaas-gui moffzilla/cvaas-gui:dev340 /bin/bash -c "./web/run.sh 172.18.0.6"

For Running a Config Audit Job in the CVaaS Engine:

    python tools/onap-pipe.py -H {{Redis_IP}} -d {{Path to the VNF Configuration Raw or Native Configuration file}}
    
Example:

    python tools/onap-pipe.py -H 172.18.0.2 -d tools/data/config/vcvaas.config
    
For Initializing the vMME GoldStandard Template at  CVaaS Engine:
**Note, If running the Ansible Playbook this is done automatically
    
    python tools/onap-dump.py -H {{ElasticSearch IP}} -p {{VNF-Vendor}} -d  {{Path to the JSON GoldStandard File for the VNF}}
    
Example:

    python tools/onap-dump.py -H 172.18.0.3 -p ericsson -d  tools/data/master/vMME_Config_V4_Rev.1.00_05-12-2017.json
    
    
