// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


resource "aws_sqs_queue" "bi_chatbot_container_lambda_dql" {
  name              = "bi-chatbot-container-lambda-dlq-${var.app_name}-${var.env_name}"
  kms_master_key_id = var.kms_key_id
}

resource "aws_security_group" "lambda_group_lambda" {
  name        = "lambda-security-group-${var.app_name}-${var.env_name}"
  vpc_id      = var.vpc_id
  description = "Security Group for Lambda Function"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow egress to all"
  }
}

resource "aws_lambda_code_signing_config" "this" {
  description = "Code signing config for AFT Lambda"

  allowed_publishers {
    signing_profile_version_arns = [
      aws_signer_signing_profile.this.arn,
    ]
  }

  policies {
    untrusted_artifact_on_deployment = "Warn"
  }
}

resource "aws_signer_signing_profile" "this" {
  name_prefix = "AwsLambdaCodeSigningAction"
  platform_id = "AWSLambda-SHA384-ECDSA"

  signature_validity_period {
    value = 5
    type  = "YEARS"
  }
}

resource "aws_lambda_function" "bi_chatbot_container_lambda" {
  function_name                  = "bi-chatbot-container-lambda-${var.app_name}-${var.env_name}"
  handler                        = "lambda_function.lambda_handler"
  runtime                        = "python3.12"
  architectures                  = ["x86_64"]
  kms_key_arn                    = var.kms_key_id
  role                           = var.agent_lambda_role_arn
  code_signing_config_arn        = aws_lambda_code_signing_config.this.arn
  reserved_concurrent_executions = "-1"
  timeout                        = 300
  publish                        = true
# make sure Lambda code is available at below Amazon S3 bucket/location before code is deployed  
  s3_bucket                      = var.code_base_bucket 
  s3_key                         = var.code_base_zip
  package_type                   = "Zip"
  memory_size                    = 1024
  layers = [
    "arn:aws:lambda:${local.region}:017000801446:layer:AWSLambdaPowertoolsPythonV2:60"
  ]
  tracing_config {
    mode = "Active"
  }
  dead_letter_config {
    target_arn = aws_sqs_queue.bi_chatbot_container_lambda_dql.arn
  }
  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = [aws_security_group.lambda_group_lambda.id]
  }
  environment {
    variables = {
      MODEL_ID                       = var.agent_model_id
      HAIKU_MODEL_ID                 = var.agent_model_id
      GROUP_DATA_OBJECT_KEY          = "group_data.json"
      REPORT_DATA_OBJECT_KEY         = "report_data.json"
      FILTER_DATA_OBJECT_KEY         = "fields.json"
      MAPPING_DATA_OBJECT_KEY        = "maps.json"
      REQUEST_TEMPLATE_OBJECT_KEY    = "request_template.json"
      RESPONSE_TEMPLATE_OBJECT_KEY   = "response_template.json"
      FEW_SHOT_OBJECT_KEY            = "examples.json"
      GENERATE_FIELDS                = var.generate_fields
      AGENT_DESCRIPTION              = var.agent_description
      AGENT_INSTRUCTIONS             = var.agent_instructions
      ACTION_GROUP_AGENT_DESCRIPTION = var.agent_actiongroup_descrption
      KB_INSTRUCTIONS_FOR_AGENT      = var.kb_instructions_for_agent
    }
  }
}


resource "aws_lambda_permission" "allow_bedrock_lambda_invoke" {
  statement_id   = "AllowExecutionFromBedrock"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.bi_chatbot_container_lambda.function_name
  principal      = "bedrock.amazonaws.com"
  source_account = data.aws_caller_identity.this.account_id
  source_arn     = "arn:aws:bedrock:${local.region}:${local.account_id}:agent/*"
}

resource "aws_lambda_alias" "scale_up_lambda_alias" {
  name             = "provisioned-${aws_lambda_function.bi_chatbot_container_lambda.function_name}"
  description      = "Alias for provisioned instances of ${aws_lambda_function.bi_chatbot_container_lambda.function_name}"
  function_name    = aws_lambda_function.bi_chatbot_container_lambda.function_name
  function_version = aws_lambda_function.bi_chatbot_container_lambda.version
}

# Provisioned consurrency set at 3

resource "aws_lambda_provisioned_concurrency_config" "concurrency_setup" {
  function_name                     = aws_lambda_function.bi_chatbot_container_lambda.function_name
  provisioned_concurrent_executions = var.provisioned_concurrent_executions
  qualifier                         = aws_lambda_alias.scale_up_lambda_alias.name
}

resource "null_resource" "lambda_code_update" {
  depends_on = [aws_lambda_function.bi_chatbot_container_lambda]

  provisioner "local-exec" {
    command = "aws lambda update-function-code --function-name ${aws_lambda_function.bi_chatbot_container_lambda.function_name} --s3-bucket ${var.code_base_bucket} --s3-key ${var.code_base_zip}  --region ${local.region}"
  }

  triggers = {
    s3_object_version = data.aws_s3_object.initial_package_file.version_id
    s3_object_etag    = data.aws_s3_object.initial_package_file.etag
  }
}


resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.bi_chatbot_container_lambda.function_name}"
  retention_in_days = var.cloudwatch_log_group_retention
  kms_key_id        = var.kms_key_id
}

resource "aws_cloudwatch_log_stream" "lambda_log_stream" {
  name           = "${aws_lambda_function.bi_chatbot_container_lambda.function_name}-cw-stream"
  log_group_name = aws_cloudwatch_log_group.lambda_log_group.name
}
