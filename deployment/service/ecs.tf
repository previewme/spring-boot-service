data "aws_iam_policy_document" "task_service_assume_role" {
  statement {
    sid    = "AllowECSTaskToAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy" "execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "execution_task_role" {
  name               = format("%s-execution", var.application_name)
  assume_role_policy = data.aws_iam_policy_document.task_service_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_default_policy" {
  role       = aws_iam_role.execution_task_role.name
  policy_arn = data.aws_iam_policy.execution_policy.arn
}

resource "aws_iam_role" "task_role" {
  name               = format("%s-task", var.application_name)
  assume_role_policy = data.aws_iam_policy_document.task_service_assume_role.json
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = format("/aws/ecs/%s", var.application_name)
  retention_in_days = var.cloudwatch_log_retention_period
}

resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = jsonencode([
    {
      name      = var.application_name
      image     = var.container_image
      essential = true
      cpu       = 0

      environment = [
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = local.workspace
        }
      ]

      mountPoints = []

      volumesFrom = []

      portMappings = [
        {
          containerPort = var.application_port
          hostPort      = var.launch_type == "FARGATE" ? var.application_port : 0
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",

        options = {
          awslogs-group         = aws_cloudwatch_log_group.log_group.name
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = "previewme"
        }
      }
    }
  ])

  family             = var.application_name
  cpu                = "256"
  memory             = "512"
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.execution_task_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  requires_compatibilities = [
    var.launch_type
  ]
}

resource "aws_ecs_service" "application" {
  name                              = var.application_name
  cluster                           = data.terraform_remote_state.common.outputs.ecs_cluster_name
  desired_count                     = 2
  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = 300
  launch_type                       = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = var.application_name
    container_port   = var.application_port
  }

  propagate_tags = "SERVICE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    assign_public_ip = true
    subnets          = data.terraform_remote_state.common.outputs.public_subnet_ids

    security_groups = [
      data.terraform_remote_state.common.outputs.default_security_group_id
    ]
  }

  task_definition = aws_ecs_task_definition.task_definition.arn

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
    ]
  }
}
