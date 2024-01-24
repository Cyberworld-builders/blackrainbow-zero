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
