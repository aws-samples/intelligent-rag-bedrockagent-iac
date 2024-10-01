
// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


variable "kb_bucket_name_prefix" {
  type        = string
  description = "Prefix for the S3 Bucket's name, ensuring it's full name is unique"
}

variable "log_bucket_name_prefix" {
  type        = string
  description = "Prefix for the Access Logging S3 Bucket"
}

variable "kb_bucket_log_bucket_directory_prefix" {
  type        = string
  description = "Directory Prefix for the Access Logging S3 Bucket"
}


variable "access_policy" {
  type        = string
  description = "Access policy for the bucket (in json)"
  default     = null
}

variable "kms_key_id" {
  type        = string
  description = "Optional ID of the KMS key"
  default     = null
}

variable "enable_eventbridge_notifications" {
  type        = bool
  default     = false
  description = "Enable or disable EventBridge notifications from the biucket. Defaults to false"
}

variable "log_bucket" {
  type        = string
  description = "Target bucket for access logs (optional). If not provided, bucket will store log in itself"
  default     = null
}


variable "enable_access_logging" {
  description = "Option to enable Access logging of Knowledge base bucket"
  type        = bool
}

variable "enable_s3_lifecycle_policies" {
  description = "Option to enable Lifecycle policies for Knowledge base bucket Objects"
  type        = bool
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}