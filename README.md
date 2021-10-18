# spring-boot-service
A template project which creates a service using spring boot.

## Build & Test
This project uses gradle and the default tasks to compile and run tests.
```
./gradlew clean assemble check
```

### Build and run docker container locally
1. Build the docker container
```
./gradlew clean assemble check docker
```

## Deployment
This project uses Terraform to deploy the service to ECS cluster. To deploy the service fork this project and then follow the instructions below.

