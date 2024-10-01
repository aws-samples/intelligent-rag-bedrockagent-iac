// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

data "aws_caller_identity" "this" {}
data "aws_partition" "this" {}
data "aws_region" "this" {}

data "aws_s3_object" "initial_package_file" {
  bucket = var.code_base_bucket
  key    = var.code_base_zip
}
data "aws_lambda_function" "existing" {
  function_name = aws_lambda_function.bi_chatbot_container_lambda.function_name
}