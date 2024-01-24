variable "example_aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for all resources"  
}

variable "example_aws_vpc_id" {
  type        = string
  default     = "vpc-12345678"
  description = "VPC ID for all resources"  
}

variable "example_aws_public_subnet_id" {
  type        = string
  default     = "subnet-12345678"
  description = "Public subnet ID for all resources"  
}

variable "example_developer_ip" {
  type        = string
  default     = "123.45.67.890/32"  
}