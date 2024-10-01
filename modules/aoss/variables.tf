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

variable "aoss_collection_name" {
  description = "The name of the OSS collection for the knowledge base."
  type        = string
}


variable "aoss_collection_type" {
  description = "The ID of the foundational model used by the knowledge base."
  type        = string
}

variable "knowledge_base_role_arn" {
  description = "Bedrock Knowledge Base Role ARN"
  type        = string
}

variable "kms_key_id" {
  description = "KMS Key ID"
  type        = string
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "List of Subnet Ids"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}