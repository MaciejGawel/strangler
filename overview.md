# Overview

In this exercise, you will learn how to migrate from legacy monolith
application to the cloud-native microservices. We'll use practices from Martin
Fowler's [Strangler Fig Application][1] to slowly strangle away from a legacy
system using microservices.

In this class, you will:

1. Deploy legacy monolith application in Docker container.
1. Deploy [Netflix Open Source Software][2] (Netflix OSS)
  - Eureka
  - Zuul
  - Zipkin
1. Break monolith into several microservices
1. Strangle legacy application with new microservices deployed in Docker

This guide contains simplified exercises. The migration of the production-grade
application might take many months and must take into consideration many
aspects, such as data migration and zero downtime.

## [Why it Matters][6]

Traditional monolithic architectures are hard to scale. As an application's code
base grows, it becomes complex to update and maintain. Introducing new features,
languages, frameworks, and technologies becomes very hard, limiting innovation
and new ideas.

Within a microservices architecture, each application component runs as its own
service and communicates with other services via a well-defined API.
Microservices are built around business capabilities, and each service performs
a single function. Microservices can be written using different frameworks and
programming languages, and you can deploy them independently, as a single
service, or as a group of services.

## Prerequisites

In this course you will use:

- Docker
- Docker Compose
- Github
- Java with Maven
- Python

To complete this course, make sure that you have the following tools:

- Docker CE - [installation guide][4]
- Docker Compose - [installation guide][5]
- Git client
- Java
- Maven

[1]: https://martinfowler.com/bliki/StranglerFigApplication.html
[2]: https://netflix.github.io/
[3]: https://spring.io/
[4]: https://docs.docker.com/engine/install/
[5]: https://docs.docker.com/compose/install/
[6]: https://aws.amazon.com/getting-started/hands-on/break-monolith-app-microservices-ecs-docker-ec2/
