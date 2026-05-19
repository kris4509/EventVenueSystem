# Build the Ant-based NetBeans web application and package it as a WAR
FROM openjdk:11-jdk-slim AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends ant curl unzip && rm -rf /var/lib/apt/lists/*

COPY . .

RUN mkdir -p /tmp/mysql && \
    curl -L -o /tmp/mysql/mysql-connector-java-8.1.0.zip https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.1.0/mysql-connector-java-8.1.0.zip && \
    unzip /tmp/mysql/mysql-connector-java-8.1.0.zip -d /tmp/mysql && \
    mkdir -p web/WEB-INF/lib && \
    cp /tmp/mysql/mysql-connector-java-8.1.0/mysql-connector-java-8.1.0.jar web/WEB-INF/lib/

RUN ant -f build.xml clean
RUN ant -f build.xml

RUN cp dist/EventVenueSystem.war /tmp/app.war

FROM tomcat:9.0-jdk11
COPY --from=builder /tmp/app.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
