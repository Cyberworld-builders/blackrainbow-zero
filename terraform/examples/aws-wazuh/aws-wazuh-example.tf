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
  region = var.example_aws_region
}

module "aws-wazuh" {
#   source = "github.com/cyberworld-builders/terraform//modules/aws-wazuh"
  source = "../../modules/aws-wazuh"
  project_name = "blackrainbow"
  environment = "example"
  aws_region = var.example_aws_region
  vpc_id = var.example_aws_vpc_id
  ami_id = "ami-05fb0b8c1424f266b"
  instance_type = "t2.medium"
  subnet_id = var.example_aws_public_subnet_id
}