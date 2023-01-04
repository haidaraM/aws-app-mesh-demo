# ECS Meshed Service

This module create an ECS service designed to be deployed inside App Mesh with TLS enabled.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.virtual_node_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_alb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_appmesh_virtual_node.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appmesh_virtual_node) | resource |
| [aws_cloudwatch_log_group.envoy_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lb_listener_rule.ecs_services_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_security_group.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ecs_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_ingress_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_ingress_envoy_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_ingress_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_service_discovery_service.service_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_iam_policy_document.ecs_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_config"></a> [alb\_config](#input\_alb\_config) | Configuration related to the load balancer | <pre>object({<br>    https_listener_arn = string<br>    security_group_id  = string<br>  })</pre> | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"eu-west-1"` | no |
| <a name="input_base_path"></a> [base\_path](#input\_base\_path) | Base path for the service | `string` | `"/"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ECS Cluster name | `string` | n/a | yes |
| <a name="input_ecr_repo_config"></a> [ecr\_repo\_config](#input\_ecr\_repo\_config) | Docker image to use for the service | <pre>object({<br>    url = string<br>    arn = string<br>  })</pre> | n/a | yes |
| <a name="input_expose_envoy_admin_port"></a> [expose\_envoy\_admin\_port](#input\_expose\_envoy\_admin\_port) | Flag to expose Envoy admin port to the internal network. Use with caution in a real environment | `bool` | `false` | no |
| <a name="input_mesh_name"></a> [mesh\_name](#input\_mesh\_name) | Name of the service mesh | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the ECS Service | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for all the relevant created resources in this module | `string` | n/a | yes |
| <a name="input_private_ca_arn"></a> [private\_ca\_arn](#input\_private\_ca\_arn) | ARN of Private Certificate authority | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | ID of the public private subnets where to deploy the services | `set(string)` | n/a | yes |
| <a name="input_service_default_port"></a> [service\_default\_port](#input\_service\_default\_port) | Port exposed by the service | `number` | `5000` | no |
| <a name="input_service_discovery_namespace_id"></a> [service\_discovery\_namespace\_id](#input\_service\_discovery\_namespace\_id) | Id of the service discovery private DNS namespace | `string` | n/a | yes |
| <a name="input_service_discovery_namespace_name"></a> [service\_discovery\_namespace\_name](#input\_service\_discovery\_namespace\_name) | Name of the service discovery private DNS namespace | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Id of the VPC to use to deploy the services | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_log_group"></a> [app\_log\_group](#output\_app\_log\_group) | Log group for the app |
| <a name="output_force_deployment"></a> [force\_deployment](#output\_force\_deployment) | Command to force a deployment of the service |
| <a name="output_proxy_log_group"></a> [proxy\_log\_group](#output\_proxy\_log\_group) | Log group for Envoy proxy |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->