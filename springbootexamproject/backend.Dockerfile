# Stage 1: Build the app
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

# Install Maven directly (since mvnw and .mvn folder might be missing)
RUN apt-get update && apt-get install -y maven

# Copy only what’s needed for the build
COPY pom.xml ./
COPY src ./src

# Build the app, skipping tests for faster build
RUN mvn clean package -DskipTests

# Stage 2: Run the app
FROM eclipse-temurin:21-jdk

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 2000

ENTRYPOINT ["java", "-jar", "app.jar"]
