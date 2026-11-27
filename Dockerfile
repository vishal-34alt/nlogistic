# ==============================================================================
# N-LOGISTIC: Production Multi-Stage Dockerfile (Maven + Tomcat 9)
# ==============================================================================

# Stage 1: Build the WAR package using Maven & OpenJDK 11
FROM maven:3.9-eclipse-temurin-11 AS builder
WORKDIR /build

# Copy project files
COPY pom.xml .
COPY src ./src

# Package WAR
RUN mvn clean package -DskipTests

# Stage 2: Serve using Apache Tomcat 9 (compatible with javax.servlet 4.0.1)
FROM tomcat:9.0-jdk11-temurin
WORKDIR /usr/local/tomcat

# Remove default ROOT application to deploy N-LOGISTIC directly at "/"
RUN rm -rf webapps/ROOT webapps/docs webapps/examples webapps/host-manager webapps/manager

# Copy WAR as ROOT.war
COPY --from=builder /build/target/*.war webapps/ROOT.war

# Set default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
