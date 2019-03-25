#!/bin/bash

cmd=${1:-"usage"}

dir=`dirname $0`
filename=$(basename $0)

if [[ $cmd = "usage" ]];then
    echo "usage: $filename {start|stop|status|usage}"
elif [[ $cmd = "start" ]];then
    # do start
    $dir/spark-containers-start.sh
elif [[ $cmd = "stop" ]];then
    # do stop
    $dir/spark-containers-stop.sh
elif [[ $cmd = "status" ]];then
    # do status
    $dir/spark-containers-status.sh
else
    $dir/$filename
fi