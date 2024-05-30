# TP DevOps

## TP1

### 1-1 Document your database container essentials: commands and Dockerfile.

Database Dockerfile elements:
- Use the official PostgreSQL image from the Docker Hub
- Set environment variables for PostgreSQL
- Copy initialization scripts to the Docker entry point directory

Building the Docker Image: ```docker build --tag postgres:1.0 .```
- ```docker build```: Command to build a Docker image.
- ```--tag postgres:1.0```: Tags the image as postgres:1.0.
- ```.```: Specifies the current directory as the build context.

Running the Docker Container: ```docker run --name myPostgres -d --network app-network -e POSTGRES_PASSWORD=pwd -p 5455:5432 -v ~/volume_tp1_devops_mde:/var/lib/postgresql/data/ postgres:1.0 ```
- ```docker run```: Command to run a Docker container.
- ```--name myPostgres```: Names the container myPostgres.
- ```-d```: Runs the container in detached mode (in the background).
- ```--network app-network```: Connects the container to the app-network Docker network.
- ```-e POSTGRES_PASSWORD=pwd```: Sets an environment variable for the PostgreSQL password.
- ```-p 5455:5432```: Maps port 5455 on the host to port 5432 in the container.
- ```-v ~/volume_tp1_devops_mde:/var/lib/postgresql/data/```: Mounts the host directory ~/volume_tp1_devops_mde to the container directory /var/lib/postgresql/data/. This ensures data persistence.
- ```postgres:1.0```: Specifies the image to use for the container.

### 1-2 Why do we need a multistage build? And explain each step of this dockerfile.


A multistage build in Docker is a technique used to create optimized Docker images. By using that, we can separate the build environment from the runtime environment, ensuring that our final image only contains the necessary components to run our application, without any of the build dependencies. This results in smaller, more secure, and more efficient images.

**Here we are using a multistage build to have Docker handle the build and run our API**


Detailed Explanation of the Multistage Build Dockerfile steps:
- Build Stage
  - specifies the base image for the build stage
  - Set environment variable for the application home directory
  - Set the working directory inside the container
  - Copy the Maven POM file to the working directory
  - Copy the application source code to the working directory
  - Run the Maven package command to build the application and skip tests
  
- Runtime Stage
  - specifies the base image for the runtime stage
  - Set environment variable for the application home directory
  - Set the working directory inside the container
  - Copy the JAR file from the build stage to the runtime stage
  - Specify the command to run the application


### 1-3 Document docker-compose most important commands.

- ```docker-compose up -d``` : start all the services defined in the file (here we are talking of our 3 containers and the network)
- ```docker-compose down``` : stop and remove all the containers, networks, and volumes defined in the file

### 1-4 Document your docker-compose file.

The docker compose file allows us to define and manage multiple containers as a single service. This file specifies the configuration for each container, including the image to use, ports to map, networks to connect to, dependencies, container names, and any necessary environment variables. In our case, here is the list of components used:
- image: Specifies the Docker image to use for the service. If the image is not available locally, Docker will pull it from the Docker Hub or any other configured repository.
- build: Defines the build context and the Dockerfile to use for building the image. It includes:
  - context: The directory containing the Dockerfile and any other files needed for the build.
  - dockerfile: The path to the Dockerfile relative to the context directory.
- container_name: The name to assign to the container. This name can be used to reference the container in other services or scripts.
- environment: A list of environment variables to set in the container. For example, setting the PostgreSQL password.
- ports: Maps a port on the host to a port in the container. This allows external access to the services running inside the container.
- networks: Specifies the networks the container should be connected to. Networks allow containers to communicate with each other.
- volumes: Mounts a directory from the host into the container. This is useful for data persistence and sharing data between the host and the container.
- depends_on: Specifies dependencies between services. Docker Compose will start the dependent services before starting the service that depends on them.



### 1-5 Document your publication commands and published images in dockerhub.

Steps for publishing the images:

- Renaming with the username of dockerhub so it knows to which repo it should add this image to:
  - `docker login`
  - `docker tag simple_api_student:1.0 thibautdst/tp-devops-backend-simple-api-student:1.0`
  - `docker tag app_http:1.0 thibautdst/tp-devops-http:1.0`
  - `docker tag postgres:1.0 thibautdst/tp-devops-db:1.0`

- Pushing to dockerhub:
  - `docker push thibautdst/tp-devops-backend-simple-api-student:1.0`
  - `docker push thibautdst/tp-devops-http:1.0`
  - `docker push thibautdst/tp-devops-db:1.0`


## TP2

### 2-1 What are testcontainers?

Testcontainers is a Java library designed to support integration testing by providing lightweight, throwaway instances of common databases, Selenium web browsers, or anything else that can run in a Docker container.
It helps ensure that our integration tests are reliable, repeatable, and isolated.

### 2-2 Document your Github Actions configurations.

Steps:
- Creating the GitHub Actions Workflow File
- Create a directory structure `.github/workflows` in the root of your project
- Create the Workflow File
- Create a file named `main.yml` inside
- Configuring the Workflow:
  - Workflow Name: `name: CI devops 2024`
  - Triggers:
    ```
    on:
      push:
        branches: main
    ```
  - Jobs
    - steps:
        - Checkout the Repository
        - Set Up JDK 17
        - Build and Test with Maven (working-directory: ./backend/simple-api-student-main)



### 2-3 Document your quality gate configuration.

In the tp_devops/.github/workflows/test-backend.yml file, I've modified the "Build and test with Maven" action by addind this line: `run: mvn -B verify sonar:sonar -Dsonar.projectKey=epf-tp-devops_tp-devops -Dsonar.organization=epf-tp-devops -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=${{ secrets.SONAR_TOKEN }}` to integrate SonarCloud analysis into my GitHub Actions workflow, ensuring that each code push and pull request is subjected to quality checks

- `mvn -B verify sonar` : Runs the Maven verify goal, which builds the project and runs all tests. The -B flag enables batch mode to reduce the amount of output Maven generates.
- `-Dsonar.projectKey=epf-tp-devops_tp-devops`: Specifies the unique key for the project on SonarCloud.
- `-Dsonar.organization=epf-tp-devops`: Defines the organization under which the project is hosted on SonarCloud.
- `-Dsonar.host.url=https://sonarcloud.io`: Points to the SonarCloud instance for analysis.
- `-Dsonar.login=${{ secrets.SONAR_TOKEN }}`: Uses a secret stored in GitHub Secrets (SONAR_TOKEN) to authenticate with SonarCloud securely.

### Bonus TP2: split pipelines

Done. The config can be checked in the /workflows/test-backend.yml and in /workflows/build-and-push.yml


## TP3


### 3-1 Document your inventory and base commands

### 3-2 Document your playbook

### 3-3 Document your docker_container tasks configuration.

### Bonus TP3

continous deployment 

## TP extras

