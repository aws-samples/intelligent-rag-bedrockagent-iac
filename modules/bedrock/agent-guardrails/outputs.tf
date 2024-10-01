// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


output "guardrail_id" {
  description = "The ID of the created Bedrock Guardrail"
  value       = aws_bedrock_guardrail.this.guardrail_id
}

output "guardrail_arn" {
  description = "The ARN of the created Bedrock Guardrail"
  value       = aws_bedrock_guardrail.this.guardrail_arn
}