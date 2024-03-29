variable "environment" {
    description = "The environment name"
    type        = string
    default     = "example"  
}

variable "vpc_id" {
    description = "The VPC ID"
    type        = string
}

variable "subnet_id" {
    description = "The subnet ID"
    type        = string
}

variable "server_ports" {
    description = "The server ports"
    type        = list(number)
    default     = [13806]
}