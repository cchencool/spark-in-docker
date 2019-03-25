#!/bin/bash

count=${1:-3}
declare -a countent
echo -n '' > slaves
i=1
while [[ $i -lt $count ]]
do
    #countent[((i-1))]="slave$i"
    echo "spark-slave$i" >> slaves
    ((i=i+1))
done

cat slaves
rm slaves