# Spark cluster in Docker / Docker Swarm
1. Deploy spark cluster in docker containers
2. Deploy spark cluster in docker swarm (VM)
3. Submit and run tasks

-----
## File Structure:

|  directory | description  |
|:-:|:-:|
| bin | docker container mode scripts. All images startup in local machine. |
| sbin  | Docker **swarm** deployment scripts. Spark nodes are deployed on docker machines |
| pkg  | install packages for image building. Including spark / java / hadoop  |
| config | configuration files for image building and services. |
| code | some test code |
| setup.sh | Script for manually setup other configurations. such as jupyter-notebook etc.|
| build-image.sh | Script for image building |
| Dockerfile  | Spark image. Base on Ubunut:18.04  |
-----
## Next Steps:
1. data upload
2. docker volume
3. hadoop/hdfs
