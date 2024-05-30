# Build
FROM maven:3.8.6-amazoncorretto-17 AS myapp-build

# Set environment variable for the application home directory
ENV MYAPP_HOME /opt/myapp

# Set the working directory inside the container
WORKDIR $MYAPP_HOME

# Copy the Maven POM file to the working directory
COPY pom.xml .
# Copy the application source code to the working directory
COPY src ./src

# Run the Maven package command to build the application and skip tests
RUN mvn package -DskipTests



# Runtime Stage
FROM amazoncorretto:17

# Set environment variable for the application home directory

ENV MYAPP_HOME /opt/myapp

# Set the working directory inside the container
WORKDIR $MYAPP_HOME

# Copy the JAR file from the build stage to the runtime stage
COPY --from=myapp-build $MYAPP_HOME/target/*.jar $MYAPP_HOME/myapp.jar

# Specify the command to run the application
ENTRYPOINT java -jar myapp.jar