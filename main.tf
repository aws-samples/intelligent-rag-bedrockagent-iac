
// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


module "knowledge_base_bucket" {
  source                                = "./modules/s3"
  kb_bucket_name_prefix                 = "kb-${var.app_region}-${var.env_name}"
  log_bucket_name_prefix                = "kb-accesslog-${var.app_region}-${var.env_name}"
  kb_bucket_log_bucket_directory_prefix = "log-${var.app_region}-${var.env_name}"
  kms_key_id                            = var.kms_key_id
  enable_access_logging                 = var.enable_access_logging
  enable_s3_lifecycle_policies          = var.enable_s3_lifecycle_policies
  vpc_id                                = var.vpc_id
}

module "roles" {
  source                              = "./modules/roles"
  agent_model_id                      = var.agent_model_id
  knowledge_base_model_id             = var.knowledge_base_model_id
  knowledge_base_bucket_arn           = module.knowledge_base_bucket.arn
  knowledge_base_arn                  = module.bedrock_knowledge_base.knowledge_base_arn
  bedrock_agent_invoke_log_group_name = "agent-invoke-log-${var.agent_name}-${var.app_region}-${var.env_name}"
  kms_key_id                          = var.kms_key_id
  env_name                            = var.env_name
  app_name                            = var.app_name
}

module "aoss" {
  source                  = "./modules/aoss"
  aoss_collection_name    = "${var.aoss_collection_name}-${var.app_region}-${var.env_name}"
  aoss_collection_type    = var.aoss_collection_type
  knowledge_base_role_arn = module.roles.knowledge_base_role_arn
  vpc_id                  = var.vpc_id
  vpc_subnet_ids          = var.vpc_subnet_ids
  kms_key_id              = var.kms_key_id
  env_name                = var.env_name
  app_name                = var.app_name
}


module "bedrock_knowledge_base" {
  source                    = "./modules/bedrock/knowledge_base"
  aoss_collection_arn       = module.aoss.aoss_collection_arn
  knowledge_base_role_arn   = module.roles.knowledge_base_role_arn
  knowledge_base_role       = module.roles.knowledge_base_role_name
  knowledge_base_bucket_arn = module.knowledge_base_bucket.arn
  knowledge_base_model_id   = var.knowledge_base_model_id
  knowledge_base_name       = "${var.knowledge_base_name}-${var.app_region}-${var.env_name}"
  agent_model_id            = var.agent_model_id
  kms_key_id                = var.kms_key_id
  env_name                  = var.env_name
  app_name                  = var.app_name
}


module "bedrock_agent" {
  source                              = "./modules/bedrock/agent"
  agent_name                          = "${var.agent_name}-${var.app_region}-${var.env_name}"
  agent_model_id                      = var.agent_model_id
  agent_role_arn                      = module.roles.bedrock_agent_role_arn
  agent_lambda_role_arn               = module.roles.bedrock_agent_lambda_role_arn
  agent_alias_name                    = "${var.agent_alias_name}-${var.app_region}-${var.env_name}"
  agent_action_group_name             = "${var.agent_action_group_name}-${var.app_region}-${var.env_name}"
  agent_instructions                  = var.agent_instructions
  agent_actiongroup_descrption        = var.agent_actiongroup_descrption
  agent_description                   = var.agent_description
  knowledge_base_arn                  = module.bedrock_knowledge_base.knowledge_base_arn
  knowledge_base_id                   = module.bedrock_knowledge_base.knowledge_base_id
  knowledge_base_bucket               = module.knowledge_base_bucket.name
  bedrock_agent_invoke_log_group_name = "agent-invoke-log-${var.agent_name}-${var.app_region}-${var.env_name}"
  bedrock_agent_invoke_log_group_arn  = module.roles.bedrock_agent_invoke_log_group_role_arn
  code_base_bucket                    = var.code_base_bucket
  code_base_zip                       = var.code_base_zip
  kb_instructions_for_agent           = var.kb_instructions_for_agent
  vpc_id                              = var.vpc_id
  cidr_blocks_sg                      = var.cidr_blocks_sg
  vpc_subnet_ids                      = var.vpc_subnet_ids
  kms_key_id                          = var.kms_key_id
  env_name                            = var.env_name
  app_name                            = var.app_name
}

module "bedrock_guardrail" {
  count                               = var.enable_guardrails ? 1 : 0
  source                              = "./modules/bedrock/agent-guardrails"
  name                                = var.guardrail_name
  blocked_input_messaging             = var.guardrail_blocked_input_messaging
  blocked_outputs_messaging           = var.guardrail_blocked_outputs_messaging
  description                         = var.guardrail_description
  content_policy_config               = var.guardrail_content_policy_config
  sensitive_information_policy_config = var.guardrail_sensitive_information_policy_config
  topic_policy_config                 = var.guardrail_topic_policy_config
  word_policy_config                  = var.guardrail_word_policy_config
  kms_key_id                          = var.kms_key_id
}

module "vpc_endpoints" {
  source                                = "./modules/endpoints"
  count                                 = var.enable_endpoints ? 1 : 0
  vpc_id                                = var.vpc_id
  cidr_blocks_sg                        = var.cidr_blocks_sg
  vpc_subnet_ids                        = var.vpc_subnet_ids
  lambda_security_group_id              = module.bedrock_agent.lambda_security_group_id
  enable_cloudwatch_endpoint            = true
  enable_kms_endpoint                   = true
  enable_ssm_endpoint                   = true
  enable_s3_endpoint                    = true
  enable_sqs_endpoint                   = true
  enable_bedrock_endpoint               = true
  enable_bedrock_runtime_endpoint       = true
  enable_bedrock_agent_endpoint         = true
  enable_bedrock_agent_runtime_endpoint = true
  env_name                              = var.env_name
  app_name                              = var.app_name
  depends_on                            = [module.knowledge_base_bucket, module.roles, module.aoss, module.bedrock_knowledge_base, module.bedrock_agent, module.bedrock_guardrail[0]]
}

module "agent_update_lifecycle" {
  source                                  = "./modules/bedrock/agent-lifecycle"
  code_base_bucket                        = var.code_base_bucket
  ssm_parameter_agent_name                = module.bedrock_agent.ssm_parameter_agent_name
  ssm_parameter_agent_id                  = module.bedrock_agent.ssm_parameter_agent_id
  ssm_parameter_agent_alias               = module.bedrock_agent.ssm_parameter_agent_alias
  ssm_parameter_agent_instruction         = module.bedrock_agent.ssm_parameter_agent_instruction
  ssm_parameter_agent_ag_instruction      = module.bedrock_agent.ssm_parameter_agent_ag_instruction
  ssm_parameter_knowledge_base_id         = module.bedrock_knowledge_base.ssm_parameter_knowledge_base_id
  ssm_parameter_lambda_code_sha           = module.bedrock_agent.ssm_parameter_agent_ag_lambda_sha
  ssm_parameter_agent_instruction_history = module.bedrock_agent.ssm_parameter_agent_instruction_history
  ssm_parameter_kb_instruction_history    = module.bedrock_knowledge_base.ssm_parameter_kb_instruction_history
  lambda_function_name                    = module.bedrock_agent.lambda_function_name
  depends_on                              = [module.knowledge_base_bucket, module.roles, module.aoss, module.bedrock_knowledge_base, module.bedrock_agent, module.bedrock_guardrail[0], module.vpc_endpoints[0]]
}