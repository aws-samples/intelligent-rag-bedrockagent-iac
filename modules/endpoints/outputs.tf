// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


output "interface_endpoint_ids" {
  description = "IDs of the created Interface VPC endpoints"
  value       = { for k, v in aws_vpc_endpoint.interface_endpoints : k => v.id }
}

output "bedrock_interface_endpoint_ids" {
  description = "IDs of the created Interface VPC endpoints"
  value       = { for k, v in aws_vpc_endpoint.bedrock_interface_endpoints : k => v.id }
}

output "s3_endpoint_id" {
  description = "ID of the created S3 Gateway VPC endpoint"
  value       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].id : null
}

