resource "aws_alb_target_group" "target_group" {
  name                 = "${var.prefix}-${var.name}"
  port                 = var.service_default_port
  target_type          = "ip"
  protocol             = "HTTPS"
  vpc_id               = var.vpc_id
  deregistration_delay = 5
  slow_start           = 30

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 5
    path                = "/healthcheck"
    interval            = 20
    timeout             = 3
    protocol            = "HTTPS"
  }

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }
}


resource "aws_lb_listener_rule" "ecs_services_listener" {
  listener_arn = var.alb_config.https_listener_arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = ["${var.base_path}*"]
    }
  }

  lifecycle {
    # In case the target group is replaced, we need to destroy the listener group first
    # TODO: add the attributes forcing the destroy
    replace_triggered_by = [aws_alb_target_group.target_group]
  }
}
