provider "aws" {
  default_tags {
    tags = {
      Owner       = "PreviewMe"
      Environment = "production"
    }
  }

  region  = "us-east-1"
  profile = var.profile
  assume_role {
    role_arn     = var.operations_assume_role
    session_name = var.TFC_WORKSPACE_NAME
  }
}
