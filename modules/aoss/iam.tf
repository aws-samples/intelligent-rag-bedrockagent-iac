// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


resource "aws_opensearchserverless_access_policy" "sample_kb_aoss_policy" {
  name = "aoss-kb-policy-${var.app_name}-${var.env_name}"
  type = "data"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index"
          Resource = [
            "index/${var.aoss_collection_name}/*"
          ]
          Permission = [
            "aoss:CreateIndex",
            "aoss:DeleteIndex",
            "aoss:DescribeIndex",
            "aoss:ReadDocument",
            "aoss:UpdateIndex",
            "aoss:WriteDocument"
          ]
        },
        {
          ResourceType = "collection"
          Resource = [
            "collection/${var.aoss_collection_name}"
          ]
          Permission = [
            "aoss:CreateCollectionItems",
            "aoss:DescribeCollectionItems",
            "aoss:UpdateCollectionItems"
          ]
        }
      ],
      Principal = [
        var.knowledge_base_role_arn,
        data.aws_caller_identity.this.arn
      ]
    }
  ])
}

# USE sample CMK

resource "aws_opensearchserverless_security_policy" "sample_kb_encryption_policy" {
  name = "aoss-encr-policy-${var.app_name}-${var.env_name}"
  type = "encryption"
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/${var.aoss_collection_name}"
        ]
        ResourceType = "collection"
      }
    ],
    #AWSOwnedKey = true
    KmsARN = var.kms_key_id
  })
}

resource "aws_opensearchserverless_security_policy" "sample_kb_network_policy" {
  name = "aoss-nw-policy-${var.app_name}-${var.env_name}"
  type = "network"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection"
          Resource = [
            "collection/${var.aoss_collection_name}"
          ]
        },
        {
          ResourceType = "dashboard"
          Resource = [
            "collection/${var.aoss_collection_name}"
          ]
        }
      ]
      AllowFromPublic = true
    }
  ])
}