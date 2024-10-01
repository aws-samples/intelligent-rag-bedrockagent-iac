// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


variable "knowledge_base_name" {
  description = "Name of the Bedrock Knowledge Base"
  type        = string
  default     = ""
}

variable "enable_access_logging" {
  description = "Option to enable Access logging of Knowledge base bucket"
  type        = bool
  default     = true
}

variable "enable_s3_lifecycle_policies" {
  description = "Option to enable Lifecycle policies for Knowledge base bucket Objects"
  type        = bool
  default     = true
}

variable "knowledge_base_model_id" {
  description = "The ID of the foundational model used by the knowledge base."
  type        = string
  default     = ""
}

variable "app_name" {
  type    = string
  default = "acme"
}

variable "env_name" {
  type    = string
  default = ""
}


variable "app_region" {
  type    = string
  default = ""
}


variable "agent_model_id" {
  description = "The ID of the foundational model used by the agent."
  type        = string
  default     = ""
}

variable "bedrock_agent_invoke_log_bucket" {
  description = "The Bedrock Agent Name"
  type        = string
  default     = ""
}

variable "agent_name" {
  description = "The Bedrock Agent Name"
  type        = string
  default     = ""
}

variable "agent_alias_name" {
  description = "The Bedrock Agent Alias Name"
  type        = string
  default     = ""
}

variable "agent_action_group_name" {
  description = "The Bedrock Agent Action Group Name"
  type        = string
  default     = ""
}

variable "aoss_collection_name" {
  type        = string
  description = "OpenSearch Collection Name"
  default     = ""
}

variable "aoss_collection_type" {
  type        = string
  description = "OpenSearch Collection Type"
  default     = ""
}

variable "agent_instructions" {
  description = "The type of agent"
  type        = string
  default     = ""
}

variable "agent_description" {
  description = "Description of the agent"
  type        = string
  default     = ""
}

variable "agent_actiongroup_descrption" {
  description = "Description of the action group of the bedrock agent"
  type        = string
  default     = ""
}

variable "kb_instructions_for_agent" {
  description = "Description of the agent"
  type        = string
  default     = ""
}

variable "kms_key_id" {
  type        = string
  description = "Optional ID of the KMS key"
  default     = ""
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "List of Subnet Ids"
  default     = []
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = ""
}

variable "cidr_blocks_sg" {
  type        = list(string)
  description = "VPC/Subnets CIDR blocks to specify in Security Group"
  default     = []
}

variable "code_base_zip" {
  type        = string
  description = "Lambda Code Zip Name in S3 Bucket"
  default     = ""
}

variable "code_base_bucket" {
  type        = string
  description = "Lambda Code Zip Name in S3 Bucket"
  default     = ""
}

# Sample AGent Guardrails values

variable "enable_guardrails" {
  description = "Whether to enable Bedrock guardrails"
  type        = bool
  default     = true
}

variable "guardrail_name" {
  description = "Name of the Bedrock Guardrail"
  type        = string
  default     = ""
}

variable "guardrail_blocked_input_messaging" {
  description = "Blocked input messaging for the Bedrock Guardrail"
  type        = string
  default     = ""
}

variable "guardrail_blocked_outputs_messaging" {
  description = "Blocked outputs messaging for the Bedrock Guardrail"
  type        = string
  default     = ""
}

variable "guardrail_description" {
  description = "Description of the Bedrock Guardrail"
  type        = string
  default     = ""
}

variable "guardrail_content_policy_config" {
  description = "Content policy configuration for the Bedrock Guardrail"
  type        = any
  default     = []
}

variable "guardrail_sensitive_information_policy_config" {
  description = "Sensitive information policy configuration for the Bedrock Guardrail"
  type        = any
  default     = []
}

variable "guardrail_topic_policy_config" {
  description = "Topic policy configuration for the Bedrock Guardrail"
  type        = any
  default     = []
}

variable "guardrail_word_policy_config" {
  description = "Word policy configuration for the Bedrock Guardrail"
  type        = any
  default     = []
}


variable "enable_endpoints" {
  description = "Whether to enable VPC Endpoints"
  type        = bool
  default     = true
}