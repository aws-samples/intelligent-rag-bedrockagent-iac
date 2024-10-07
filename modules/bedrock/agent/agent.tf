// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


resource "aws_bedrockagent_agent" "bedrock_agent" {
  agent_name                  = var.agent_name
  agent_resource_role_arn     = var.agent_role_arn
  idle_session_ttl_in_seconds = 600
  prepare_agent               = var.prepare_agent
  customer_encryption_key_arn = var.kms_key_id
  foundation_model            = var.agent_model_id
  description                 = var.agent_description
  instruction                 = var.agent_instructions

  # ADVANCED PROMPTS (OPTIONAL)
  
  prompt_override_configuration {
    prompt_configurations {
      base_prompt_template = file("${path.module}/prompt_templates/pre_processing.txt")
      inference_configuration {
        max_length     = 4096
        stop_sequences = ["\n\nHuman:"]
        temperature    = 0
        top_k          = 250
        top_p          = 1
      }
      parser_mode          = "DEFAULT"
      prompt_creation_mode = "OVERRIDDEN"
      prompt_state         = "ENABLED"
      prompt_type          = "PRE_PROCESSING"
    }
    prompt_configurations {
      base_prompt_template = file("${path.module}/prompt_templates/orchestration.txt")
      inference_configuration {
        max_length     = 4096
        stop_sequences = ["\n\nHuman:"]
        temperature    = 0
        top_k          = 250
        top_p          = 1
      }
      parser_mode          = "DEFAULT"
      prompt_creation_mode = "OVERRIDDEN"
      prompt_state         = "ENABLED"
      prompt_type          = "ORCHESTRATION"
    }
    prompt_configurations {
      base_prompt_template = file("${path.module}/prompt_templates/kb_resp_gen.txt")
      inference_configuration {
        max_length     = 4096
        stop_sequences = ["\n\nHuman:"]
        temperature    = 0
        top_k          = 250
        top_p          = 1
      }
      parser_mode          = "DEFAULT"
      prompt_creation_mode = "OVERRIDDEN"
      prompt_state         = "ENABLED"
      prompt_type          = "KNOWLEDGE_BASE_RESPONSE_GENERATION"
    }
    prompt_configurations {
      base_prompt_template = file("${path.module}/prompt_templates/post_processing.txt")
      inference_configuration {
        max_length     = 4096
        stop_sequences = ["\n\nHuman:"]
        temperature    = 0
        top_k          = 250
        top_p          = 1
      }
      parser_mode          = "DEFAULT"
      prompt_creation_mode = "OVERRIDDEN"
      prompt_state         = "ENABLED"
      prompt_type          = "POST_PROCESSING"
    }
  }
}

resource "aws_bedrockagent_agent_action_group" "bedrock_agent_actiongroup" {
  action_group_name          = var.agent_action_group_name
  agent_id                   = aws_bedrockagent_agent.bedrock_agent.id
  agent_version              = "DRAFT"
  description                = var.agent_actiongroup_descrption
  skip_resource_in_use_check = true
  action_group_executor {
    lambda = aws_lambda_function.bi_chatbot_container_lambda.arn
  }
  api_schema {
    payload = local.api_schema_path
  }
}

resource "aws_bedrockagent_agent_knowledge_base_association" "bedrock_agent_kb_association" {
  agent_id             = aws_bedrockagent_agent.bedrock_agent.agent_id
  description          = var.kb_instructions_for_agent
  knowledge_base_id    = var.knowledge_base_id
  knowledge_base_state = "ENABLED"
}


resource "null_resource" "agent_prepare" {
  triggers = {
    agent_state        = sha256(jsonencode(aws_bedrockagent_agent.bedrock_agent))
    action_group_state = sha256(jsonencode(aws_bedrockagent_agent_action_group.bedrock_agent_actiongroup))
    kb_assoc_state     = sha256(jsonencode(aws_bedrockagent_agent_knowledge_base_association.bedrock_agent_kb_association))
  }
  provisioner "local-exec" {
    command = "aws bedrock-agent prepare-agent --agent-id ${aws_bedrockagent_agent.bedrock_agent.id}"
  }
  depends_on = [
    aws_bedrockagent_agent.bedrock_agent,
    aws_bedrockagent_agent_action_group.bedrock_agent_actiongroup,
    aws_bedrockagent_agent_knowledge_base_association.bedrock_agent_kb_association
  ]
}


resource "time_sleep" "agent_api_sleep" {
  create_duration = "60s"
  depends_on      = [null_resource.agent_prepare]
}

resource "aws_bedrockagent_agent_alias" "bedrock_agent_alias" {
  agent_alias_name = var.agent_alias_name
  agent_id         = aws_bedrockagent_agent.bedrock_agent.agent_id
  description      = var.agent_alias_name
  depends_on       = [time_sleep.agent_api_sleep]
}


resource "aws_cloudwatch_log_group" "agent_invoke_log_group" {
  name              = var.bedrock_agent_invoke_log_group_name
  retention_in_days = var.cloudwatch_log_group_retention
  kms_key_id        = var.kms_key_id
}

resource "aws_cloudwatch_log_stream" "agent_invoke_log_stream" {
  name           = "${var.bedrock_agent_invoke_log_group_name}-cw-stream"
  log_group_name = aws_cloudwatch_log_group.agent_invoke_log_group.name
}


resource "aws_bedrock_model_invocation_logging_configuration" "cloudwatch_only" {
  logging_config {
    image_data_delivery_enabled     = true
    text_data_delivery_enabled      = true
    embedding_data_delivery_enabled = true
    cloudwatch_config {
      log_group_name = var.bedrock_agent_invoke_log_group_name
      role_arn       = var.bedrock_agent_invoke_log_group_arn
    }
  }
  depends_on = [aws_cloudwatch_log_group.agent_invoke_log_group, aws_cloudwatch_log_stream.agent_invoke_log_stream]
}