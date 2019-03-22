#!/bin/bash

# default 3 slaves
N=${N:-3}
version=${version:-1.0}

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
    echo "spark containers already running."
    for con in $run_stat; do
        echo "spark-$con already runing..."
    done
    exit 1
else
    echo "starting container cluster..."
fi

# check docker network
net=`docker network ls | grep -i 'spark-net' | awk -F ' ' '{print $1}'`
if [[ $net = "" ]];then
    echo -n "create spark-net..."
    net_id=`docker network create --driver=bridge spark-net`
    check_succ
else
    echo "spark-net already created."
fi

# start master
docker rm -f spark-master &> /dev/null
echo -n "start spark-master container..."
docker run -itd \
           --net=spark-net \
           -p 7077:7077 \
           --name spark-master \
           --hostname spark-master \
           cchencool/spark:${version} &> /dev/null
check_succ
# if [[ $? -eq 0 ]]; then
#     echo "success"
# else
#     echo "failed"
# fi

# start slaves
i=1
while [ $i -lt $N ]
do
    docker rm -f spark-slave$i &> /dev/null
    echo -n "start spark-slave$i container..."
    docker run -itd \
               --net=spark-net \
               --name spark-slave$i\
               --hostname spark-slave$i\
               cchencool/spark:${version} &> /dev/null
    check_succ
    # if [[ $? -eq 0 ]]; then
    #     echo "success"
    # else
    #     echo "failed"
    # fi
    ((i=i+1))
done

# start spark
echo -n "start spark service..."
docker exec spark-master /opt/spark/sbin/start-all.sh &> /dev/null
check_succ
echo "done."