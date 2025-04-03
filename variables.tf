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

variable "log_file_path" {
  description = "path for log file"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 Zone ID"
  type        = string
}

variable "domain_name" {
  description = "Domain Name"
  type        = string
}

variable "scale_up_threshold" {
  description = "Threshold Value for scale up"
  type        = number
}

variable "scale_down_threshold" {
  description = "Threshold Value for scale down"
  type        = number
}

variable "evaluation_periods" {
  description = "Evaluation Period"
  type        = number
}

variable "metric_period" {
  description = "Metric Period at which CloudWatch collects data points(in seconds)"
  type        = number
}

variable "statistic" {
  description = "Statistic"
  type        = string
}

variable "asg_max_size" {
  description = "ASG maximum no. of instances"
  type        = number
}

variable "asg_min_size" {
  description = "ASG minimum no. of instances"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired no. of instances"
  type        = number
}

variable "cooldown_period" {
  description = "Minimum time period between actions"
  type        = number
}

variable "autoscaling_policy_adjustment_type" {
  description = "defines how the scaling adjustment is applied when the policy is triggered"
  type        = string
}

variable "tg_protocol" {
  description = "Protocol(HTTP/HTTPS)"
  type        = string
}

variable "tg_interval" {
  description = "Sets how often the Load Balancer performs health checks (in seconds)"
  type        = number
}

variable "tg_timeout" {
  description = "Defines how long the Load Balancer waits for a response from the target before"
  type        = number
}

variable "tg_healthy_threshold" {
  description = "The number of consecutive successful health checks required before marking an instance as healthy"
  type        = number
}

variable "tg_unhealthy_threshold" {
  description = "The number of consecutive failed health checks before marking an instance unhealthy"
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
