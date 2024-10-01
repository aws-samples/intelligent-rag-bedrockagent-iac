// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


resource "aws_security_group" "endpoint_security_group" {
  name        = "vpc-endpoint-security-group-${var.app_name}-${var.env_name}"
  vpc_id      = var.vpc_id
  description = "Security Group for VPC Endpoints"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks_sg
    description = "Allow all ingress from VPC CIDR"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow egress to all"
  }
}


resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each          = { for k, v in local.interface_endpoints : k => v if v.enabled }
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.${each.value.service}"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.vpc_subnet_ids
  security_group_ids = [
    aws_security_group.endpoint_security_group.id,
  ]
  private_dns_enabled = true

}


resource "aws_vpc_endpoint" "bedrock_interface_endpoints" {
  for_each          = { for k, v in local.bedrock_interface_endpoints : k => v if v.enabled }
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.${each.value.service}"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.vpc_subnet_ids
  security_group_ids = [
    aws_security_group.interface_group_lambda.id,
  ]
  private_dns_enabled = true

}


resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_endpoint ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
}


resource "aws_security_group" "interface_group_lambda" {
  name        = "interface-security-group-${var.app_name}-${var.env_name}"
  vpc_id      = var.vpc_id
  description = "Security Group for Bedrock Interface Endpoints"
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.lambda_security_group_id]
    description     = "Allow calls only from Lambda Function"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow egress to all"
  }
}


resource "aws_opensearchserverless_vpc_endpoint" "aoss_vpc_endpoints" {
  name       = "aoss-vpc-endpoints"
  subnet_ids = var.vpc_subnet_ids
  vpc_id     = var.vpc_id
}