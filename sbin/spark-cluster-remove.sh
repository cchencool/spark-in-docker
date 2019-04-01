#!/bin/bash

echo "removing spark..."

check_succ()
{
    if [[ $? -eq 0 ]]; then
        echo "done"
        return 0
    else
        echo "failed"
        return 1
    fi
}

node_master=${1:-"myvm1"}

eval $(docker-machine env ${node_master})
export EXTERNAL_IP=$(docker-machine ip ${node_master})
docker stack rm spark

check_counter=0
docker stack ps spark &> /dev/null
while ([[ $? -eq 0 ]] && [[ $check_counter -lt 10 ]]); do
    sleep 1s
    docker stack ps spark &> /dev/null
    ((check_counter=check_counter+1))
done
docker stack ps spark &> /dev/null
if [[ $? -eq 0 ]];then
    echo "success"
else
    echo "failed"
fi