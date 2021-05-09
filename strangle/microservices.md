# Deploy microservices

In this section, you will break the Monolith application into three separate
microservices. You will use Eureka for service discovery.

## Implementation instructions

### Step 1: Generate Review project

1. Visit [Spring Initializr][1]
1. Fill in
  - **Group** - *pl.edu.agh*
  - **Artifact** - *review*
  - **Description**
1. Add dependency
  - *Spring Web*
  - *Spring Data JPA*
  - *H2 Database*
  - *Spring HATEOAS*
  - *Eureka Discovery Client*
1. Generate template

### Step 2: Enable Eureka Client

1. Add `@EnableEurekaClient` to the Review application

   ```java
   package pl.edu.agh.review;

   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.autoconfigure.SpringBootApplication;
   import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

   @SpringBootApplication
   @EnableEurekaClient
   public class ReviewApplication {

     public static void main(String[] args) {
       SpringApplication.run(ReviewApplication.class, args);
     }
   }
   ```

1. Set application properties

   ```
   spring.application.name=review

   eureka.client.registerWithEureka=true
   eureka.client.fetchRegistry=false
   eureka.client.serviceUrl.defaultZone=http://registry:8761/eureka/
   ```

### Step 3: Move business logic

Copy all required packages from bookinfo into the new project. Business logic
does not require changes. However, some modifications in import paths may be
needed.

### Step 4: Reconfigure Gateway

1. Set application properties

   ```
   ...

   spring.cloud.gateway.routes[0].id=reviews
   spring.cloud.gateway.routes[0].uri=lb://review
   spring.cloud.gateway.routes[0].predicates[0]=Path=/reviews/**

   spring.cloud.gateway.routes[1].id=bookinfo
   spring.cloud.gateway.routes[1].uri=http://bookinfo:8080
   spring.cloud.gateway.routes[1].predicates[0]=Path=/**
   ```

1. Build Gateway Docker image

   ```sh
   mvn spring-boot:build-image -Dspring-boot.build-image.imageName=bookinfo/gateway
   ```

### Step 5: Run Review Service

1. Build Review Docker image

   ```sh
   mvn spring-boot:build-image -Dspring-boot.build-image.imageName=bookinfo/review
   ```

1. Add new service to Docker compose

   ```yml
   version: '3'
   services:
     bookinfo:
       image: bookinfo/monolith
     registry:
       image: bookinfo/registry
       ports:
         - 8761:8761
     review:
       image: bookinfo/review
       depends_on:
         - registry
       links:
         - registry
     gateway:
       image: bookinfo/gateway
       depends_on:
         - registry
         - bookinfo
         - review
       links:
         - registry
         - bookinfo
         - review
     client:
       build:
         context: ./client
       environment:
         - BOOKINFO_URL=http://gateway:8080
       depends_on:
         - gateway
       links:
         - gateway
   ```

1. Restart Docker Compose

   ```sh
   docker-compose restart
   docker-compose up -d
   ```

1. Access Eureka Dashboard at `http://localhost:8761` and verify that
   microservice instance is registered.

1. Verify that client is working

   ```sh
   docker-compose logs client -f
   ...
   client_1    | INFO:root:GET /products returned 200 OK
   client_1    | INFO:root:GET /details returned 200 OK
   client_1    | INFO:root:GET /reviews returned 200 OK
   ```

   ---

   **NOTE:** You may need to wait before the Review service is registered in
   Eureka. During this period, the Gateway server may be failing.

   ---

### Step 6: Create Details and Product services

Repeat the above steps for Details and Product services. When all services are
migrated, you can disable the bookinfo service.

[1]: https://start.spring.io/
