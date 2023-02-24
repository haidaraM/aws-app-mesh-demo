# Part 1

Full article on: https://blog.haidara.io/post/aws-app-mesh-partie-1-terminaison-tls/

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_resources"></a> [common\_resources](#module\_common\_resources) | ../modules/common | n/a |
| <a name="module_ecs_service_alpha"></a> [ecs\_service\_alpha](#module\_ecs\_service\_alpha) | ../modules/ecs-meshed-service | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_alb_ip_addresses"></a> [allowed\_alb\_ip\_addresses](#input\_allowed\_alb\_ip\_addresses) | List of allowed IP addresses to access the ALB | `set(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to apply to resources | `map(string)` | <pre>{<br>  "Application": "Demo End-To-End Encryption with App Mesh",<br>  "Terraform": "true"<br>}</pre> | no |
| <a name="input_expose_envoy_admin_port"></a> [expose\_envoy\_admin\_port](#input\_expose\_envoy\_admin\_port) | Flag to expose Envoy admin port to the internal network. Use with caution in a real environment | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for all the resources | `string` | `"demo-app-mesh"` | no |
| <a name="input_private_ca_arn"></a> [private\_ca\_arn](#input\_private\_ca\_arn) | ARN of Private Certificate authority | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | ID of the public private subnets where to deploy the services | `set(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | ID of the public subnets where to deploy the load balancer | `set(string)` | n/a | yes |
| <a name="input_r53_zone_name"></a> [r53\_zone\_name](#input\_r53\_zone\_name) | Name of the route53 zone to create the ALB record | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-1"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Id of the VPC to use to deploy the services | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_endpoint"></a> [alb\_endpoint](#output\_alb\_endpoint) | Load balancer endpoint |
| <a name="output_ecr_repo_url"></a> [ecr\_repo\_url](#output\_ecr\_repo\_url) | ECR repository URL |
| <a name="output_logs"></a> [logs](#output\_logs) | App and proxy logs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->