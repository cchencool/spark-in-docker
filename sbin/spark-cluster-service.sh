#!/bin/bash

cmd=${1:-"usage"}

dir=`dirname $0`
filename=$(basename $0)

if [[ $cmd = "usage" ]];then
    echo "usage: $filename {deploy|remove|status|usage}"
elif [[ $cmd = "deploy" ]];then
    # do start
    $dir/spark-cluster-deploy.sh
elif [[ $cmd = "remove" ]];then
    # do stop
    $dir/spark-cluster-remove.sh
elif [[ $cmd = "status" ]];then
    # do status
    $dir/spark-cluster-status.sh
else
    $dir/$filename
fi