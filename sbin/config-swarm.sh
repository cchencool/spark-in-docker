#!/bin/bash

# TODO use params to set prefix & node counts

dir=`dirname $0`
filename=$(basename $0)

for i in "$@"
do
case $i in
    -h|--help)
    echo "usage: ${filename} [-c|--create] [-n=|--num=3] [-p|--prefix=myvm]"
    exit 0
    ;;
    -c|--create)
    create=ture
    ;;
    -n=*|--num=*)
    node_counts="${i#*=}"
    ;;
    -p=*|--prefix=*)
    node_prefix="${i#*=}"
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
    # unknown option
    ;;
esac
done

node_counts=${node_counts:-3}
node_prefix=${node_prefix:-"myvm"}
create=${create:-false}

# echo $node_counts
# echo $node_prefix
# echo $create
# exit

check_succ()
{
    if [[ $? -eq 0 ]]; then
        echo "success"
    else
        echo "failed"
    fi
}

if [[ $create ]]; then
    echo "creating $node_counts docker machine..."
    for ((i=1; i<=$node_counts; i++));do
      docker-machine create \
        --driver virtualbox\
        ${node_prefix}$i;
    done
fi

# for i in {1..$node_counts} ; do
for ((i=1; i<=$node_counts; i++));do
    vms[$i]=${node_prefix}$i
done

docker-machine start ${vms[@]}

node_master=${node_prefix}1
echo -n "Initializing Swarm mode..."
docker-machine ssh ${node_master} -- docker swarm init --advertise-addr $(docker-machine ip ${node_master})
# docker-machine ssh ${node_master} -- docker node update --availability drain ${node_master}

i=2
echo "Adding the nodes to the Swarm..."
TOKEN=`docker-machine ssh ${node_master} docker swarm join-token worker | grep token | awk '{ print $5 }'`
while [ $i -le $node_counts ]; do
    docker-machine ssh ${node_prefix}${i} "docker swarm join --token ${TOKEN} $(docker-machine ip ${node_master}):2377"
    ((i=i+1))
done

