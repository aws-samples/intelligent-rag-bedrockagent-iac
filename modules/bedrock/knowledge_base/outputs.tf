// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


output "knowledge_base_arn" {
  value       = aws_bedrockagent_knowledge_base.sample_kb.arn
  description = "Knowleddge Base Name"
}


output "knowledge_base_id" {
  value       = aws_bedrockagent_knowledge_base.sample_kb.id
  description = "Knowleddge Base ID"
}

output "knowledge_base_data_source_id" {
  value       = aws_bedrockagent_data_source.data_source.id
  description = "Knowleddge Base Data Source ID"
}


output "knowledge_base_name" {
  value       = aws_bedrockagent_knowledge_base.sample_kb.name
  description = "Knowleddge Base Name"
}

output "ssm_parameter_knowledge_base_id" {
  value       = aws_ssm_parameter.knowledge_base_id.name
  description = "SSM Paramater for Knowledge Base ID"
}


output "ssm_parameter_knowledge_base_data_source_id" {
  value       = aws_ssm_parameter.knowledge_base_data_source_id.name
  description = "SSM Paramater for Knowledge Base Data Source ID"
}

output "ssm_parameter_kb_instruction_history" {
  value       = aws_ssm_parameter.bedrock_agent_instruction_ssm_history.name
  description = "SSM Paramater for Knowledge Base Instruction History"
}