######## Execution role
resource "aws_iam_role" "execution_role" {
  name               = "${var.prefix}-${var.name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_role_policy" "execution_policy" {
  name   = "execution-policy"
  policy = data.aws_iam_policy_document.ecs_execution_policy.json
  role   = aws_iam_role.execution_role.id
}


######## Task role
resource "aws_iam_role" "task_role" {
  name               = "${var.prefix}-${var.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_role_policy" "task_policy" {
  name   = "task-policy"
  policy = data.aws_iam_policy_document.ecs_task_policy.json
  role   = aws_iam_role.task_role.id
}

