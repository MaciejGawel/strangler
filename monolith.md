# Containerize the Monolith

In this module, you will build a Docker image for the monolith application and
run it using Docker Compose. This sample application is written in Java with the
use of [Spring framework][1]. The following diagram presents the application
architecture.

<center><img src="images/architecture.svg" /></center>

## Implementation instructions

### Step 1: Download & open the project

Download the source code from Github

```sh
git clone https://github.com/MaciejGawel/spring-bookinfo.git
```

### Step 2: Build bookinfo Docker image

1. Navigate to the *bookinfo* directory.
1. Build image with Maven

   ```sh
   mvn spring-boot:build-image -Dspring-boot.build-image.imageName=bookinfo/monolith
   ```

1. Verify that image exists

   ```sh
   docker images bookinfo/monolith

   REPOSITORY           TAG         IMAGE ID            CREATED            SIZE
   bookinfo/monolith    latest      caf341499b4b        1 minute ago       252MB
   ```

### Step 3: Build Client image

1. Navigate to the root directory
1. Run Docker Cmpose build action

   ```sh
   docker-compose build
   ```

### Step 4: Run Docker Compose

1. Run Docker Compose up action

   ```sh
   docker-compose up -d
   ```

1. Verify that client is working

   ```sh
   docker-compose logs -f
   ...
   client_1    | INFO:root:GET /products returned 200 OK
   client_1    | INFO:root:GET /details returned 200 OK
   client_1    | INFO:root:GET /reviews returned 200 OK
   ```

[1]: https://spring.io/
