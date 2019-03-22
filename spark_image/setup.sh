#!/bin/bash

# start spark service
${SPARK_HOME}/sbin/start-all.sh;

# start jupyter notebook
jupyter notebook --generate-config --allow-config
