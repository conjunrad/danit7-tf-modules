variable "public_ssh_key" {
  description = "value"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "owner" {
  description = "Default owner for all AWS services"
  type        = string
  default     = "Roman Tarasenko"
}

variable "ami" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0bade3941f267d2b8"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for VPC"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for VPC"
  type        = string
}
