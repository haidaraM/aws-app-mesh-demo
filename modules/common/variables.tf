variable "prefix" {
  description = "Prefix for all the resources"
  type        = string
}

variable "vpc_id" {
  description = "Id of the VPC to use to deploy the services"
  type        = string
}

variable "allowed_alb_ip_addresses" {
  description = "List of allowed IP addresses to access the ALB"
  type        = set(string)
}

variable "public_subnets" {
  description = "ID of the public subnets where to deploy the load balancer"
  type        = set(string)
}

variable "r53_zone_name" {
  description = "Name of the route53 zone to create the ALB record"
  type        = string
}
