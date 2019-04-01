#!/bin/bash

echo ""

dir=`dirname $0`
filename=$(basename $0)

cd $dir

tag=${1:-"latest"}
echo "build docker spark image"
# echo "docker build -t cchencool/spark:$tag ."
docker build -t cchencool/spark:$tag .

echo ""
