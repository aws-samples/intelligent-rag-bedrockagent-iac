// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


locals {
  region = data.aws_region.this.name
  interface_endpoints = {
    cloudwatch = {
      service = "monitoring"
      enabled = var.enable_cloudwatch_endpoint
    }
    kms = {
      service = "kms"
      enabled = var.enable_kms_endpoint
    }
    ssm = {
      service = "ssm"
      enabled = var.enable_ssm_endpoint
    }
    ssmmessages = {
      service = "ssmmessages"
      enabled = var.enable_ssm_endpoint
    }
    sqs = {
      service = "sqs"
      enabled = var.enable_sqs_endpoint
    }
  }
  bedrock_interface_endpoints = {
    bedrock = {
      service = "bedrock"
      enabled = var.enable_bedrock_endpoint
    }
    bedrock-runtime = {
      service = "bedrock-runtime"
      enabled = var.enable_bedrock_runtime_endpoint
    }
    bedrock-agent = {
      service = "bedrock-agent"
      enabled = var.enable_bedrock_agent_endpoint
    }
    bedrock-agent-runtime = {
      service = "bedrock-agent-runtime"
      enabled = var.enable_bedrock_agent_runtime_endpoint
    }
  }
}