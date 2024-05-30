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

- Ask Ansible to install Apache into your instance to make it a webserver. The --become flag tells Ansible to perform the command as a super user:
  ```
  ansible -i ansible/Inventory/setup.yml all -m yum -a "name=httpd state=present" --private-key=~/.ssh/devops_mde_takima/id_rsa -u centos --become
  ```
- create an html page for our website:
  ```
  ansible -i ansible/Inventory/setup.yml all -m shell -a 'echo "<html><h1>Hello World</h1></html>" >> /var/www/html/index.html' --private-key=~/.ssh/devops_mde_takima/id_rsa -u centos --become
  ```
- start Apache service
  ```
  ansible -i ansible/Inventory/setup.yml all -m service -a "name=httpd state=started" --private-key=~/.ssh/devops_mde_takima/id_rsa -u centos --become
  ```
- displays OS distribution information for all hosts listedansible/Inventory/setup.yml
  ```
  ansible all -i ansible/Inventory/setup.yml -m setup -a "filter=ansible_distribution*"
  ```
  - `ansible`: Runs Ansible.
  - `all`: Targets all hosts in the inventory.
  - `-i ansible/Inventory/setup.yml`: Specifies the inventory file to use.
  - `-m setup`: Uses the `setup` module to gather facts.
  - `a "filter=ansible_distribution*"`: Filters facts to include only those related to the OS distribution
- Removes the httpd package from all hosts listed in the ansible/Inventory/setup.yml inventory file
  ```
  ansible all -i ansible/Inventory/setup.yml -m yum -a "name=httpd state=absent" --become
  ```
  - `ansible`: Initiates Ansible.
  - `all`: Targets all hosts in the specified inventory file.
  - `i ansible/Inventory/setup.yml`: Specifies the inventory file.
  - `m yum`: Uses the `yum` module to manage packages.
  - `a "name=httpd state=absent"`: Specifies the action to take: remove `httpd` package
  - `-become`: Assumes superuser privileges to execute the command.

  
### 3-2 Document your playbook

- `hosts`: Specifies the group of hosts to which the playbook will be applied. In this case, `all` means that the playbook will run on all hosts specified in the inventory file.
- `gather_facts`: Indicates whether Ansible should gather facts about the hosts before executing tasks. Setting it to `false` disables fact gathering.
- `become`: Specifies whether to escalate privileges before executing tasks. Setting it to `true` allows Ansible to become a superuser (usually `root`) on the target hosts.
- `roles`: Specifies a list of roles to be applied to the hosts. Roles are reusable collections of tasks, handlers, and other files organized in a structured directory format. In this playbook, the `docker` role will be applied to all hosts.

### 3-3 Document your docker_container tasks configuration.

```
# tasks file for roles/app

- name: Launch Backend Application
  docker_container:
    name: simple_api_student
    image: thibautdst/tp-devops-backend-simple-api-student:latest
    state: started
    restart_policy: always
    networks:
      - name: app-network
    ports:
      - "8080:8080"
---
# tasks file for roles/proxy

- name: Launch Proxy/Front Application
  docker_container:
    name: myHTTP
    image: thibautdst/tp-devops-http:latest
    state: started
    restart_policy: always
    networks:
      - name: app-network
    ports:
      - "80:80"
    pull: yes #ensure to pull the latest image even if it's already downloaded
---
# tasks file for roles/databases

- name: Launch PostgreSQL Database
  docker_container:
    name: myPostgres
    image: thibautdst/tp-devops-db:latest
    state: started
    restart_policy: always
    networks:
      - name: app-network
    ports:
      - "5432:5432"
```

**Configuration Overview**
- Name: Specifies the name of the Docker container.
- Image: Specifies the Docker image to be used for the container.
- State: `started`: Ensures that the container is running.
- Restart Policy: `always`: Specifies that the container should always restart if it stops.
- Networks: `app-network`: Attaches the container to the `app-network` Docker network.
- Ports Mapped: [left:right] : Maps port [left] on the host to port [right] in the container.
- **Pull Image**: `yes`: Pull policy: Forces Docker to pull the latest image even if it's already downloaded.


### Bonus TP3: Continous deployment 

Done. The config can be checked in /workflows/deploy.yml

## TP extras: Load balancer & grafana

There are not visible because I reverted back to a working commit, to ensure that my server is correctly running and the proxy is accessible, but here are the configs I tried:

### Load balancer

I tried to set it up with such config: 

httpd.cong:
```
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so
LoadModule slotmem_shm_module modules/mod_slotmem_shm.so

<VirtualHost *:80>
  ServerName localhost
  ProxyPreserveHost On
  <Proxy balancer://mycluster>
      BalancerMember http://simple_api_student:8081
      BalancerMember http://simple_api_student_instance2:8082
      ProxySet lbmethod=byrequests
  </Proxy>

  # Set up proxy pass and reverse proxy
  ProxyPass / balancer://mycluster/
  ProxyPassReverse / balancer://mycluster/
</VirtualHost>
```

roles/backend/tasks/main.yml:
```
---
# tasks file for roles/app

- name: Launch Backend Application
  docker_container:
    name: simple_api_student
    image: thibautdst/tp-devops-backend-simple-api-student:latest
    state: started
    restart_policy: always
    networks:
      - name: app-network
    ports:
      - "8081:8080"
---
# tasks file for roles/app2

- name: Launch Backend Application instance 2
  docker_container:
    name: simple_api_student_instance2
    image: thibautdst/tp-devops-backend-simple-api-student:latest
    state: started
    restart_policy: always
    networks:
      - name: app-network
    ports:
      - "8082:8080"
```

### Grafana

my config in roles/grafana/tasks/main.yml:
```
---
# tasks file for roles/grafana

- name: Install dependencies
  yum:
    name: "{{ item }}"
    state: present
  loop:
    - initscripts
    - fontconfig

- name: Add Grafana repository
  yum_repository:
    name: grafana
    description: Grafana Repository
    baseurl: https://packages.grafana.com/oss/rpm
    gpgcheck: yes
    gpgkey: https://packages.grafana.com/gpg.key
    enabled: yes

- name: Install Grafana
  yum:
    name: grafana
    state: present

- name: Start and enable Grafana service
  service:
    name: grafana-server
    state: started
    enabled: yes
```
