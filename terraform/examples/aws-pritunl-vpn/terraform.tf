terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.66.0"
    }
  }
  cloud {
    organization = "cyberworld-builders"
    workspaces {
      name = "example-aws-pritunl-vpn"
    }
  }
}
