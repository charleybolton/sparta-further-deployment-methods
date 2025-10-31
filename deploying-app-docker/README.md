- [Deploying the Library Java Spring Boot Application Using Docker](#deploying-the-library-java-spring-boot-application-using-docker)
  - [Build Phase vs Run Phase](#build-phase-vs-run-phase)
  - [Dockerfile](#dockerfile)
    - [Build the Docker Image](#build-the-docker-image)
    - [Run the Container](#run-the-container)

# Deploying the Library Java Spring Boot Application Using Docker

This section documents converting the application deployment from Virtual Machines to **containerisation** using Docker. 

---

## Build Phase vs Run Phase

| Phase | Purpose | Where it Happens |
|------|---------|-----------------|
| **BUILD** | Compiles the source code and produces the `.jar` file | Local machine or CI pipeline |
| **RUN** | Executes the already-built `.jar` file | Inside a Docker container |

- Docker is used **only** in the **RUN** phase, so the `.jar` must already exist before containerisation.
- Generating the `.jar` is done using the build tool: `mvn clean install -DskipTests`
- This produces: `LibraryProject2/target/LibraryProject2-0.0.1-SNAPSHOT.jar`

A `.jar` file (Java ARchive) is a single packaged output produced after compiling the application. During the build phase, all `.java` source files are compiled into `.class` bytecode, and any required resources are bundled together. These are then packaged into the `.jar` along with a manifest that tells the Java runtime how to start the application.

Because the `.jar` already contains compiled code, the container does not need:
- The source code
- Maven or Gradle
- The Java compiler

It only needs the Java **runtime** to execute the file. Running the application in the container simply involves `java -jar app.jar`.

This is why the build must happen before containerisation: the container runs the completed application, not the build process itself.

---

## Dockerfile


```yml
FROM openjdk:17-jdk-alpine
#Specifies the container’s starting environment. (Provides the Java 17 runtime on a minimal Alpine Linux base, which results in a smaller container footprint and faster startup..  

This results in a smaller container footprint and faster startup.
# Adds descriptive information used for identification inside container orchestration platforms.

LABEL description="Java Spring Boot test app container"
# Defines `/usr/src/app` as the default directory inside the container where commands will run. If the directory does not exist, Docker creates it automatically.

COPY app/LibraryProject2/target/LibraryProject2-0.0.1-SNAPSHOT.jar app.jar
# Copies the pre-built `.jar` file from the host into the container filesystem.  

EXPOSE 8080
# Documents the port the application listens on within the container. This does not map the port externally; it simply declares it for reference.

CMD ["java", "-jar", "app.jar"]
# Specifies the instruction executed when the container starts. Runs the `.jar` using the Java runtime included in the base image.
```

### Build the Docker Image

```bash
docker build -t spring-boot-app .
```

This packages the Dockerfile and application artifact into a runnable image.

### Run the Container

```bash
docker run -p 8080:5000 spring-boot-app

Host port `8080` is forwarded to container port `5000`, which is defined in the application’s `server.port=5000` (application.properties).
```


The application initially logs:

```bash
Tomcat initialized with port(s): 5000 (http)
```

This confirms:
- The container started successfully
- Spring Boot loaded correctly
- Tomcat is listening internally on port 5000

The application then terminates with:

```bash
Factory method 'dataSource' threw exception with message: URL must start with 'jdbc'
```

This indicates:
- The application evaluated its datasource configuration
- No valid database connection properties were supplied

```bash
The datasource settings are defined as:

spring.datasource.url=${DB_HOST}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASS}
```

Because the container was started without passing environment variables, these values were empty.  
Spring Boot requires a valid JDBC connection string at startup, so it shuts down when this is missing. 

*Note: A JDBC connection string is the exact piece of text that tells a Java application where the database is, what type of database it is, and how to connect to it.*