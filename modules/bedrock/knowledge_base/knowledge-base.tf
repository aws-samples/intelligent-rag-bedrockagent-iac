// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


resource "time_sleep" "aws_iam_role_policy_bedrock_sample_kb_oss" {
  create_duration = "30s"
  depends_on      = [aws_iam_role_policy.bedrock_sample_kb_oss]
}


resource "aws_bedrockagent_knowledge_base" "sample_kb" {
  name     = var.knowledge_base_name
  role_arn = var.knowledge_base_role_arn
  knowledge_base_configuration {
    vector_knowledge_base_configuration {
      embedding_model_arn = data.aws_bedrock_foundation_model.kb.model_arn
    }
    type = "VECTOR"
  }
  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = var.aoss_collection_arn
      vector_index_name = "bedrock-knowledge-base-default-index"
      field_mapping {
        vector_field   = "bedrock-knowledge-base-default-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }
  depends_on = [
    time_sleep.aws_iam_role_policy_bedrock_sample_kb_oss
  ]

}

resource "aws_bedrockagent_data_source" "data_source" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.sample_kb.id
  name              = "bedrock-knowledge-base-data-source-bucket"
  data_source_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn = var.knowledge_base_bucket_arn
    }
  }
  server_side_encryption_configuration {
    kms_key_arn = var.kms_key_id
  }
}

