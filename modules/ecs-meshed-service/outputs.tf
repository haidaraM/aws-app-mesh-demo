output "force_deployment" {
  description = "Command to force a deployment of the service"
  value       = "aws ecs update-service --cluster ${aws_ecs_service.this.cluster} --force-new-deployment --service ${aws_ecs_service.this.name}"
}

output "proxy_log_group" {
  description = "Log group for Envoy proxy"
  value       = aws_cloudwatch_log_group.envoy_log.name
}

output "app_log_group" {
  description = "Log group for the app"
  value       = aws_cloudwatch_log_group.service.name
}
