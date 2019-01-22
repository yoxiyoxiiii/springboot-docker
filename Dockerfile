FROM openjdk:8-jdk-alpine
VOLUME /tmp
COPY target/*.jar app.jar
CMD java -jar app.jar