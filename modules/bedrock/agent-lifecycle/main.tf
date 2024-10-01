// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


data "aws_region" "this" {}

data "aws_ssm_parameter" "bedrock_agent_instruction_ssm_history" {
  name = var.ssm_parameter_agent_instruction_history
}

data "aws_ssm_parameter" "bedrock_kb_instruction_ssm_history" {
  name = var.ssm_parameter_kb_instruction_history
}

resource "null_resource" "update_agent_check" {

  provisioner "local-exec" {
    command = "chmod +x ${path.module}/update_agent_check.sh; ${path.module}/update_agent_check.sh ${data.aws_region.this.name} ${var.code_base_bucket} ${var.ssm_parameter_agent_name} ${var.ssm_parameter_agent_id} ${var.ssm_parameter_agent_instruction} ${var.ssm_parameter_agent_ag_instruction} ${var.ssm_parameter_knowledge_base_id} ${var.ssm_parameter_lambda_code_sha} ${var.lambda_function_name} ${data.aws_ssm_parameter.bedrock_agent_instruction_ssm_history.name} ${data.aws_ssm_parameter.bedrock_kb_instruction_ssm_history.name} ${var.ssm_parameter_agent_alias}"
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}
