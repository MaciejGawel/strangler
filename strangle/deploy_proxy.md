# Deploy proxy server

To start strangling our legacy application we will need a proxy server that will
route our requests to appropriate microservice. For this purpose we will use
[Netflix Zuul][1].

## Materials

- [Announcing Zuul: Edge Service in the Cloud][2]
- [Open Sourcing Zuul 2][3]
- [Spring Boot – Zuul – API Gateway][4]

## Implementation instructions

### Step 1: Generate proxy project

1. Visit [Spring Initializr][5]
1. Fill in
  - **Group** - *pl.edu.agh*
  - **Artifact** - *proxy*
  - **Description**
1. Add dependency
  - *Zuul*
1. Generate template

### Step 2: Enalbe Zuul Proxy

1. Annotate Proxy Application

   ```java
   package pl.edu.agh.proxy;

   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.autoconfigure.SpringBootApplication;
   import org.springframework.cloud.netflix.zuul.EnableZuulProxy;

   @SpringBootApplication
   @EnableZuulProxy
   public class ProxyApplication {

     public static void main(String[] args) {
       SpringApplication.run(ProxyApplication.class, args);
     }
   }
   ```

1. Set application properties

   <!-- TODO: verify this configuration -->

   ```
   #Server port
   server.port=8080
   #Application name
   spring.application.name=proxy

   zuul.routes.bookinfo.path=/**
   zuul.routes.bookinfo.url=http://localhost:8080/
   ```

### Step 3: Run Proxy Server

1. Build Docker image

   ```sh
   mvn spring-boot:build-image
   ```

1. Add new service to Docker compose

   <!-- TODO: Update this docker-compose when ready -->
   <!-- TODO: Add env to client -->

   ```yml
   version: '3'
   services:
     bookinfo:
       image: bookinfo:0.0.1-SNAPSHOT
     proxy:
       image: proxy:0.0.1-SNAPSHOT
       ports:
         8080:8080
       depends_on:
         - bookinfo
       links:
         - bookinfo
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


[1]: https://github.com/Netflix/zuul
[2]: https://netflixtechblog.com/announcing-zuul-edge-service-in-the-cloud-ab3af5be08ee
[3]: https://netflixtechblog.com/open-sourcing-zuul-2-82ea476cb2b3
[4]: https://codecouple.pl/2018/03/16/31-spring-boot-zuul-api-gateway/
[5]: https://start.spring.io/