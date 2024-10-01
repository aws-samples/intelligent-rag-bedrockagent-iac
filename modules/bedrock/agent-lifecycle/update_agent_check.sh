## Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
## SPDX-License-Identifier: MIT-0


#!/bin/bash

set -e -x

# Function to get parameter value by index
get_param() {
    local index=$1
    shift
    echo "${!index}"
}

# Assign parameters to named variables
aws_region=$(get_param 1 "$@")
code_base_bucket=$(get_param 2 "$@")
ssm_parameter_agent_name=$(get_param 3 "$@")
ssm_parameter_agent_id=$(get_param 4 "$@")
ssm_parameter_agent_instruction=$(get_param 5 "$@")
ssm_parameter_agent_ag_instruction=$(get_param 6 "$@")
ssm_parameter_knowledge_base_id=$(get_param 7 "$@")
ssm_parameter_lambda_code_sha=$(get_param 8 "$@")
lambda_function_name=$(get_param 9 "$@")
ssm_parameter_agent_instructions_history=$(get_param 10 "$@")
ssm_parameter_kb_instructions_history=$(get_param 11 "$@")
ssm_parameter_agent_alias=$(get_param 12 "$@")

# Debugging output
echo "------"
echo "aws_region: $aws_region"
echo "------"
echo "code_base_bucket: $code_base_bucket"
echo "------"
echo "ssm_parameter_agent_name: $ssm_parameter_agent_name"
echo "------"
echo "ssm_parameter_agent_id: $ssm_parameter_agent_id"
echo "------"
echo "ssm_parameter_agent_instruction: $ssm_parameter_agent_instruction"
echo "------"
echo "ssm_parameter_agent_ag_instruction: $ssm_parameter_agent_ag_instruction"
echo "------"
echo "ssm_parameter_knowledge_base_id: $ssm_parameter_knowledge_base_id"
echo "------"
echo "ssm_parameter_lambda_code_sha: $ssm_parameter_lambda_code_sha"
echo "------"
echo "lambda_function_name: $lambda_function_name"
echo "------"
echo "Agent Instructions History: $ssm_parameter_agent_instructions_history"
echo "------"
echo "KB Instructions History: $ssm_parameter_kb_instructions_history"
echo "------"
echo "Agent Alias: $ssm_parameter_agent_alias"
echo "------"

# Check initial values
knowledge_base_id=$(aws ssm get-parameter --name "$ssm_parameter_knowledge_base_id" --with-decryption --output json --region "$aws_region" | jq -r .Parameter.Value)
agent_id=$(aws ssm get-parameter --name "$ssm_parameter_agent_id" --with-decryption --output json --region "$aws_region" | jq -r .Parameter.Value)
agent_name=$(aws ssm get-parameter --name "$ssm_parameter_agent_name" --with-decryption --output json --region "$aws_region" | jq -r .Parameter.Value)
agent_kb_instruction=$(aws ssm get-parameter --name "$ssm_parameter_agent_ag_instruction" --with-decryption --output json --region "$aws_region" | jq -r .Parameter.Value)
new_lambda_code_sha=$(aws lambda get-function --function-name "$lambda_function_name" --query 'Configuration.CodeSha256' --output text --region "$aws_region")

# Calculate current values and last processed values
agent_instruction_ssm_param_latest_version=$(aws ssm describe-parameters --parameter-filters "Key=Name,Values=$ssm_parameter_agent_instruction" --query 'Parameters[0].Version' --output text --region "$aws_region")
agent_instruction_ssm_param_current_value=$(aws ssm get-parameter --name "$ssm_parameter_agent_instruction" --with-decryption --query 'Parameter.Value' --output text --region "$aws_region")
agent_instruction_ssm_param_previous_version=$((agent_instruction_ssm_param_latest_version - 1))
agent_instruction_ssm_param_previous_value=$(aws ssm get-parameter-history --name "$ssm_parameter_agent_instruction" --with-decryption --output json --region "$aws_region" | jq -r --argjson version "$agent_instruction_ssm_param_previous_version" '.Parameters[]| select(.Version == $version) | .Value')
kb_instruction_ssm_param_latest_version=$(aws ssm describe-parameters --parameter-filters "Key=Name,Values=$ssm_parameter_agent_ag_instruction" --query 'Parameters[0].Version' --output text --region "$aws_region")
kb_instruction_ssm_param_current_value=$(aws ssm get-parameter --name "$ssm_parameter_agent_ag_instruction" --with-decryption --query 'Parameter.Value' --output text --region "$aws_region")
kb_instruction_ssm_param_previous_version=$((kb_instruction_ssm_param_latest_version - 1))
kb_instruction_ssm_param_previous_value=$(aws ssm get-parameter-history --name "$ssm_parameter_agent_ag_instruction" --with-decryption --output json --region "$aws_region" | jq -r --argjson version "$kb_instruction_ssm_param_previous_version" '.Parameters[]| select(.Version == $version) | .Value')
current_lambda_code_sha=$(aws ssm get-parameter --name "$ssm_parameter_lambda_code_sha" --with-decryption --query 'Parameter.Value' --output text --region "$aws_region")
last_processed_version_agent=$(aws ssm get-parameter --name "$ssm_parameter_agent_instructions_history" --with-decryption --query 'Parameter.Value' --output text --region "$aws_region" 2>/dev/null || echo "0")
last_processed_version_kb=$(aws ssm get-parameter --name "$ssm_parameter_kb_instructions_history" --with-decryption --query 'Parameter.Value' --output text --region "$aws_region" 2>/dev/null || echo "0")

ts="$(date '+%Y-%m-%d-%H-%M-%S')"

update_required=false

# Check Lambda Code Updates
if [ "$new_lambda_code_sha" != "$current_lambda_code_sha" ]; then
    echo "Changes in lambda Code observed. New Bedrock agent alias will be created."
    aws ssm put-parameter --name "$ssm_parameter_lambda_code_sha" --value "$new_lambda_code_sha" --type "SecureString" --overwrite --region "$aws_region"
    update_required=true
else
    echo "No changes in Lambda code. Skipping Bedrock agent alias creation."
fi

# Check Agent Instruction Updates
if [ "$last_processed_version_agent" = "initial" ] || [ "$last_processed_version_agent" = "0" ]; then
    echo "Detected initial value for last_processed_version_agent. Setting it to 0."
    last_processed_version_agent=0
fi

if [ "$agent_instruction_ssm_param_latest_version" -eq "$last_processed_version_agent" ]; then
    echo "No new changes in agent instructions since last processing."
else
    if [ "$agent_instruction_ssm_param_latest_version" -eq 1 ]; then
        echo "Initial version of agent instructions. No changes detected."
    else
        if [ "$agent_instruction_ssm_param_current_value" != "$agent_instruction_ssm_param_previous_value" ]; then
            echo "Changes in Agent Instructions detected."
            aws ssm put-parameter --name "$ssm_parameter_agent_instructions_history" --value "$agent_instruction_ssm_param_latest_version" --type "SecureString" --overwrite --region "$aws_region"
            update_required=true
        else
            echo "No changes in Agent Instructions despite version increment."
        fi
    fi
fi

# Check Knowledge Base Instruction Updates
if [ "$last_processed_version_kb" = "initial" ] || [ "$last_processed_version_kb" = "0" ]; then
    echo "Detected initial value for last_processed_version_kb. Setting it to 0."
    last_processed_version_kb=0
fi

if [ "$kb_instruction_ssm_param_latest_version" -eq "$last_processed_version_kb" ]; then
    echo "No new changes in knowledge base instructions since last processing."
else
    if [ "$kb_instruction_ssm_param_latest_version" -eq 1 ]; then
        echo "Initial version of knowledge base instructions. No changes detected."
    else
        if [ "$kb_instruction_ssm_param_current_value" != "$kb_instruction_ssm_param_previous_value" ]; then
            echo "Changes in Knowledge Base Instructions detected."
            aws ssm put-parameter --name "$ssm_parameter_kb_instructions_history" --value "$kb_instruction_ssm_param_latest_version" --type "SecureString" --overwrite --region "$aws_region"
            update_required=true
        else
            echo "No changes in Knowledge Base Instructions despite version increment."
        fi
    fi
fi

if $update_required ; then
    echo "New agent alias will be created as there is change observed"
    aws bedrock-agent create-agent-alias --agent-alias-name "alias-$ts" --agent-id "$agent_id" --region "$aws_region"
    aws ssm put-parameter --name "$ssm_parameter_agent_alias" --value "alias-$ts" --type "SecureString" --overwrite --region "$aws_region"
    echo "Created new Bedrock agent alias-$ts"
else
    echo "New agent alias will not be created as there is no change observed"
fi