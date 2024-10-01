// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


variable "name" {
  description = "Name of the Bedrock Guardrail"
  type        = string
}

variable "blocked_input_messaging" {
  description = "Blocked input messaging"
  type        = string
}

variable "blocked_outputs_messaging" {
  description = "Blocked outputs messaging"
  type        = string
}

variable "description" {
  description = "Description of the Bedrock Guardrail"
  type        = string
}

variable "content_policy_config" {
  description = "Content policy configuration"
  type = list(object({
    filters_config = list(object({
      input_strength  = string
      output_strength = string
      type            = string
    }))
  }))
  default = []
}

variable "sensitive_information_policy_config" {
  description = "Sensitive information policy configuration"
  type = list(object({
    pii_entities_config = list(object({
      action = string
      type   = string
    }))
    regexes_config = list(object({
      action      = string
      description = string
      name        = string
      pattern     = string
    }))
  }))
  default = []
}

variable "topic_policy_config" {
  description = "Topic policy configuration"
  type = list(object({
    topics_config = list(object({
      name       = string
      examples   = list(string)
      type       = string
      definition = string
    }))
  }))
  default = []
}

variable "word_policy_config" {
  description = "Word policy configuration"
  type = list(object({
    managed_word_lists_config = list(object({
      type = string
    }))
    words_config = list(object({
      text = string
    }))
  }))
  default = []
}

variable "kms_key_id" {
  description = "KMS Key ARN"
  type        = string
}