variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
}

variable "ami_id" {
  description = "Amazon Machine Image (AMI) ID for EC2 instance"
  type        = string
}

variable "app_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "key_pair_name" {
  description = "The name of the AWS Key Pair"
  type        = string
}
