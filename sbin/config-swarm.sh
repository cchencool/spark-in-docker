#!/bin/bash

# TODO use params to set prefix & node counts

dir=`dirname $0`
filename=$(basename $0)

if [[ $1 = "--help" ]]; then
    echo "usage: ${filename} [node_counts: default 3] [node_prefix: default myvm]"
    exit 0
fi

node_counts=${1:-3}
node_prefix=${2:-"myvm"}

check_succ()
{
    if [[ $? -eq 0 ]]; then
        echo "success"
    else
        echo "failed"
    fi
}

# echo "creating $node_counts docker machine..."
# for ((i=1; i<=$node_counts; i++));do
#   docker-machine create \
#     --driver virtualbox\
#     ${node_prefix}$i;
# done

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

