# Running MySQL Server with a docker

Running MySQL community edition server in a docker container

# Purpose
Demonstrate the purpose of using Docker container to deploy a database

# Creating Docker Image
## Clone this repo
```git clone https://github.com/royalghost/mysqldockerdemo```

### Following files should be available
```
$ls

Dockerfile create-database.sql	docker-compose.yml

```
### Dockerfile 
Container Definition as follows:

```
# To download the MySQL Community Server Image
FROM mysql/mysql-server:latest

# Set the working directory to /app
WORKDIR /app

# Copy the current directory content into the container at /app
COPY . /app

```

### docker-compose.yml 
A YAML file that defines how docker containers should behave as follows:

```
# Use root/example as user/password credentials

version: '3'

services:
  db:
    image: mysqldemo
    command: --init-file /app/create-database.sql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: demo
      MYSQL_USER: root
      MYSQL_PASSWORD: example
    ports:
      - "33061:3306"
```
### create-database.sql
Database script to initialize during startup
```
--CREATE DATABASE demo CHARACTER SET utf8 COLLATE utf8_general_cli;

CREATE USER 'demo'@'%' IDENTIFIED BY 'demo';
GRANT ALL PRIVILEGES ON demo.* TO 'demo'@'%' WITH GRANT OPTION;
CREATE USER 'demo'@'localhost' IDENTIFIED BY 'demo';
GRANT ALL PRIVILEGES ON demo.* TO 'demo'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;
```
## Build image using Dockerfile
```
docker build -t mysqldemo .
```

## Make sure the docker image is created

```
docker images

REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
mysqldemo            latest              65735dbe7839        45 seconds ago      309MB
mysql/mysql-server   latest              1fdf3806e715        7 weeks ago         309MB
```

## Set up your swarm
Enable swarm mode and make your machine as a swarm manager

```docker swarm init```

## Run MySQL as a service in a docker container using the image created through docker-compose.yml
```
docker stack deploy -c docker-compose.yml mysqldemo
```

## Make sure container is running
```
docker container ls
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                            PORTS                 NAMES
72459de0a7f1        mysqldemo:latest    "/entrypoint.sh --in…"   11 seconds ago      Up 4 seconds (health: starting)   3306/tcp, 33060/tcp   mysqldemo_db.1.gadhw01bfodbssp2yp2n2hzdp
```

## See docker container logs
```
docker logs 72459de0a7f1
[Entrypoint] MySQL Docker Image 8.0.12-1.1.7
[Entrypoint] Initializing database

```

## Make sure the service is also running
```
docker service ls

ID                  NAME                  MODE                REPLICAS            IMAGE               PORTS
rxc7xl0bzt68        mysqldemoservice_db   replicated          0/1                 mysqldemo:latest    *:33061->3306/tcp
```
It is now running in only 1 container instances.

## Run mysql as docker command
```
docker exec -it 72459de0a7f1 mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 14
Server version: 8.0.12 MySQL Community Server - GPL

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```

## Confirm database is created
```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| demo               |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

```
## Use bash
```
docker exec -it 72459de0a7f1 bash
bash-4.2# 

```

## See your current directory
```
bash-4.2# pwd
/app

```

# References
Get Started with Docker - https://docs.docker.com/get-started/part2/
Basic Steps for MySQL Server Deployment with Docker - https://dev.mysql.com/doc/mysql-installation-excerpt/5.5/en/docker-mysql-getting-started.html

