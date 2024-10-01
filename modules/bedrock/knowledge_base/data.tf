// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


data "aws_caller_identity" "this" {}
data "aws_partition" "this" {}
data "aws_region" "this" {}

data "aws_bedrock_foundation_model" "agent" {
  model_id = var.agent_model_id
}

data "aws_bedrock_foundation_model" "kb" {
  model_id = var.knowledge_base_model_id
}


data "aws_iam_policy_document" "bedrock_sample_kb_oss" {
  statement {
    actions   = ["aoss:APIAccessAll"]
    resources = [var.aoss_collection_arn]
  }
}
