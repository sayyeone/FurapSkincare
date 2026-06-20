# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and package the WAR
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the application on Tomcat 10.1 (Jakarta EE 10 compatible)
FROM tomcat:10.1-jdk17

# Remove default Tomcat webapps for a clean slate
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from the build stage and rename to ROOT.war so it serves at the root path (/)
COPY --from=build /app/target/furapskin-web-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
