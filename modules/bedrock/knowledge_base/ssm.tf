// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


resource "aws_ssm_parameter" "knowledge_base_id" {
  name        = "${var.knowledge_base_name}-kb-id"
  description = "Bedrock Knowledge Base ID"
  type        = "SecureString"
  value       = aws_bedrockagent_knowledge_base.sample_kb.id
  key_id      = var.kms_key_id
}


resource "aws_ssm_parameter" "knowledge_base_data_source_id" {
  name        = "${var.knowledge_base_name}-datasource-id"
  description = "Bedrock Knowledge Base Data Source ID"
  type        = "SecureString"
  value       = aws_bedrockagent_data_source.data_source.id
  key_id      = var.kms_key_id
}

resource "aws_ssm_parameter" "bedrock_agent_instruction_ssm_history" {
  name        = "${var.knowledge_base_name}-last-processed-version"
  description = "Bedrock Knowledge Base instructions SSM History"
  type        = "SecureString"
  value       = "initial"
  key_id      = var.kms_key_id

  lifecycle {
    ignore_changes = [value]
  }
}