terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
    }
  }
  cloud {
    organization = "cyberworld-builders"
    workspaces {
      name = "example-aws-wazuh"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "aws-wazuh" {
#   source = "github.com/cyberworld-builders/terraform//modules/aws-wazuh"
  source = "../../modules/aws-wazuh"
  project_name = "example"
  aws_region = "us-east-2"
}