#!/bin/bash

# default 3 slaves
N=${N:-3}
version=${version:-0.2}

check_succ()
{
    if [[ $? -eq 0 ]]; then
        echo "success"
    else
        echo "failed"
    fi
}

# check runing stat
run_stat=`docker container ls | grep -i 'spark-' | awk -F 'spark-' '{print $2}'`
run_stat=${run_stat:-"none"}
if [[ ${run_stat[0]} != "none" ]];then
    for con in $run_stat; do
        echo -n "stop spark-$con container..."
        docker rm -f spark-$con &> /dev/null
        check_succ
    done
else
    echo "no container running."
fi

# check docker network
net=`docker network ls | grep -i 'spark-net' | awk -F ' ' '{print $1}'`
if [[ $net != "" ]];then
	echo -n "delete spark-net..."
    net_id=`docker network rm spark-net`
    check_succ
else
    echo "no network running"
fi
