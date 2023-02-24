output "alb_https_listener_arn" {
  description = "ALB HTTPs listener ARN"
  value       = aws_lb_listener.https.arn
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}


output "service_discovery_namespace_id" {
  description = "ID of the service discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.namespace.id
}

output "service_discovery_namespace_name" {
  description = "Name of the service discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.namespace.name
}

output "ecs_cluster_name" {
  description = "Cluster name"
  value       = aws_ecs_cluster.cluster.name
}

output "ecr_repo_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.repo.repository_url
}

output "ecr_repo_arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.repo.arn
}


output "alb_endpoint" {
  description = "Load balancer endpoint"
  value       = "https://${aws_route53_record.alb_record.fqdn}"
}

output "mesh_name" {
  description = "Name of the service mesh"
  value       = aws_appmesh_mesh.the_mesh.name
}
