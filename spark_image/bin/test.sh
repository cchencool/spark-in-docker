#!/bin/bash

first=${1:-0.01}
second=${2:-0.02}

echo "first: $first"
echo "second: $second"

i=0
while [ $i -lt 3 ];do
	echo $i
	i=$((i+1))
done;


p=`docker network ls | grep -i 'docker' | awk -F ' ' '{print $1}'`
if [ $p != "" ];then
	echo $p
fi


# default 3 slaves
N=${N:-3}
version=${version:-0.2}

check_success(){
	if [[ $? -eq 0 ]]; then
	    echo "success"
	else
	    echo "failed"
	fi
}

# check runing stat
run_stat=`docker container ls | grep -i 'spark-' | awk -F 'spark-' '{print $2}'`
echo ${run_stat[@]}
run_stat=${run_stat:-("none", "")}
if [[ ${run_stat[0]} != "none" ]];then
    echo "spark containers already running."
    for con in $run_stat; do
        echo "spark-$con runing..."
    done
    exit 1
else
	echo "starting cluster..."
fi



