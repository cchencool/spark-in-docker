#!/bin/bash

echo "check spark status..."

check_succ()
{
    echo "done"
    if [[ $? -eq 0 ]]; then
        return 1
    else
        return 0
    fi
}

node_master=${1:-"myvm1"}

eval $(docker-machine env ${node_master})
export EXTERNAL_IP=$(docker-machine ip ${node_master})
docker stack ps spark
# docker stack ps -f "desired-state=ready" -f "desired-state=running" spark
check_succ