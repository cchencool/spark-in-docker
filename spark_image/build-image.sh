#!/bin/bash

echo ""

tag=${1:-0.2}
echo "build docker spark image"
# echo "docker build -t cchencool/spark:$tag ."
docker build -t cchencool/spark:$tag .

echo ""
