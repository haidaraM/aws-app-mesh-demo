output "alb_endpoint" {
  description = "Load balancer endpoint"
  value       = module.common_resources.alb_endpoint
}

output "ecr_repo_url" {
  description = "ECR repository URL"
  value       = module.common_resources.ecr_repo_url
}

output "logs" {
  description = "App and proxy logs"
  value = {
    app   = module.ecs_service_alpha.app_log_group
    proxy = module.ecs_service_alpha.proxy_log_group
  }
}

