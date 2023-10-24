


# IAM Role

resource "aws_iam_role" "role" {
  name = "${ var.ProjectName }-${var.servicename}-${ var.role_name }-${var.environment}"
  assume_role_policy = data.template_file.assume_role_policy.rendered

  tags = {
    Name        = "${ var.ProjectName }-${var.servicename}-${ var.role_name }-${var.environment}"
    ProjectName = var.ProjectName
    environment = var.environment
  }
}

resource "aws_iam_role_policy" "policy" {
  name = "${ var.ProjectName }-${var.servicename}-policy-${var.environment}"
  role = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.permissions.json
}

data "template_file" "assume_role_policy" {
  template = file("${ path.module }/assume_role_policy.json")
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid = ""

    actions = compact(concat([
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "ecr:*",
      "ssm:*",
      "ssmmessages:*",
	  "ecs:ExecuteCommand",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ], var.additional_permissions))

    effect = "Allow"

    resources = compact(concat([

    ],var.resource_arn))
  }
}
