// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


variable "knowledge_base_name" {
  description = "The knowledge base name."
  type        = string
}

variable "aoss_collection_arn" {
  description = "The AOSS collection ARN"
  type        = string
}

variable "knowledge_base_role" {
  description = "The Knowledge Base Role Name"
  type        = string
}

variable "knowledge_base_role_arn" {
  description = "The Knowledge Base IAM Role"
  type        = string
}


variable "knowledge_base_bucket_arn" {
  description = "The knowledge Base Bucket ARN"
  type        = string
}

variable "knowledge_base_model_id" {
  description = "The knowledge Base model ID."
  type        = string
}

variable "agent_model_id" {
  description = "The ID of the foundational model used by the agent."
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

variable "kms_key_id" {
  type        = string
  description = "Optional ID of the KMS key"
  default     = null
}