variable "project_name" {
  type        = string
  default     = "example"
  description = "Project name for all resources"  
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment for all resources"  
}

variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region for all resources"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-12345678"
  description = "VPC ID for all resources"
}