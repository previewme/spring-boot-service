resource "aws_lb_target_group" "blue" {
  name                 = trimsuffix(substr(format("blue-tg-%s", var.application_name), 0, 32), "-")
  port                 = var.application_port
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.terraform_remote_state.common.outputs.vpc_id
  deregistration_delay = 60

  health_check {
    path     = "/actuator/health"
    matcher  = "200"
    interval = 10
    timeout  = 2
  }
}

resource "aws_lb_target_group" "green" {
  name                 = trimsuffix(substr(format("green-tg-%s", var.application_name), 0, 32), "-")
  port                 = var.application_port
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.terraform_remote_state.common.outputs.vpc_id
  deregistration_delay = 60

  health_check {
    path     = "/actuator/health"
    matcher  = "200"
    interval = 10
    timeout  = 2
  }
}

resource "aws_lb_listener_rule" "application_rule" {
  listener_arn = data.terraform_remote_state.common.outputs.public_lb_https_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  condition {
    host_header {
      values = [
        data.terraform_remote_state.common.outputs.cloudfront_api_domain
      ]
    }
  }

  condition {
    path_pattern {
      values = [
        var.application_path
      ]
    }
  }

  lifecycle {
    ignore_changes = [
      action.0.target_group_arn
    ]
  }
}