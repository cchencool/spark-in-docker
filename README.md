# Spark Cluster in Docker / Docker Swarm
This part is to deploy a spark cluster using docker swarm. Implemented in following steps.

1. Deploy spark cluster in docker containers
2. Deploy spark cluster in docker swarm (VM)
3. Using NFS to do the file sharing in all docker machines.
4. Submit and run tasks
5. Support start jupyter notebook in master / manager node.  

Code Repository: [spark-in-docker](https://github.com/cchencool/spark-in-docker)

## File Structure:

|         directory         |                         description                          |
| :-----------------------: | :----------------------------------------------------------: |
|            bin            | docker container mode scripts. All images startup in local machine. |
|           sbin            | Docker **swarm** deployment scripts. Spark nodes are deployed on docker machines |
|           code            |                        some test code                        |
|          docker           |      files to build docker image and docker-compose.yml      |
|       docker/config       |     configuration files for image building and services.     |
|        docker/pkg         | install packages for image building. Including spark / java / hadoop |
|      docker/setup.sh      | Script for manually setup other configurations. such as jupyter-notebook etc. |
|   docker/build-image.sh   |                  Script for image building                   |
|     docker/Dockerfile     |              Spark image. Base on Ubunut:18.04               |
| docker/docker-compose.yml |                spark services in docker swarm                |

## Detail

#### 1. Docker Image & Dockerfile

1. The image is based on ubuntu:18.04

2. Install some sofewares: vim, ssh, python3.6, jupyter

3. Configurate ssh trust with self

4. Install JDK & Spark thought local file. (Can also through internet.) 

   The install packages should be placed in `docker/pkg` directory according to `required_files.txt` in the same directory.  

5. Configurate environment variables.

6. Configurate Spark slaves. (This is only necessary when start multiple containers of this image in single machine)

7. Install necessary python packages according to file `docker/config/requirements.txt`.

8. Configurate SSH service.

9. Start SSH and waiting for further instructions.

#### 2. Service Stacks & docker-compose.yml

1. There are 2 services: master & worker. And they use the same image which compiled by the Dockerfile above.
2. Adjust the number of workers by change field `services-worker-deploy-replicas`
3. There an overlay network.
4. There is an docker volume: `/nfsshare:/root/nfsshare` which maps local `/nsfshare` folder to container `/root/nfsshare` folder.
5. To ensure the spark can work base on docker swarm, there are 2 options:
   1. - [ ] Using Hadoop with HDFS in docker swarm cluster.
   2. - [x] Using NFS to sync files in the cluster.
6. The container resources are configurable in `cpus` & `memory` fild.
7. The Spark resources are configurable by setting environment variables in `environment` fild. The variables' name can be found in [offical documents of Spark](https://spark.apache.org/docs/latest/spark-standalone.html)

#### 3. Scripts

**Scripts under `bin/`**

Scripts under this folder manage containers directly. And all images startup in local machine.

| Script                     | Usage                                                        |
| -------------------------- | ------------------------------------------------------------ |
| get-master-ip.sh           | Aquire the spark master node IP address.                     |
| resize-cluster.sh          | Change cluster size. Need to stop **ALL** containers before resize. |
| spark-container-service.sh | Entrance for service control. Follow command start, stop, status, usage. |
| spark-containers-start.sh  | Script for **start up** the container mode of spark cluster. |
| spark-containers-status.sh | Script for **checking status** of the container mode of spark cluster. |
| spark-containers-stop.sh   | Script for **stop** the container mode of spark cluster.     |

**Scripts under `sbin/`**

| Script                   | Usage                                                        |
| ------------------------ | ------------------------------------------------------------ |
| config-swarm.sh          | Configurate docker swarm environments. [*1]()                |
| spark-cluster-service.sh | Entrance for service control. Commands: deploy, remove, status, usage. |
| spark-cluster-deploy.sh  | Script for **start up** the spark cluster in docker swarm mode. |
| spark-cluster-status.sh  | Script for **checking status** of the spark cluster in docker swarm mode. |
| spark-cluster-remove.sh  | Script for **stop** the spark cluster in docker swarm mode.  |

*1: For now, the config-swarm script only support create docker machine in virtual box. If you want to run this on a real cluster of physical machines. You should manually configurate the docker machines on these machine, and adjust the script about the IP addresses.

*2: Normally, only need to use the entrance script to manage the spark cluster service (stacks).

#### 4. How to Run

1. Normally, to take the advantage of Spark computation ability, you should run the spark in a real cluser. In this case, please using the script under `sbin/` to manage your cluster as docker swarm mode.
2. By running the command `spark-cluster-service.sh deploy`, the service stacks should be startup and running now.
3. Using the infomation printted out by the script to connect spark cluster.
4. When you want to shut down the cluster, using the script `spark-cluster-service.sh remove`.

## Notice:

**Data upload**

1. For this demo implementation, just using docker-machine virtualBox as driver. You can directly shareing folder `/nfsshare` with host in the virtual box configuration to simulate the well configurated NFS environment.

2. Should use NFS in production. Shareing `/nfsshare` accross the hosts. This folder is also changeable by modifying the `volumes` of 2 services in the `docker-compose.yml` file.

**Task submission**

1. When use the `spark-cluster-service.sh deploy` command start the spark cluster in docker swarm, it should print out the spark-master, spark web UI addresses.
2. To run a task, no matter in Jupyter Notebook or a single driver program, simply follow the [Spark documentation](https://spark.apache.org/docs/latest/spark-standalone.html) to connect your driver to the spark master.
3. You should be aware and manage the CPU & Memory resources by yourself. To ensure multiple drivers are not blocked when running at same time, you should carefully configurate those resource limitation parameters of you driver programs to avoid running out of resources.

## References:
* [hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker)
* [spark-docker-swarm](https://github.com/testdrivenio/spark-docker-swarm)