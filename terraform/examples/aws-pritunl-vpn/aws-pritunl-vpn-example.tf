# A Simple AWS provider in the us-east-1 region with a local backend
provider "aws" {
  region = "us-east-2"
}

terraform {
  # use s3 for the backend. the bucket is called "kompliant-terraform-examples"
  backend "s3" {
    bucket = "derpys-playground-tf-examples"
    key    = "pritunl.tfstate"
    region = "us-east-1"
  }
}

module "aws-pritunl" {
    source = "../../modules/aws-pritunl"
    # source = "github.com/cyberworld-builders/blackrainbow-zero//terraform/modules/aws-pritunl?ref=main"

    # count = 0

    environment = "example"
    vpc_id = "vpc-02d8e874d887624c0"
    subnet_id = "subnet-0cb88233e387c955a"
}