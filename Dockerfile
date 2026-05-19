# Build the Ant-based NetBeans web application and package it as a WAR
# Use a widely-available Temurin Java 11 image (more reliably available on registries)
FROM eclipse-temurin:11-jdk AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends ant curl unzip && rm -rf /var/lib/apt/lists/*

COPY . .

RUN mkdir -p web/WEB-INF/lib && \
    curl -L -o web/WEB-INF/lib/mysql-connector-java-8.0.33.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar

RUN ant -f build.xml clean
RUN ant -f build.xml

RUN cp dist/EventVenueSystem.war /tmp/app.war

FROM tomcat:9.0-jdk11
COPY --from=builder /tmp/app.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
