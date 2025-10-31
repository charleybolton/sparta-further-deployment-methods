FROM openjdk:17-jdk-alpine
LABEL description="Java Spring Boot test app container"
WORKDIR /usr/src/app
COPY app/LibraryProject2/target/LibraryProject2-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
