// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
  }
}



provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Environment = var.env_name
      Application = var.app_name
    }
  }
}