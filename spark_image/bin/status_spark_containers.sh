#!/bin/bash

# check runing stat
run_stat=`docker container ls | grep -i 'spark-' | awk -F 'spark-' '{print $2}'`
run_stat=${run_stat:-"none"}

if [[ ${run_stat[0]} != "none" ]];then
    for con in $run_stat; do
        echo "spark-$con runing..."
    done
else
    echo "no spark container running."
fi


# check docker network
net=`docker network ls | grep -i 'spark-net' | awk -F ' ' '{print $1}'`
if [[ $net = "" ]];then
    echo "spark-net not runing."
else
    echo "spark-net runing..."
fi
