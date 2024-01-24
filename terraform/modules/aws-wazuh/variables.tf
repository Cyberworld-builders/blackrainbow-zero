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
  default     = "us-east-1"
  description = "AWS region for all resources"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-12345678"
  description = "VPC ID for all resources"
}

variable "ami_id" {
  type        = string
  default     = "ami-05fb0b8c1424f266b"
  description = "AMI ID for all resources"
}

variable "instance_type" {
  type        = string
  default     = "t2.medium"
  description = "Instance type for all resources"
}

variable "subnet_id" {
  type        = string
  default     = "subnet-12345678"
  description = "Subnet ID for all resources"
}

variable "allowed_ips" {
  type        = list(string)
  default     = ["123.45.67.890/32"]
  description = "Allowed IPs for all resources"
}