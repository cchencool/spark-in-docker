#!/bin/bash

echo "removing spark..."

check_succ()
{
    if [[ $? -eq 0 ]]; then
        echo "done"
    else
        echo "failed"
    fi
}

node_master=${1:-"myvm1"}

eval $(docker-machine env ${node_master})
export EXTERNAL_IP=$(docker-machine ip ${node_master})
docker stack rm spark
check_succ