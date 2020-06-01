# Deploy Service Registry

A service registry is useful because it enables client-side load-balancing and
decouples service providers from consumers without the need for DNS.

In this exercise you will set up a [Netflix Eureka][1] service registry and then
adjust Proxy Server to register itself with the registry and use it to resolve
its own host. We will not update Monolith application configuration because it
will be replaced in the following sections.

Eureka is a REST (Representational State Transfer) based service that is
primarily used in the AWS cloud for locating services for the purpose of load
balancing and failover of middle-tier servers.

## Useful links

- [Service Discovery: Eureka Server][2]
- [Service Discovery: Eureka Clients][3]

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

### Step 2: Enalbe Eureka Service Registry

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

   <!-- TODO: verify this configuration -->

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

### Step 3: Update Proxy configuration

1. Add Eureka Client dependency

   ```xml
   <dependency>
     <groupId>org.springframework.cloud</groupId>
     <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
   </dependency>
   ```

1. Add `@EnableEurekaClient` to the Proxy application

1. Add `eureka.client.serviceUrl.defaultZone=http://registry:8761/eureka/` to
   the Proxy application properties

1. Build Docker image

   ```sh
   mvn spring-boot:build-image
   ```

### Step 4: Run Service Registry

1. Build Docker image

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
     proxy:
       image: proxy:0.0.1-SNAPSHOT
       ports:
         8080:8080
       depends_on:
         - bookinfo
         - registry
       links:
         - bookinfo
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

   <!-- TODO: Think about hot reload -->

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


[1]: https://github.com/spring-cloud/spring-cloud-netflix
[2]: https://cloud.spring.io/spring-cloud-netflix/multi/multi_spring-cloud-eureka-server.html
[3]: https://cloud.spring.io/spring-cloud-netflix/multi/multi__service_discovery_eureka_clients.html
[4]: https://start.spring.io/
