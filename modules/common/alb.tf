resource "aws_alb" "app" {
  name               = var.prefix
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_acm_certificate" "alb_cert" {
  domain_name       = "${var.prefix}.${var.r53_zone_name}"
  validation_method = "DNS"
  tags              = { Name = "${var.prefix}.${var.r53_zone_name}" }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_alb.app.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = aws_acm_certificate.alb_cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      status_code  = "200"
      message_body = "<h1> Load Balancer accessible. Try to access the services! </h1>"
    }
  }
}

resource "aws_lb_listener" "ttp_redirect" {
  load_balancer_arn = aws_alb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      host        = aws_acm_certificate.alb_cert.domain_name
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_route53_record" "alb_cert_validation_record" {
  name    = tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.zone_id
  records = [tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_value]
  ttl     = "60"
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [aws_route53_record.alb_cert_validation_record.fqdn]
}

resource "aws_route53_record" "alb_record" {
  provider = aws.route53
  zone_id  = data.aws_route53_zone.zone.id
  name     = aws_acm_certificate.alb_cert.domain_name
  type     = "A"

  alias {
    name                   = aws_alb.app.dns_name
    evaluate_target_health = false
    zone_id                = aws_alb.app.zone_id
  }
}


resource "aws_security_group" "alb" {
  name        = "${var.prefix}-alb"
  vpc_id      = var.vpc_id
  description = "Security group for the ALB used in the project ${var.prefix}"
  tags = {
    Name = "${var.prefix}-alb"
  }
}


resource "aws_security_group_rule" "alb_egress_vpc" {
  security_group_id = aws_security_group.alb.id
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  type              = "egress"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "alb_ingress_https" {
  security_group_id = aws_security_group.alb.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = var.allowed_alb_ip_addresses
}

resource "aws_security_group_rule" "alb_ingress_http" {
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = var.allowed_alb_ip_addresses
}
