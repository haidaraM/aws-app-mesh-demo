/**
 Required variables
*/
variable "vpc_id" {
  description = "Id of the VPC to use to deploy the services"
  type        = string
}

variable "public_subnets" {
  description = "ID of the public subnets where to deploy the load balancer"
  type        = set(string)
}

variable "private_subnets" {
  description = "ID of the public private subnets where to deploy the services"
  type        = set(string)
}

variable "r53_zone_name" {
  description = "Name of the route53 zone to create the ALB record"
  type        = string
}

variable "private_ca_arn" {
  description = "ARN of Private Certificate authority"
  type        = string
}

/**
 Other variables
*/
variable "prefix" {
  description = "Prefix for all the resources"
  type        = string
  default     = "demo-app-mesh"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "default_tags" {
  description = "Default tags to apply to resources"
  type        = map(string)
  default = {
    Application = "Demo End-To-End Encryption with App Mesh"
    Terraform   = "true"
  }
}


variable "allowed_alb_ip_addresses" {
  description = "List of allowed IP addresses to access the ALB"
  type        = set(string)
  default     = ["0.0.0.0/0"]
}

variable "expose_envoy_admin_port" {
  description = "Flag to expose Envoy admin port to the internal network. Use with caution in a real environment"
  type        = bool
  default     = false
}
