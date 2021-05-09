# Deploy edge server

To start strangling our legacy application, we will need a proxy server that
will route our requests to a specific microservice. Netflix OSS provides a proxy
server called Zuul. However, Spring will not support Zuul 2. Therefore, for this
excersice you will use [Spring Cloud Gatway][1].

## Useful links

- [Exploring the New Spring Cloud Gateway][2]
- [Zuul migrated to Spring-Cloud-Gateway][3]

## Implementation instructions

### Step 1: Generate gateway project

1. Visit [Spring Initializr][6]
1. Fill in
  - **Group** - *pl.edu.agh*
  - **Artifact** - *gateway*
  - **Description**
1. Add dependency
  - *Gateway*
1. Generate template

### Step 2: Enalbe Gateway

1. Set application properties

   ```
   #Server port
   server.port=8080
   #Application name
   spring.application.name=gateway

   spring.cloud.gateway.routes[0].id=bookinfo
   spring.cloud.gateway.routes[0].uri=http://bookinfo:8080
   spring.cloud.gateway.routes[0].predicates[0]=Path=/**
   ```

### Step 3: Run Gateway Server

1. Build Docker image

   ```sh
   mvn spring-boot:build-image -Dspring-boot.build-image.imageName=bookinfo/gateway
   ```

1. Add new service to Docker compose

   ```yml
   version: '3'
   services:
     bookinfo:
       image: bookinfo/monolith
     gateway:
       image: bookinfo/gateway
       depends_on:
         - bookinfo
       links:
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

   ```sh
   docker-compose restart
   docker-compose up -d
   ```

1. Verify that client is working

   ```sh
   docker-compose logs client -f
   ...
   client_1    | INFO:root:GET /products returned 200 OK
   client_1    | INFO:root:GET /details returned 200 OK
   client_1    | INFO:root:GET /reviews returned 200 OK
   ```

[1]: https://spring.io/projects/spring-cloud-gateway
[2]: https://www.baeldung.com/spring-cloud-gateway
[3]: https://www.programmersought.com/article/2878807662/
[6]: https://start.spring.io/
