
// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


variable "env_name" {
  description = "Environment Name"
  type        = string
}

variable "app_name" {
  description = "Application Name"
  type        = string
}

variable "knowledge_base_arn" {
  description = "Knowledge Base ARN"
  type        = string
}


variable "agent_model_id" {
  description = "Bedrock Agent Model ID"
  type        = string
}


variable "knowledge_base_model_id" {
  description = "Bedrock Knowledge Base Model ID"
  type        = string
}

variable "knowledge_base_bucket_arn" {
  description = "Bedrock Knowledge Base Bucket ARN"
  type        = string
}

variable "kms_key_id" {
  description = "KMS Key ARN"
  type        = string
}

variable "bedrock_agent_invoke_log_group_name" {
  description = "Bedrock Agent Log Group Name"
  type        = string
}
