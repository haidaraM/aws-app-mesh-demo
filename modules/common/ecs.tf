resource "aws_ecs_cluster" "cluster" {
  name = var.prefix
}

resource "aws_ecr_repository" "repo" {
  name         = var.prefix
  force_delete = true
}

resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name        = "${var.prefix}.local"
  description = "Namespace for ${var.prefix}"
  vpc         = var.vpc_id
}

