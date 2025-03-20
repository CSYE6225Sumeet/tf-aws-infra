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

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true # Marks this as sensitive to avoid logging
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_engine" {
  description = "Database engine type"
  type        = string
}

variable "db_instance_class" {
  description = "Instance type for the database"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage size (in GB) for the database"
  type        = number
}

# -------

# variable "aws_access_key" {
#   description = "AWS ACCESS KEY"
#   type        = string
# }

# variable "aws_secret_access_key" {
#   description = "AWS SECRET KEY"
#   type        = string
# }

# variable "s3_bucket_name" {
#   description = "S3 Bucket Name"
#   type        = string
# }
