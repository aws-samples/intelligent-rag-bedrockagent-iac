// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


output "bedrock_agent_arn" {
  value       = aws_bedrockagent_agent.bedrock_agent.agent_arn
  description = "Bedrock Agent ARN"
}

output "bedrock_agent_name" {
  value       = aws_bedrockagent_agent.bedrock_agent.agent_name
  description = "Bedrock Agent Name"
}

output "bedrock_agent_id" {
  value       = aws_bedrockagent_agent.bedrock_agent.agent_id
  description = "Bedrock Agent ID"
}

output "bedrock_agent_action_group_instruction" {
  value       = aws_bedrockagent_agent_knowledge_base_association.bedrock_agent_kb_association.description
  description = "Bedrock Agent Action Group Instruction"
}

output "bedrock_agent_instruction" {
  value       = aws_bedrockagent_agent.bedrock_agent.instruction
  description = "Bedrock Agent  Instruction"
}

output "bedrock_agent_alias_id" {
  value       = aws_bedrockagent_agent_alias.bedrock_agent_alias.agent_alias_id
  description = "Bedrock Agent Alias ID"
}

output "bedrock_agent_actiongroup_lambda_arn" {
  value       = aws_lambda_function.bi_chatbot_container_lambda.arn
  description = "Bedrock Agent Action Group Lambda ARN"
}

output "ssm_parameter_agent_id" {
  value       = aws_ssm_parameter.bedrock_agent_id.name
  description = "SSM Paramater for Bedrock Agent ID"
}

output "ssm_parameter_agent_alias" {
  value       = aws_ssm_parameter.bedrock_agent_alias.name
  description = "SSM Paramater for Bedrock Agent Alias"
}

output "ssm_parameter_agent_arn" {
  value       = aws_ssm_parameter.bedrock_agent_arn.name
  description = "SSM Paramater for Bedrock Agent ARN"
}

output "ssm_parameter_agent_name" {
  value       = aws_ssm_parameter.bedrock_agent_name.name
  description = "SSM Paramater for Bedrock Agent Name"
}

output "ssm_parameter_agent_instruction" {
  value       = aws_ssm_parameter.bedrock_agent_instruction.name
  description = "SSM Paramater for Bedrock Agent Instruction"
}

output "ssm_parameter_agent_ag_instruction" {
  value       = aws_ssm_parameter.bedrock_agent_action_group_instruction.name
  description = "SSM Paramater for Bedrock Agent Action Group Instruction"
}

output "ssm_parameter_agent_ag_lambda_sha" {
  value       = aws_ssm_parameter.action_group_lambda_sha.name
  description = "SSM Paramater for Bedrock Agent Action Group Instruction"
}

output "lambda_function_name" {
  value       = aws_lambda_function.bi_chatbot_container_lambda.function_name
  description = "SSM Paramater for Lambda Function Code SHA"
}

output "ssm_parameter_agent_instruction_history" {
  value       = aws_ssm_parameter.bedrock_agent_instruction_ssm_history.name
  description = "SSM Paramater for Bedrock Agent Instruction History"
}

output "lambda_security_group_id" {
  description = "The ID of the security group created for the Lambda function"
  value       = aws_security_group.lambda_group_lambda.id
}