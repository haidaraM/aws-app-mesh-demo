terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4"
      configuration_aliases = [aws.route53]
    }
  }
}
