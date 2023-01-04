resource "aws_security_group" "ecs_service" {
  name   = "${var.prefix}-ecs-service"
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.prefix}-ecs-service"
  }
}

resource "aws_security_group_rule" "ecs_ingress_envoy_admin" {
  count             = var.expose_envoy_admin_port ? 1 : 0
  security_group_id = aws_security_group.ecs_service.id
  description       = "From the same VPC to access the Envoy admin interface for debugging purpose"
  from_port         = local.envoy_admin_port
  protocol          = "TCP"
  to_port           = local.envoy_admin_port
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  type              = "ingress"
}

resource "aws_security_group_rule" "ecs_egress_all" {
  security_group_id = aws_security_group.ecs_service.id
  description       = "To the internet"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group_rule" "ecs_ingress_vpc" {
  security_group_id = aws_security_group.ecs_service.id
  description       = "From the same VPC to access the service"
  from_port         = var.service_default_port
  protocol          = "TCP"
  to_port           = var.service_default_port
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  type              = "ingress"
}

resource "aws_security_group_rule" "ecs_ingress_alb" {
  security_group_id        = aws_security_group.ecs_service.id
  description              = "Allow access from the ALB"
  from_port                = var.service_default_port
  protocol                 = "TCP"
  to_port                  = var.service_default_port
  source_security_group_id = var.alb_config.security_group_id
  type                     = "ingress"
}
