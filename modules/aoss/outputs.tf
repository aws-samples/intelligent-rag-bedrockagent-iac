// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


output "aoss_collection_arn" {
  value       = aws_opensearchserverless_collection.sample_aoss_collection.arn
  description = "Knowleddge Base AOSS Collection ARN"
}

output "aoss_collection_id" {
  value       = aws_opensearchserverless_collection.sample_aoss_collection.id
  description = "Knowleddge Base AOSS Collection ID"
}

output "aoss_collection_name" {
  value       = aws_opensearchserverless_collection.sample_aoss_collection.name
  description = "Knowleddge Base AOSS Collection Name"
}


output "oss_collection_endpoint" {
  value       = aws_opensearchserverless_collection.sample_aoss_collection.collection_endpoint
  description = "Knowleddge Base AOSS Collection Endpoint"
}

