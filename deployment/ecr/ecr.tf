data "aws_organizations_organization" "previewme" {}

resource "aws_ecr_repository" "default" {
  name                 = var.application_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "default" {
  repository = aws_ecr_repository.default.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images when there are more than 20 container images stored",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 20
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "ecs_ecr_read_perms" {
  statement {
    sid    = "ElasticContainerRegistryRead"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"

      values = [
        data.aws_organizations_organization.previewme.id
      ]
    }
  }
}

data "aws_iam_policy_document" "ecr_read_and_write_perms" {
  source_json = data.aws_iam_policy_document.ecs_ecr_read_perms.json
  statement {
    sid    = "ElasticContainerRegistryWrite"
    effect = "Allow"

    actions = [
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]

    principals {
      type = "AWS"

      identifiers = [
        var.operations_assume_role
      ]
    }
  }
}

resource "aws_ecr_repository_policy" "default" {
  repository = aws_ecr_repository.default.name
  policy     = data.aws_iam_policy_document.ecr_read_and_write_perms.json
}