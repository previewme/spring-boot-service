terraform {
  backend "remote" {
    organization = "previewme"

    workspaces {
      name = "spring-boot-ecr"
    }
  }
}