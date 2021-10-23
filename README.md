# spring-boot-service

[![Build](https://github.com/previewme/lambda-typescript/actions/workflows/build.yml/badge.svg)](https://github.com/previewme/spring-boot-service/actions/workflows/build.yml)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=previewme_spring-boot-service&metric=coverage)](https://sonarcloud.io/dashboard?id=previewme_spring-boot-service)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=previewme_spring-boot-service&metric=vulnerabilities)](https://sonarcloud.io/dashboard?id=previewme_spring-boot-service)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=previewme_spring-boot-service&metric=alert_status)](https://sonarcloud.io/dashboard?id=previewme_spring-boot-service)

A template project which creates a service using spring boot. This is based
on [spring-boot-java-base by bnc-projects](https://github.com/bnc-projects/spring-boot-java-base/).

## Versioning
We follow [Semantic Versioning](https://semver.org/). The major and minor version can be updated in the `build.gradle` file at the root of the project.

Due to the highly automated deployment pipelines, it is up to developers when they increment version numbers based on the semver rules.

## Build & Test

This project uses gradle and the default tasks to compile and run tests.

```bash
./gradlew clean check assemble
```

### Build and run docker container locally

1. Build the docker container

```
./gradlew clean check assemble docker
```

2. Run the docker container

```bash
docker run -e SPRING_PROFILES_ACTIVE=localhost -p 8080:8080 -i -t spring-boot-service
```

### Build a production equivalent container

```bash
./gradlew clean assemble check docker dockerTag
```

### Profiling

To debug the container locally, the `JAVA_OPTS` environment variable can be provided when running
the container.

```bash
docker run -p 8080:8080 -i -t -e JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005" spring-boot-service
```

## Initial Project Setup

To set up the project by forking this project, then the following instructions need to be carried
out.

## SonarCloud

For code quality checks we use SonarCloud and the project must be setup in SonarCloud.

1. Login to [SonarCloud](https://sonarcloud.io/organizations/previewme)
2. Click the + and then Analyze new project
3. Select the GitHub project you have created with this template
4. Click Setup

## Project Setup

1. The following files need to be modified to suit your project.

### README.md

1. Update the links to the badges
2. Update all references for spring-boot-service

### settings.gradle

1. Update `rootProject.name` to be the correct project name

### Java/SpringBoot configuration

1. Update the packages to suit your service.
2. Update/Remove dummy classes, methods and tests.
3. Update the application name in the spring configuration to suit your service.

## Deployment

This project uses Terraform to deploy the service to ECS cluster.