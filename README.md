# Spark cluster in Docker / Docker Swarm
1. Deploy spark cluster in docker containers
2. Deploy spark cluster in docker swarm (VM)
3. Using NFS to do the file sharing in all docker machines.
4. Submit and run tasks
5. Support start jupyter notebook in master / manager node.  

-----
## File Structure:

|  directory | description  |
|:-:|:-:|
| bin | docker container mode scripts. All images startup in local machine. |
| sbin  | Docker **swarm** deployment scripts. Spark nodes are deployed on docker machines |
| code | some test code |
| docker | files to build docker image and docker-compose.yml |
| docker/config | configuration files for image building and services. |
| docker/pkg  | install packages for image building. Including spark / java / hadoop  |
| docker/setup.sh | Script for manually setup other configurations. such as jupyter-notebook etc.|
| docker/build-image.sh | Script for image building |
| docker/Dockerfile  | Spark image. Base on Ubunut:18.04  |
| docker/docker-compose.yml | spark services in docker swarm |

-----
## Next Steps:
1. data upload - using docker-machine virtualBox as driver. directly shareing folder with host. Should use NFS in production.
2. task submission

-----
## References:
* [hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker)
* [spark-docker-swarm](https://github.com/testdrivenio/spark-docker-swarm)