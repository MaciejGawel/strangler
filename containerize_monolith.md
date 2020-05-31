# Containerize the Monolith

In this module you will build a Docker image for the monolith application and
run it with use of Docker Compose.

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
   mvn spring-boot:build-image
   ```

1. Verify that image exists

   ```sh
   docker images bookinfo

   REPOSITORY  TAG                 IMAGE ID            CREATED             SIZE
   bookinfo    0.0.1-SNAPSHOT      caf341499b4b        1 minute ago        252MB
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

   <!-- TODO: Change this output when client is ready. -->

   ```sh
   docker-compose logs
   ...
   client_1    | {"_embedded":{"detailsList":[{"id":2,"isbn":"978-3-16-148410-0","author":"William Shakespeare","year":1595,"type":"paperback","pages":200,"publisher":"PublisherA","language":"English","_links":{"self":{"href":"http://bookinfo:8080/details/2"},"details":{"href":"http://bookinfo:8080/details"}}}]},"_links":{"self":{"href":"http://bookinfo:8080/details"}}}
   ```
