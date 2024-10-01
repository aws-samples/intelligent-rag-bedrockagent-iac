// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


variable "agent_name" {
  description = "The Bedrock Agent Name"
  type        = string
}

variable "agent_alias_name" {
  description = "The Bedrock Agent Alias Name"
  type        = string
}

variable "prepare_agent" {
  description = "The Bedrock Agent Alias Name"
  type        = bool
  default     = true
}


variable "agent_action_group_name" {
  description = "The Bedrock Agent Action Group Name"
  type        = string
}

variable "agent_model_id" {
  description = "The ID of the foundational model used by the agent."
  type        = string
}

variable "agent_role_arn" {
  description = "The Bedrock Agent Role ARN"
  type        = string
}

variable "agent_lambda_role_arn" {
  description = "The Bedrock Agent Lambda Role ARN"
  type        = string
}


variable "env_name" {
  description = "Environment Name"
  type        = string
}

variable "app_name" {
  description = "Application Name"
  type        = string
}

variable "knowledge_base_id" {
  description = "Bedrock Knowledge Base ID"
  type        = string
}

variable "knowledge_base_bucket" {
  description = "Bedrock Knowledge Base Bucket"
  type        = string
}

variable "code_base_bucket" {
  description = "Bedrock Knowledge Base Bucket"
  type        = string
}


variable "knowledge_base_arn" {
  description = "Bedrock Knowledge Base ARN"
  type        = string
}

variable "generate_fields" {
  description = "Which parts of the json should be compared for accuracy, separated by spaces"
  type        = string
  default     = "id fiscal lifeToDate from to from1 to1 trend compare pivot1 pivot2 pivot3 pivot4 pivot5 pivot6 pivot7 pivot8 pivot9 pivot10 pivot11 pivot12 filters sorts"
}

variable "agent_instructions" {
  description = "Instructions for the agent"
  type        = string
}

variable "agent_description" {
  description = "Description of the agent"
  type        = string
}

variable "agent_actiongroup_descrption" {
  description = "Description of the agent"
  type        = string
}

variable "kb_instructions_for_agent" {
  description = "Description of the agent"
  type        = string
}

variable "cloudwatch_log_group_retention" {
  description = "Lambda CLoudWatch logs retention days"
  type        = number
  default     = 365
}


variable "vpc_subnet_ids" {
  description = "VPC Subnets List"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cidr_blocks_sg" {
  description = "VPC CIDR Blocks for SG"
  type        = list(string)
}


variable "kms_key_id" {
  description = "KMS Key ID"
  type        = string
}

variable "provisioned_concurrent_executions" {
  description = "Lambda Concurrency executions"
  type        = number
  default     = 3
}

variable "code_base_zip" {
  type        = string
  description = "Lambda Code Zip Name in S3 Bucket"
}

variable "bedrock_agent_invoke_log_group_name" {
  type        = string
  description = "Agent CW Log group Name"
}


variable "bedrock_agent_invoke_log_group_arn" {
  type        = string
  description = "Agent CW Log group ARNt"
}