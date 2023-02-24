data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    sid     = "AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "ecs_task_policy" {

  statement {
    sid    = "AccessToAppMesh"
    effect = "Allow"
    actions = [
      "appmesh:StreamAggregatedResources"
    ]
    resources = [aws_appmesh_virtual_node.node.arn]
  }

  statement {
    sid       = "AccessToACM"
    effect    = "Allow"
    actions   = ["acm:ExportCertificate"]
    resources = [aws_acm_certificate.virtual_node_cert.arn]
  }
}

data "aws_iam_policy_document" "ecs_execution_policy" {

  statement {
    sid    = "AccessToCloudwatch"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "GetTheImageFromECR"
    effect    = "Allow"
    resources = [var.ecr_repo_config.arn]
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
  }

  statement {
    sid       = "ECRAuthorization"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

