# =========================
# Stage 1 - Maven Build
# =========================
FROM maven:3.9-eclipse-temurin-8 AS build

WORKDIR /build

COPY pom.xml .
COPY src ./src

RUN mvn clean install -DskipTests


# =========================
# Stage 2 - Runtime
# =========================
FROM eclipse-temurin:8-jre-alpine

# Required for starting application up.
RUN apk update && apk add /bin/sh

RUN mkdir -p /opt/app
ENV PROJECT_HOME=/opt/app

COPY --from=build /build/target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar

WORKDIR $PROJECT_HOME
EXPOSE 8080

CMD ["java","-jar","./spring-boot-mongo.jar"]
