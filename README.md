# TP DevOps

## TP1

### 1-1 Document your database container essentials: commands and Dockerfile.

Database Dockerfile elements:
- Use the official PostgreSQL image from the Docker Hub
- Set environment variables for PostgreSQL
- Copy initialization scripts to the Docker entry point directory

Building the Docker Image: ```docker build --tag postgres:1.0 .```
- docker build: Command to build a Docker image.
- --tag postgres:1.0: Tags the image as postgres:1.0.
- .: Specifies the current directory as the build context.

Running the Docker Container: 
```docker run --name myPostgres -d --network app-network -e POSTGRES_PASSWORD=pwd -p 5455:5432 -v ~/volume_tp1_devops_mde:/var/lib/postgresql/data/ postgres:1.0
```
- docker run: Command to run a Docker container.
- --name myPostgres: Names the container myPostgres.
- -d: Runs the container in detached mode (in the background).
- --network app-network: Connects the container to the app-network Docker network.
- -e POSTGRES_PASSWORD=pwd: Sets an environment variable for the PostgreSQL password.
- -p 5455:5432: Maps port 5455 on the host to port 5432 in the container.
- -v ~/volume_tp1_devops_mde:/var/lib/postgresql/data/: Mounts the host directory ~/volume_tp1_devops_mde to the container directory /var/lib/postgresql/data/. This ensures data persistence.
- postgres:1.0: Specifies the image to use for the container.



### 1-2 Why do we need a multistage build? And explain each step of this dockerfile.


### 1-3 Document docker-compose most important commands.


### 1-4 Document your docker-compose file.


### 1-5 Document your publication commands and published images in dockerhub.




## TP2

### 2-1 What are testcontainers?

### 2-2 Document your Github Actions configurations.

### 2-3 Document your quality gate configuration.

### Bonus TP2 



## TP3

### 3-1 Document your inventory and base commands

### 3-2 Document your playbook

### 3-3 Document your docker_container tasks configuration.

### Bonus TP3

continous deployment 

## TP extras

