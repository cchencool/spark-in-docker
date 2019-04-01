#!/bin/bash

echo "deploying spark..."

dir=`dirname $0`
filename=$(basename $0)

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

prj_dir=$dir/..
compose_dir=$prj_dir/docker
docker stack deploy --compose-file=$compose_dir/docker-compose.yml spark
# docker service scale spark_worker=2
if [[ $? -eq 0 ]]; then
    echo "getting information..."

    NODE=$(docker service ps --format "{{.Node}}" spark_master)
    master_ip=`docker-machine ip $NODE`

    printf "%15.15s : %10s\n" "spark-master" "${master_ip}:7077"
    printf "%15.15s : %10s\n" "web UI" "${master_ip}:8080"
    printf "%25.15s : %10s\n" "data-dir-host" "$prj_dir/nfsshare"
    printf "%25.15s : %10s\n" "data-dir-master" "/root/nfsshare"
    echo "to start jupyter notebook, run 'docker container exec -it spark_master.1* bash'; then run 'sh /root/install/setup.sh'"
    printf "%15.15s : %10s\n" "jupyter-notebook" "${master_ip}:8888"
    # echo "spark-master: ${master_ip}:7077"
    # echo "web UI: ${master_ip}:8080"
fi