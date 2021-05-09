# Deploy Service Registry

A Service Registry is useful because it enables client-side load-balancing and
decouples service providers from consumers without the need for DNS.

In this exercise, you will set up a [Netflix Eureka][1] Service Registry and
then adjust the Gateway to register with the Registry and use it to resolve
its own host. We will not update the Monolith application configuration because
it will be replaced in the following sections.

Eureka is a REST (Representational State Transfer) based service primarily used
in the AWS cloud for locating services for the purpose of load balancing and
failover of middle-tier servers.

## Useful links

- **[Service Discovery: Eureka Server][2]**
- **[Service Discovery: Eureka Clients][3]**

## Implementation instructions

### Step 1: Generate Service Registry project

1. Visit [Spring Initializr][4]
1. Fill in
  - **Group** - *pl.edu.agh*
  - **Artifact** - *registry*
  - **Description**
1. Add dependency
  - *Eureka Server*
1. Generate template

### Step 2: Enable Eureka Service Registry

1. Annotate Registry Application

   ```java
   package pl.edu.agh.registry;

   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.autoconfigure.SpringBootApplication;
   import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

   @SpringBootApplication
   @EnableEurekaServer
   public class RegistryApplication {

     public static void main(String[] args) {
       SpringApplication.run(RegistryApplication.class, args);
     }
   }
   ```

1. Set application properties

   ```
   #Server port
   server.port=8761
   #Application name
   spring.application.name=registry

   eureka.instance.hostname=localhost
   eureka.client.registerWithEureka=false
   eureka.client.fetchRegistry=false
   eureka.client.serviceUrl.defaultZone=http://${eureka.instance.hostname}:${server.port}/eureka/
   ```

### Step 3: Update Gateway configuration

1. Add Eureka Client dependency

   ```xml
   <dependency>
     <groupId>org.springframework.cloud</groupId>
     <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
   </dependency>
   ```

1. Add `@EnableEurekaClient` to the Gateway application

1. Set Gateway application properties

   ```
   ...

   eureka.client.registerWithEureka=true
   eureka.client.fetchRegistry=true
   eureka.client.serviceUrl.defaultZone=http://registry:8761/eureka/
   ```

   At this point, we cannot use Eureka to discover other services as the legacy
   application is not registered in the Registry.

1. Build Docker image

   ```sh
   mvn spring-boot:build-image -Dspring-boot.build-image.imageName=bookinfo/gateway
   ```

### Step 4: Run Service Registry

1. Build Docker image

   ```sh
   mvn spring-boot:build-image -Dspring-boot.build-image.imageName=bookinfo/registry
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
     gateway:
       image: bookinfo/gateway
       depends_on:
         - registry
         - bookinfo
       links:
         - registry
         - bookinfo
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

   <!-- TODO: Think about hot reload -->

   ```sh
   docker-compose restart
   docker-compose up -d
   ```

1. Access Eureka Dashboard at `http://localhost:8761` and verify that Gateway
   instance is registered.

1. Verify that client is working

   ```sh
   docker-compose logs client -f
   ...
   client_1    | INFO:root:GET /products returned 200 OK
   client_1    | INFO:root:GET /details returned 200 OK
   client_1    | INFO:root:GET /reviews returned 200 OK
   ```

[1]: https://github.com/spring-cloud/spring-cloud-netflix
[2]: https://cloud.spring.io/spring-cloud-netflix/multi/multi_spring-cloud-eureka-server.html
[3]: https://cloud.spring.io/spring-cloud-netflix/multi/multi__service_discovery_eureka_clients.html
[4]: https://start.spring.io/
