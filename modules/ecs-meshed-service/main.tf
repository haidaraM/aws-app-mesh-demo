locals {
  envoy_side_car_uuid  = "1337"
  envoy_admin_port     = "9901"
  envoy_container_name = "envoy"
}

resource "aws_service_discovery_service" "service_discovery" {
  name          = var.name
  description   = "Service discovery for the service ${var.name} in the cluster ${var.cluster_name}"
  force_destroy = true

  dns_config {
    namespace_id   = var.service_discovery_namespace_id
    routing_policy = "MULTIVALUE"
    # TODO: check these parameters later
    dns_records {
      ttl  = 60
      type = "A"
    }

    dns_records {
      ttl  = 60
      type = "SRV"
    }
  }

  health_check_custom_config {
    failure_threshold = 3
  }
}

resource "aws_ecs_service" "this" {
  cluster               = var.cluster_name
  name                  = var.name
  task_definition       = "${aws_ecs_task_definition.task_definition.family}:${aws_ecs_task_definition.task_definition.revision}"
  desired_count         = 1
  launch_type           = "FARGATE"
  platform_version      = "LATEST"
  wait_for_steady_state = false

  service_registries {
    registry_arn = aws_service_discovery_service.service_discovery.arn
    port         = var.service_default_port
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.target_group.arn
    container_name   = var.name
    container_port   = var.service_default_port
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = false
    subnets          = var.private_subnets
  }

  deployment_controller {
    type = "ECS" # rolling update
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  depends_on = [aws_lb_listener_rule.ecs_services_listener]
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.prefix}-${var.name}"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"

  proxy_configuration {
    type           = "APPMESH"
    container_name = local.envoy_container_name
    properties = {
      AppPorts         = var.service_default_port
      EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
      IgnoredUID       = local.envoy_side_car_uuid
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }

  container_definitions = jsonencode([
    {
      name : var.name,
      image : var.ecr_repo_config.url,
      essential : true,
      stopTimeout : 5,
      dependsOn : [
        {
          "containerName" : local.envoy_container_name,
          "condition" : "HEALTHY"
        }
      ]
      environment : [
        {
          "name" : "FLASK_RUN_PORT",
          "value" : tostring(var.service_default_port)
        },
        {
          "name" : "WHO_AM_I",
          "value" : var.name
        },
        {
          "name" : "BASE_PATH",
          "value" : var.base_path
        }
      ],
      logConfiguration : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.service.name,
          "awslogs-region" : var.aws_region,
          "awslogs-stream-prefix" : "logs"
        }
      },
      portMappings : [
        {
          containerPort : var.service_default_port,
          protocol : "tcp"
        }
      ]
    },
    {
      name : local.envoy_container_name,
      # https://docs.aws.amazon.com/app-mesh/latest/userguide/envoy.html
      image : "public.ecr.aws/appmesh/aws-appmesh-envoy:v1.24.1.0-prod",
      user : local.envoy_side_car_uuid,
      essential : true,
      healthCheck : {
        "retries" : 3,
        "command" : [
          "CMD-SHELL",
          "curl -s http://localhost:${local.envoy_admin_port}/server_info | grep state | grep -q LIVE"
        ],
        "timeout" : 2,
        "interval" : 15,
        "startPeriod" : 10
      },
      logConfiguration : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.envoy_log.name,
          "awslogs-region" : var.aws_region,
          "awslogs-stream-prefix" : "logs"
        }
      }
      environment : [
        {
          "name" : "APPMESH_RESOURCE_ARN",
          "value" : aws_appmesh_virtual_node.node.arn
        },
        {
          "name" : "ENVOY_LOG_LEVEL",
          "value" : "info"
        }
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "service" {
  name              = "${var.prefix}-${var.name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "envoy_log" {
  name              = "${var.prefix}-envoy-${var.name}"
  retention_in_days = 7
}


