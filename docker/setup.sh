#!/bin/bash

# setup jupyter-notebook env for pyspark
# mkdir /root/workspace && cd /root/workspace

export PYSPARK_DRIVER_PYTHON="jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="notebook --allow-root"

nohup pyspark &
