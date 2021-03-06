# spring-boot-service

[![Service Build](https://github.com/previewme/spring-boot-service/actions/workflows/build.yml/badge.svg)](https://github.com/previewme/spring-boot-service/actions/workflows/build.yml)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=previewme_spring-boot-service&metric=coverage&token=eade2272df62550b313135a6a7658ae5539cb1ab)](https://sonarcloud.io/summary/new_code?id=previewme_spring-boot-service)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=previewme_spring-boot-service&metric=vulnerabilities&token=eade2272df62550b313135a6a7658ae5539cb1ab)](https://sonarcloud.io/summary/new_code?id=previewme_spring-boot-service)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=previewme_spring-boot-service&metric=alert_status&token=eade2272df62550b313135a6a7658ae5539cb1ab)](https://sonarcloud.io/summary/new_code?id=previewme_spring-boot-service)

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

To set up the project by forking this project, then the following instructions need to be carried out. Please read these instructions carefully to ensure no steps are missed out.

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

1. Update `rootProject.name` to be the correct project name. E.g: foo

### Java/SpringBoot configuration

1. Update the packages to suit your service.
2. Update/Remove dummy classes, methods and tests.
3. Update the application name in the spring configuration to suit your service.
4. Application configuration and secrets are stored in [AWS Parameter store or AWS secrets manager](https://docs.awspring.io/spring-cloud-aws/docs/2.3.0/reference/html/index.html#integrating-your-spring-cloud-application-with-the-aws-parameter-store)
   1. Configuration can be set globally for all services or overridden/set per service.

## Versions

We follow semantic versioning where possible. Generally we do not update versions unless there has been a breaking change in our service contracts.

The versions can be increased in the GitHub Action file when required.

## Deployment

This project uses Terraform to deploy the service to the PreviewMe ECS cluster.

### AWS Credentials
The ECR and Service deployment require AWS Credentials to be setup in Terraform Cloud. This can be done by running the [terraform-cloud-boostrap](https://github.com/previewme/terraform-cloud-bootstrap) action.

### ECR repository Deployment
The following changes need to be made in the Terraform configuration. 

The GitHub workflow will use the repository name for the application name, it is essential to name the repository appropriately. E.g: foo-service.

#### Workspace names
* `deployment/ecr/backend.tf` replace the workspace name to match the project name in settings.gradle. E.g: foo-ecr
* `deployment/service/backend.tf` replace the workspace prefix to match the project name in settings.gradle. E.g: foo-service

### Service Deployment
To ensure the service deploys correctly the following steps need to be carried out:

1. Update the `application_name` and `application_path` in `deployment/service/variables.tf
2. Enable production deployments by replacing ```if: ${{ false }}``` with ```if: github.ref == 'refs/heads/main' && github.event_name == 'push'```