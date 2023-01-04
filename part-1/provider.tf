terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = var.default_tags
  }
}

/**
 In case your Route53 zone are defined in another account, update this provider to target this account instead.
 By default, everything is defined in a single account
*/
provider "aws" {
  alias = "route53"

  default_tags {
    tags = var.default_tags
  }
}