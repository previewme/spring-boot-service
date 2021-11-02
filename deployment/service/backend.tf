terraform {
  backend "remote" {
    organization = "previewme"

    workspaces {
      prefix = "spring-boot-service-"
    }
  }
}