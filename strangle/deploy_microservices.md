# Deploy microservices

In this section you will break Monolith application into three separate
microserwices. You will use Eureka for the service discovery.

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

1. Add `@EnableEurekaClient` to the Proxy application

   ```java
   package pl.edu.agh.review;

   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.autoconfigure.SpringBootApplication;
   import org.springframework.cloud.netflix.eureka.client.EnableEurekaClient;

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
   eureka.client.registerWithEureka=true
   eureka.client.fetchRegistry=true
   eureka.client.serviceUrl.defaultZone=http://registry:8761/eureka/
   ```

### Step 3: Move business logic

Move review package into Review project

### Step 4: Reconfigure Zuul Proxy

1. Set application properties

   <!-- TODO: verify this configuration -->

   ```
   ...

   zuul.routes.review.path=/reviews/**
   zuul.routes.review.url=http://review:8080/

   zuul.routes.bookinfo.path=/**
   zuul.routes.bookinfo.url=http://bookinfo:8080/
   ```

1. Build Proxy Docker image

   ```sh
   mvn spring-boot:build-image
   ```

### Step 5: Run Review Service

1. Build Review Docker image

   ```sh
   mvn spring-boot:build-image
   ```


1. Add new service to Docker compose

   <!-- TODO: Update this docker-compose when ready -->

   ```yml
   version: '3'
   services:
     registry:
       image: registry:0.0.1-SNAPSHOT
       ports:
         8761:8761
     bookinfo:
       image: bookinfo:0.0.1-SNAPSHOT
       depends_on:
         - registry
       links:
         - registry
     review:
       image: review:0.0.1-SNAPSHOT
       depends_on:
         - registry
       links:
         - registry
     proxy:
       image: proxy:0.0.1-SNAPSHOT
       ports:
         8080:8080
       depends_on:
         - bookinfo
         - review
         - registry
       links:
         - bookinfo
         - review
         - registry
     client:
       build:
         context: ./client
       depends_on:
         - proxy
       links:
         - proxy
   ```

1. Restart Docker Compose

   ```sh
   docker-compose restart
   ```

1. Verify that client is working

   <!-- TODO: Change this output when client is ready. -->

   ```sh
   docker-compose logs
   ...
   client_1    | {"_embedded":{"detailsList":[{"id":2,"isbn":"978-3-16-148410-0","author":"William Shakespeare","year":1595,"type":"paperback","pages":200,"publisher":"PublisherA","language":"English","_links":{"self":{"href":"http://bookinfo:8080/details/2"},"details":{"href":"http://bookinfo:8080/details"}}}]},"_links":{"self":{"href":"http://bookinfo:8080/details"}}}
   ```

### Step 6: Create Details and Product services

Repeat the above steps for Details and Product services. When all services are
migrated, you can disable bookinfo service.

[1]: https://start.spring.io/
