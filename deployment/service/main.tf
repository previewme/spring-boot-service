data "terraform_remote_state" "common" {
  backend = "remote"

  config = {
    organization = "previewme"

    workspaces = {
      name = "common-infrastructure-${local.workspace}"
    }
  }
}

data "aws_organizations_organization" "previewme" {}

data "aws_region" "current" {}

data "aws_sns_topic" "alert_topic" {
  name = var.alert_topic_name
}

locals {
  workspace  = var.TFC_WORKSPACE_NAME != "" ? trimprefix(var.TFC_WORKSPACE_NAME, "spring-boot-service-") : terraform.workspace
  account_id = data.terraform_remote_state.common.aws_account_id
}

provider "aws" {
  default_tags {
    tags = {
      Owner       = "PreviewMe"
      Environment = local.workspace
    }
  }

  region  = "us-east-1"
  profile = var.profile
  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/AutomationRole"
    session_name = var.TFC_WORKSPACE_NAME
  }
}
