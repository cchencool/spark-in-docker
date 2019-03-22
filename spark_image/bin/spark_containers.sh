#!/bin/bash

cmd=${1:-"usage"}

# default 3 slaves
N=${N:-3}
version=${version:-0.2}

dir=`dirname $0`
filename=$(basename $0)

if [[ $cmd = "usage" ]];then
    echo "usage: $filename {start|stop|status|usage}"
elif [[ $cmd = "start" ]];then
    # do start
    $dir/start_spark_containers.sh
elif [[ $cmd = "stop" ]];then
    # do stop
    $dir/stop_spark_containers.sh
elif [[ $cmd = "status" ]];then
    # do status
    $dir/status_spark_containers.sh
fi