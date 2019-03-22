FROM ubuntu:18.04 

RUN mkdir /root/install
WORKDIR /root/install

EXPOSE 7077
# EXPOSE 22

RUN apt-get update
# install vim
RUN apt-get install -y vim
# install ssh
RUN apt-get install -y ssh
# install python3.6
RUN apt-get install -y python3.6
RUN apt-get install -y python3-pip
# install jupyter
RUN pip3 install --trusted-host pypi.python.org jupyter

# config trust
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub  >> ~/.ssh/authorized_keys

ADD . .

# ********************************************
# ** install jdk & spark through local file **
ENV WORKDIR="/root/install"
ENV PKG_DIR="/root/install/pkg"
RUN mkdir /opt/jdk && \
    tar zxf ${PKG_DIR}/jdk-8u201-linux-x64.tar.gz --strip-components=1 -C /opt/jdk && \
    rm ${PKG_DIR}/jdk-8u201-linux-x64.tar.gz && \
    echo "extract jdk done."

RUN mkdir /opt/spark && \
    tar zxf ${PKG_DIR}/spark-2.4.0-bin-hadoop2.7.tgz --strip-components=1 -C /opt/spark && \
    rm ${PKG_DIR}/spark-2.4.0-bin-hadoop2.7.tgz && \
    echo "extract spark done."

ENV JAVA_HOME="/opt/jdk"
ENV SPARK_HOME="/opt/spark"
# ENV PYSPARK_DRIVER_PYTHON="jupyter"
# ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook"

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> $SPARK_HOME/sbin/spark-config.sh
RUN echo 'alias python=python3' >> ~/.bashrc && \
    echo 'alias pip=pip3' >> ~/.bashrc && \
    echo "export PYSPARK_PYTHON=`which python3`" >> ~/.bashrc && \
    echo "export JAVA_HOME=${JAVA_HOME}" >> ~/.bashrc && \
    echo "export SPARK_HOME=${SPARK_HOME}" >> ~/.bashrc && \
    echo "export PYSPARK_DRIVER_PYTHON='jupyter'" >> ~/.bashrc && \
    echo "export PYSPARK_DRIVER_PYTHON_OPTS='notebook'" >> ~/.bashrc && \
    echo 'export PATH="${JAVA_HOME}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"' >> ~/.bashrc
# ********************************************

# config ssh & spark.
RUN cp ${WORKDIR}/config/ssh_config ~/.ssh/config && \
    cp ${WORKDIR}/config/slaves ${SPARK_HOME}/conf/slaves

# install other python packages
RUN pip3 install --trusted-host pypi.python.org -r requirements.txt

# config jupyter
RUN jupyter notebook --generate-config && \
    cp ./config/jupyter_notebook_config.py ~/.jupyter/

# ********************************************
# *** install jdk & spark through network ****
# # install openjdk-8
# RUN apt-get install -y openjdk-8-jdk && \
#     java -version
# 
# ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
# 
# # download spark
# RUN apt-get install -y wget && \
#     wget http://apache.01link.hk/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz 
# 
# ********************************************

# start ssh service
# CMD service ssh start && bash
CMD ["sh", "-c", "service ssh start; bash"]

# to connect master
# docker exec -it spark-master bash
