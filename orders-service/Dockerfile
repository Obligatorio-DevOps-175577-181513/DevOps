FROM maven:3.8.5-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/orders-service-example-0.0.1-SNAPSHOT.jar /app/orders-service-example.jar
CMD ["java", "-jar", "orders-service-example.jar"]