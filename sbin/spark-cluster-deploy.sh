#!/bin/bash

echo "deploying spark..."

check_succ()
{
    if [[ $? -eq 0 ]]; then
        echo "success"
    else
        echo "failed"
    fi
}

node_master=${1:-"myvm1"}

eval $(docker-machine env ${node_master})
export EXTERNAL_IP=$(docker-machine ip ${node_master})
docker stack deploy --compose-file=docker-compose.yml spark
# docker service scale spark_worker=2

echo "getting information..."

NODE=$(docker service ps --format "{{.Node}}" spark_master)
master_ip=`docker-machine ip $NODE`

printf "%15.15s : %10s\n" "spark-master" "${master_ip}:7077"
printf "%15.15s : %10s\n" "web UI" "${master_ip}:8080"
# echo "spark-master: ${master_ip}:7077"
# echo "web UI: ${master_ip}:8080"