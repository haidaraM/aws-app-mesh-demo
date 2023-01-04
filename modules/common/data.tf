data "aws_vpc" "vpc" {
  id = var.vpc_id
}


data "aws_route53_zone" "zone" {
  name         = var.r53_zone_name
  private_zone = false
}
