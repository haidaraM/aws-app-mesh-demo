/**
 Required variables
*/
variable "vpc_id" {
  description = "Id of the VPC to use to deploy the services"
  type        = string
}

variable "private_subnets" {
  description = "ID of the public private subnets where to deploy the services"
  type        = set(string)
}


variable "private_ca_arn" {
  description = "ARN of Private Certificate authority"
  type        = string
}

variable "name" {
  description = "Name of the ECS Service"
  type        = string
}

variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

variable "service_discovery_namespace_id" {
  description = "Id of the service discovery private DNS namespace"
  type        = string
}

variable "service_discovery_namespace_name" {
  description = "Name of the service discovery private DNS namespace"
  type        = string
}

variable "ecr_repo_config" {
  description = "Docker image to use for the service"
  type = object({
    url = string
    arn = string
  })
}

variable "prefix" {
  description = "Prefix for all the relevant created resources in this module"
  type        = string
}

variable "mesh_name" {
  description = "Name of the service mesh"
  type        = string
}

variable "alb_config" {
  description = "Configuration related to the load balancer"
  type = object({
    https_listener_arn = string
    security_group_id  = string
  })
}

/**
 Other variables
*/
variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "service_default_port" {
  description = "Port exposed by the service"
  type        = number
  default     = 5000
}

variable "base_path" {
  description = "Base path for the service"
  type        = string
  default     = "/"
}

variable "expose_envoy_admin_port" {
  description = "Flag to expose Envoy admin port to the internal network. Use with caution in a real environment"
  type        = bool
  default     = false
}
