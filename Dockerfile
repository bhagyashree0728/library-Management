# Multi-stage Docker build for Spring MVC (JSP) app on Tomcat 10 + JDK 21

# 1) Build stage: compile and package WAR
FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /app

# Copy only the Maven descriptor first to leverage Docker layer caching
COPY pom.xml ./

# Copy source
COPY src ./src

# Build the project (skip tests for faster CI builds)
RUN mvn -DskipTests clean package


# 2) Runtime stage: Tomcat 10 + JDK 21
FROM tomcat:10.1-jdk21-temurin

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR into Tomcat as ROOT.war (served at /)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh","run"]


