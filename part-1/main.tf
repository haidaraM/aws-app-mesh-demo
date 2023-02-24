module "common_resources" {
  source = "../modules/common"
  providers = {
    aws.route53 = aws.route53
  }
  prefix                   = var.prefix
  public_subnets           = var.public_subnets
  r53_zone_name            = var.r53_zone_name
  vpc_id                   = var.vpc_id
  allowed_alb_ip_addresses = var.allowed_alb_ip_addresses
}


module "ecs_service_alpha" {
  source                           = "../modules/ecs-meshed-service"
  name                             = "alpha"
  mesh_name                        = module.common_resources.mesh_name
  prefix                           = var.prefix
  vpc_id                           = var.vpc_id
  private_subnets                  = var.private_subnets
  private_ca_arn                   = var.private_ca_arn
  cluster_name                     = module.common_resources.ecs_cluster_name
  service_discovery_namespace_id   = module.common_resources.service_discovery_namespace_id
  service_discovery_namespace_name = module.common_resources.service_discovery_namespace_name
  expose_envoy_admin_port          = var.expose_envoy_admin_port
  ecr_repo_config = {
    url = "${module.common_resources.ecr_repo_url}:latest"
    arn = module.common_resources.ecr_repo_arn
  }
  alb_config = {
    https_listener_arn = module.common_resources.alb_https_listener_arn
    security_group_id  = module.common_resources.alb_security_group_id
  }
}
