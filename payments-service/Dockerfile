FROM maven:3.8.5-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/payments-service-example-0.0.1-SNAPSHOT.jar /app/payments-service-example.jar
CMD ["java", "-jar", "payments-service-example.jar"]