output "appspec_file" {
  sensitive = true

  value = jsonencode({
    "version" = "0.0"

    "Resources" = [
      {
        TargetService = {
          Type = "AWS::ECS::Service"

          Properties = {
            TaskDefinition = aws_ecs_task_definition.task_definition.arn

            LoadBalancerInfo = {
              ContainerName = var.application_name
              ContainerPort = var.application_port
            }

            "PlatformVersion" = "LATEST"
          }
        }
      }
    ]
  })
}

output "codedeploy_application_name" {
  value = aws_codedeploy_app.application.name
}

output "codedeploy_deployment_group" {
  value = aws_codedeploy_deployment_group.blue_green.deployment_group_name
}

output "ecs_cluster_name" {
  value = data.terraform_remote_state.common.outputs.ecs_cluster_name
}

output "service_name" {
  value = aws_ecs_service.application.name
}

output "task_definition_file" {
  sensitive = true

  value = jsonencode({
    "containerDefinitions" = jsondecode(aws_ecs_task_definition.task_definition.container_definitions)
    "cpu"                  = aws_ecs_task_definition.task_definition.cpu
    "memory"               = aws_ecs_task_definition.task_definition.memory
    "executionRoleArn"     = aws_ecs_task_definition.task_definition.execution_role_arn
    "family"               = aws_ecs_task_definition.task_definition.family
    "networkMode"          = aws_ecs_task_definition.task_definition.network_mode
    "taskRoleArn"          = aws_ecs_task_definition.task_definition.task_role_arn
    "proxyConfiguration"   = null
  })
}