// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


resource "aws_ssm_parameter" "bedrock_agent_id" {
  name        = "${var.agent_name}-id"
  description = "Bedrock Agent ID"
  type        = "SecureString"
  value       = aws_bedrockagent_agent.bedrock_agent.agent_id
  key_id      = var.kms_key_id
  depends_on  = [aws_bedrockagent_agent_alias.bedrock_agent_alias]
}

resource "aws_ssm_parameter" "bedrock_agent_name" {
  name        = "${var.agent_name}-name"
  description = "Bedrock Agent Name"
  type        = "SecureString"
  value       = aws_bedrockagent_agent.bedrock_agent.agent_name
  key_id      = var.kms_key_id
  depends_on  = [aws_bedrockagent_agent_alias.bedrock_agent_alias]
}

resource "aws_ssm_parameter" "bedrock_agent_alias" {
  name        = "${var.agent_name}-alias"
  description = "Bedrock Agent Alias"
  type        = "SecureString"
  value       = aws_bedrockagent_agent_alias.bedrock_agent_alias.agent_alias_id
  key_id      = var.kms_key_id
  depends_on  = [aws_bedrockagent_agent_alias.bedrock_agent_alias]
}


resource "aws_ssm_parameter" "bedrock_agent_arn" {
  name        = "${var.agent_name}-arn"
  description = "Bedrock Agent ARN"
  type        = "SecureString"
  value       = aws_bedrockagent_agent.bedrock_agent.agent_arn
  key_id      = var.kms_key_id
  depends_on  = [aws_bedrockagent_agent_alias.bedrock_agent_alias]
}

resource "aws_ssm_parameter" "bedrock_agent_instruction" {
  name        = "${var.agent_name}-agent-instruction"
  description = "Bedrock Agent Instruction"
  type        = "SecureString"
  value       = aws_bedrockagent_agent.bedrock_agent.instruction
  key_id      = var.kms_key_id
  depends_on  = [aws_bedrockagent_agent_alias.bedrock_agent_alias]
}

resource "aws_ssm_parameter" "bedrock_agent_action_group_instruction" {
  name        = "${var.agent_name}-agent-kb-instruction"
  description = "Bedrock Agent KB Instruction"
  type        = "SecureString"
  value       = aws_bedrockagent_agent_knowledge_base_association.bedrock_agent_kb_association.description
  key_id      = var.kms_key_id
  depends_on  = [aws_bedrockagent_agent_alias.bedrock_agent_alias]
}


resource "aws_ssm_parameter" "action_group_lambda_sha" {
  name        = "${var.agent_name}-ag-lambda-sha"
  description = "Bedrock Agent KB Lambda Code SHA"
  type        = "SecureString"
  value       = data.aws_lambda_function.existing.code_sha256
  key_id      = var.kms_key_id
  depends_on  = [aws_bedrockagent_agent_alias.bedrock_agent_alias]
}

resource "aws_ssm_parameter" "bedrock_agent_instruction_ssm_history" {
  name        = "${var.agent_name}-last-processed-version"
  description = "Bedrock Agent Instructions SSM History"
  type        = "SecureString"
  value       = "initial"
  key_id      = var.kms_key_id
  depends_on  = [aws_bedrockagent_agent_alias.bedrock_agent_alias]

  lifecycle {
    ignore_changes = [value]
  }
}