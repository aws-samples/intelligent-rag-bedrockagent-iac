// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


output "bedrock_agent_role_name" {
  value       = aws_iam_role.bedrock_iam_role.name
  description = "Bedrock Agent Role Name"
}

output "bedrock_agent_role_arn" {
  value       = aws_iam_role.bedrock_iam_role.arn
  description = "Bedrock Agent Role ARN"
}

output "knowledge_base_role_name" {
  value       = aws_iam_role.bedrock_sample_kb_role.name
  description = "Knowleddge Base Role Name"
}

output "knowledge_base_role_arn" {
  value       = aws_iam_role.bedrock_sample_kb_role.arn
  description = "Knowleddge Base Role ARN"
}


output "bedrock_agent_lambda_role_name" {
  value       = aws_iam_role.agent_lambda_role.name
  description = "Bedrock Agent Role Name"
}

output "bedrock_agent_lambda_role_arn" {
  value       = aws_iam_role.agent_lambda_role.arn
  description = "Bedrock Agent Role ARN"
}

output "bedrock_agent_invoke_log_group_role_arn" {
  value       = aws_iam_role.bedrock_logging_role.arn
  description = "Bedrock Agent Logging Role ARN"
}