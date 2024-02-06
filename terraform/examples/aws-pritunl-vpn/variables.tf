variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region for all resources"
}

variable "server_ports" {
  type        = list(number)
  default     = [13806]
  description = "The default server port"
}