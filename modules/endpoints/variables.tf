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

variable "vpc_id" {
  description = "The ID of the VPC where endpoints will be created"
  type        = string
}

variable "cidr_blocks_sg" {
  description = "VPC CIDR Blocks for SG"
  type        = list(string)
}

variable "vpc_subnet_ids" {
  description = "List of subnet IDs for Interface endpoints"
  type        = list(string)
}

variable "enable_cloudwatch_endpoint" {
  description = "Enable CloudWatch VPC endpoint"
  type        = bool
}

variable "enable_kms_endpoint" {
  description = "Enable KMS VPC endpoint"
  type        = bool
}

variable "enable_ssm_endpoint" {
  description = "Enable SSM VPC endpoint"
  type        = bool
}

variable "enable_s3_endpoint" {
  description = "Enable S3 VPC endpoint"
  type        = bool
}

variable "enable_sqs_endpoint" {
  description = "Enable SQS VPC endpoint"
  type        = bool
}

variable "lambda_security_group_id" {
  description = "Lambda Security Group ID"
  type        = string
}

variable "enable_bedrock_endpoint" {
  description = "Bedrock VPC Endpoint"
  type        = string
}

variable "enable_bedrock_runtime_endpoint" {
  description = "Bedrock Runtime VPC Endpoint"
  type        = string
}

variable "enable_bedrock_agent_endpoint" {
  description = "Bedrock Agent VPC Endpoint"
  type        = string
}

variable "enable_bedrock_agent_runtime_endpoint" {
  description = "Bedrock Agent Runtime VPC Endpoint"
  type        = string
}

