// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0



# Sample Values, modify accordingly

knowledge_base_name                 = "bedrock-kb"
enable_access_logging               = true
enable_s3_lifecycle_policies        = true
enable_endpoints                    = true
knowledge_base_model_id             = "amazon.titan-embed-text-v2:0"
app_name                            = "acme"
env_name                            = "dev"
app_region                          = "usw2"
agent_model_id                      = "anthropic.claude-3-haiku-20240307-v1:0"
bedrock_agent_invoke_log_bucket     = "bedrock-agent-bucket"
agent_name                          = "bedrock-agent"
agent_alias_name                    = "bedrock-agent-alias"
agent_action_group_name             = "bedrock-agent-ag"
aoss_collection_name                = "aoss-collection"
aoss_collection_type                = "VECTORSEARCH"
agent_instructions                  = <<-EOT
You are a helpful fitness assistant. You have general knowledge about sports. You can answer
questions related to fitness, diet plans. Use only the tools or knowledge base provided to answer
user questions. Choose between the tools or the knowledge base. Do not use both. Do not respond
without using a tool or knowledge base.
When a user asks to calculate their BMI:
1. Ask for their weight in kilograms.
2. Ask for their height in meters
3. If the user provides values in any other unit, convert it into kilograms for weight and
meters for height. Do not make any comments about health status.
EOT
agent_description                   = "You are a fitness chatbot"
agent_actiongroup_descrption        = "Use the action group to get the fitness plans, diet plans and historical details"
kb_instructions_for_agent           = "Use the knowledge base when the user is asking for a definition about a fitness, diet plans. Give a very detailed answer and cite the source."
kms_key_id                          = "arn:aws:kms:us-west-2:12345678912:key/1488f8c9-6443-4486-9927-8825278e3aad"
vpc_subnet_ids                      = ["subnet-0eb0b0e49448a5b49", "subnet-0f423fe837a1cfa22"]
vpc_id                              = "vpc-047dd28296946f67c"
cidr_blocks_sg                      = ["172.16.5.0/24", "172.16.6.0/24"]
code_base_zip                       = "package.zip"
code_base_bucket                    = "lambda-bedrock-bucket"
enable_guardrails                   = true
guardrail_name                      = "bedrock-guardrail"
guardrail_blocked_input_messaging   = "This input is not allowed due to content restrictions."
guardrail_blocked_outputs_messaging = "The generated output was blocked due to content restrictions."
guardrail_description               = "A guardrail for Bedrock to ensure safe and appropriate content"
guardrail_content_policy_config = [
  {
    filters_config = [
      {
        input_strength  = "MEDIUM"
        output_strength = "MEDIUM"
        type            = "HATE"
      },
      {
        input_strength  = "HIGH"
        output_strength = "HIGH"
        type            = "VIOLENCE"
      }
    ]
  }
]
guardrail_sensitive_information_policy_config = [
  {
    pii_entities_config = [
      {
        action = "BLOCK"
        type   = "NAME"
      },
      {
        action = "BLOCK"
        type   = "EMAIL"
      }
    ],
    regexes_config = [
      {
        action      = "BLOCK"
        description = "Block Social Security Numbers"
        name        = "SSN_Regex"
        pattern     = "^\\d{3}-\\d{2}-\\d{4}$"
      }
    ]
  }
]
guardrail_topic_policy_config = [
  {
    topics_config = [
      {
        name       = "investment_advice"
        examples   = ["Where should I invest my money?", "What stocks should I buy?"]
        type       = "DENY"
        definition = "Any advice or recommendations regarding financial investments or asset allocation."
      }
    ]
  }
]
guardrail_word_policy_config = [
  {
    managed_word_lists_config = [
      {
        type = "PROFANITY"
      }
    ],
    words_config = [
      {
        text = "badword1"
      },
      {
        text = "badword2"
      }
    ]
  }
]