data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "codedeploy.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "codedeploy-role" {
  name = join("", [
    var.application_name,
    "CodeDeployRole"
  ])

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.codedeploy-role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_codedeploy_app" "application" {
  compute_platform = "ECS"
  name             = var.application_name
}

resource "aws_codedeploy_deployment_group" "blue_green" {
  app_name               = aws_codedeploy_app.application.name
  deployment_config_name = data.terraform_remote_state.common.outputs.ecs_default_deployment_config_name
  deployment_group_name = join("-", [
    var.application_name,
    "group"
  ])

  service_role_arn = aws_iam_role.codedeploy-role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = data.terraform_remote_state.common.outputs.ecs_cluster_name
    service_name = var.application_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          data.terraform_remote_state.common.outputs.public_lb_https_listener
        ]
      }

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }

  depends_on = [
    aws_ecs_service.application
  ]
}