
// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


resource "aws_iam_role" "bedrock_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.bedrock_agent_trust.json
  name               = "bedrock-agent-role-${var.app_name}-${var.env_name}"
}

resource "aws_iam_role_policy" "bedrock_iam_policy" {
  policy = data.aws_iam_policy_document.bedrock_agent_permissions.json
  role   = aws_iam_role.bedrock_iam_role.id
  name   = "bedrock-agent-policy-${var.app_name}-${var.env_name}"
}

resource "aws_iam_role" "bedrock_sample_kb_role" {
  name               = "bedrock-kb-role-${var.app_name}-${var.env_name}"
  assume_role_policy = data.aws_iam_policy_document.bedrock_sample_kb_assume_role.json
}


resource "aws_iam_role_policy" "bedrock_sample_kb_model" {
  role   = aws_iam_role.bedrock_sample_kb_role.name
  policy = data.aws_iam_policy_document.bedrock_sample_kb_model.json
  name   = "bedrock-kb-policy-${var.app_name}-${var.env_name}"
}



resource "aws_iam_role_policy" "bedrock_sample_kb_s3" {
  role   = aws_iam_role.bedrock_sample_kb_role.name
  policy = data.aws_iam_policy_document.bedrock_sample_kb_s3.json
}


resource "aws_iam_role" "agent_lambda_role" {
  name               = "bedrock-agent-lambda-role-${var.app_name}-${var.env_name}"
  assume_role_policy = data.aws_iam_policy_document.agent_lambda_role_assume_role_policy.json
}


resource "aws_iam_policy" "agent_lambda_role_policy" {
  description = "Policy for Lambda Execution"
  policy      = data.aws_iam_policy_document.agent_lambda_role_policy.json
  name        = "bedrock-agent-lambda-policy-${var.app_name}-${var.env_name}"
}

resource "aws_iam_role_policy_attachment" "agent_lambda_role_policy_attachment" {
  role       = aws_iam_role.agent_lambda_role.name
  policy_arn = aws_iam_policy.agent_lambda_role_policy.arn
}

resource "aws_iam_policy" "agent_lambda_invoke_policy" {
  description = "Policy for Lambda Execution"
  policy      = data.aws_iam_policy_document.bedrock_agent_permissions.json
  name        = "bedrock-agent-lambda-invoke-policy${var.app_name}-${var.env_name}"
}

resource "aws_iam_role_policy_attachment" "bedrock_agent_permissions_attachment" {
  role       = aws_iam_role.agent_lambda_role.name
  policy_arn = aws_iam_policy.agent_lambda_invoke_policy.arn
}

resource "aws_iam_policy" "agent_lambda_s3_data_policy" {
  description = "Policy for Access to Data Objects in S3"
  policy      = data.aws_iam_policy_document.agent_lambda_s3_policy.json
  name        = "bedrock-agent-lambda-s3-policy${var.app_name}-${var.env_name}"
}

resource "aws_iam_role_policy_attachment" "agent_lambda_s3_data_policy_attachment" {
  role       = aws_iam_role.agent_lambda_role.name
  policy_arn = aws_iam_policy.agent_lambda_s3_data_policy.arn
}


resource "aws_iam_role_policy_attachment" "lamba_exec_role_eni" {
  role       = aws_iam_role.agent_lambda_role.name
  policy_arn = data.aws_iam_policy.lambda_vpc_access_execution_role.arn
}

resource "aws_iam_role_policy" "bedrock_logging_policy" {
  name   = "bedrock-agent-invoke-role-policy"
  role   = aws_iam_role.bedrock_logging_role.id
  policy = data.aws_iam_policy_document.bedrock_logging_policy.json
}


resource "aws_iam_role" "bedrock_logging_role" {
  assume_role_policy = data.aws_iam_policy_document.bedrock_assume_role.json
  name               = "bedrock-agent-invoke-role-${var.app_name}-${var.env_name}"
}