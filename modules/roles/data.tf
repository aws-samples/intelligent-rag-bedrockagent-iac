
// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

data "aws_caller_identity" "this" {}
data "aws_partition" "this" {}
data "aws_region" "this" {}

data "aws_iam_policy_document" "bedrock_agent_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["bedrock.amazonaws.com"]
      type        = "Service"
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.this.account_id]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:${data.aws_partition.this.partition}:bedrock:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:agent/*"]
      variable = "AWS:SourceArn"
    }
  }
}


data "aws_iam_policy_document" "bedrock_agent_permissions" {
  statement {
    actions = ["bedrock:InvokeModel"]
    resources = [
      "arn:${data.aws_partition.this.partition}:bedrock:${data.aws_region.this.name}::foundation-model/anthropic.claude-3-haiku-20240307-v1:0",
      "arn:${data.aws_partition.this.partition}:bedrock:${data.aws_region.this.name}::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
    ]
  }
  statement {
    actions = ["bedrock:Retrieve"]
    resources = [
      var.knowledge_base_arn
    ]
  }

  statement {
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [
      var.kms_key_id
    ]
  }

}


data "aws_bedrock_foundation_model" "agent" {
  model_id = var.agent_model_id
}

data "aws_bedrock_foundation_model" "kb" {
  model_id = var.knowledge_base_model_id
}

data "aws_iam_policy_document" "bedrock_sample_kb_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:${local.partition}:bedrock:${local.region}:${local.account_id}:knowledge-base/*"]
    }
  }
}

data "aws_iam_policy_document" "bedrock_sample_kb_model" {
  statement {
    actions   = ["bedrock:InvokeModel"]
    resources = [data.aws_bedrock_foundation_model.kb.model_arn]
  }
}

data "aws_iam_policy_document" "bedrock_sample_kb_s3" {
  statement {
    sid       = "S3ListBucketStatement"
    actions   = ["s3:ListBucket"]
    resources = [var.knowledge_base_bucket_arn]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalAccount"
      values   = [local.account_id]
    }
  }
  statement {
    sid       = "S3GetObjectStatement"
    actions   = ["s3:GetObject"]
    resources = ["${var.knowledge_base_bucket_arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalAccount"
      values   = [local.account_id]
    }
  }

  statement {
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [
      var.kms_key_id
    ]
  }

}


data "aws_iam_policy_document" "agent_lambda_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/bi-chatbot-container-lambda-${var.app_name}-${var.env_name}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = ["arn:aws:sqs:${local.region}:${local.account_id}:bi-chatbot-container-lambda-dlq-${var.app_name}-${var.env_name}"]
  }

  statement {
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [
      var.kms_key_id
    ]
  }

}


data "aws_iam_policy_document" "agent_lambda_s3_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "${var.knowledge_base_bucket_arn}/*",
    ]
  }

  statement {
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [
      var.kms_key_id
    ]
  }

}

data "aws_iam_policy_document" "agent_lambda_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "lambda_vpc_access_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy_document" "bedrock_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "bedrock_logging_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:${var.bedrock_agent_invoke_log_group_name}:*"
    ]
  }
}