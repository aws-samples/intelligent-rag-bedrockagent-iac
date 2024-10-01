
// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


output "id" {
  value       = aws_s3_bucket.sample_kb_bucket.id
  description = "ID of S3 bucket"
}

output "name" {
  value       = aws_s3_bucket.sample_kb_bucket.bucket
  description = "Name of KB S3 bucket"
}

output "arn" {
  value       = aws_s3_bucket.sample_kb_bucket.arn
  description = "ARN of S3 bucket"
}


output "regional_domain_name" {
  value       = aws_s3_bucket.sample_kb_bucket.bucket_regional_domain_name
  description = "Regional domain name of S3 bucket"
}