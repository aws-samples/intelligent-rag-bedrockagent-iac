// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


resource "aws_iam_role_policy" "bedrock_sample_kb_oss" {
  role   = var.knowledge_base_role
  policy = data.aws_iam_policy_document.bedrock_sample_kb_oss.json
}