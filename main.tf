# resource "aws_vpc" "main_vpc" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags                 = { Name = var.vpc_name }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main_vpc.id
#   tags   = { Name = "${var.vpc_name}-igw" }
# }

# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.main_vpc.id
#   tags   = { Name = "${var.vpc_name}-public-rt" }
# }

# resource "aws_route" "public_internet_access" {
#   route_table_id         = aws_route_table.public_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }

# resource "aws_route_table_association" "public_subnet_association" {
#   count          = length(var.availability_zones)
#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_subnet" "public" {
#   count                   = length(var.availability_zones)
#   vpc_id                  = aws_vpc.main_vpc.id
#   cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index) # Dynamically derived subnet
#   availability_zone       = element(var.availability_zones, count.index)
#   map_public_ip_on_launch = true
#   tags                    = { Name = "${var.vpc_name}-public-${count.index}" }
# }

# resource "aws_subnet" "private" {
#   count             = length(var.availability_zones)
#   vpc_id            = aws_vpc.main_vpc.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.availability_zones)) # Offset for private subnets
#   availability_zone = element(var.availability_zones, count.index)
#   tags              = { Name = "${var.vpc_name}-private-${count.index}" }
# }

# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.main_vpc.id
#   tags   = { Name = "${var.vpc_name}-private-rt" }
# }

# resource "aws_route_table_association" "private_subnet_association" {
#   count          = length(var.availability_zones)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private_rt.id
# }

# output "vpc_id" {
#   value = aws_vpc.main_vpc.id
# }

# resource "aws_security_group" "app_sg" {
#   vpc_id = aws_vpc.main_vpc.id

#   name        = "application-security-group"
#   description = "Security group for EC2 instances hosting web applications"

#   ingress {
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#     description      = "Allow SSH access from anywhere"
#   }

#   # ingress {
#   #   from_port        = 80
#   #   to_port          = 80
#   #   protocol         = "tcp"
#   #   cidr_blocks      = ["0.0.0.0/0"]
#   #   ipv6_cidr_blocks = ["::/0"]
#   #   description      = "Allow HTTP traffic from anywhere"
#   # }

#   # ingress {
#   #   from_port        = 443
#   #   to_port          = 443
#   #   protocol         = "tcp"
#   #   cidr_blocks      = ["0.0.0.0/0"]
#   #   ipv6_cidr_blocks = ["::/0"]
#   #   description      = "Allow HTTPS traffic from anywhere"
#   # }

#   # ingress {
#   #   from_port        = var.app_port
#   #   to_port          = var.app_port
#   #   protocol         = "tcp"
#   #   cidr_blocks      = ["0.0.0.0/0"]
#   #   ipv6_cidr_blocks = ["::/0"]
#   #   description      = "Allow application-specific traffic"
#   # }

#   ingress {
#     from_port       = var.app_port
#     to_port         = var.app_port
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_sg.id]
#     description     = "Allow app traffic from ALB"
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#     description      = "Allow all outbound traffic"
#   }

#   tags = {
#     Name = "${var.vpc_name}-app-sg"
#   }
# }

# # EC2 

# # resource "aws_instance" "app_server" {
# #   ami                         = var.ami_id
# #   instance_type               = "t2.micro"
# #   subnet_id                   = aws_subnet.public[0].id
# #   vpc_security_group_ids      = [aws_security_group.app_sg.id]
# #   associate_public_ip_address = true
# #   key_name                    = var.key_pair_name

# #   iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

# #   user_data = <<-EOF
# #               #!/bin/bash
# #               echo "DB_HOST=${aws_db_instance.csye6225_db.address}" >> /opt/webapp/src/.env
# #               echo "DB_USER=${aws_db_instance.csye6225_db.username}" >> /opt/webapp/src/.env
# #               echo "DB_PASSWORD=${aws_db_instance.csye6225_db.password}" >> /opt/webapp/src/.env
# #               echo "DB_NAME=${aws_db_instance.csye6225_db.db_name}" >> /opt/webapp/src/.env
# #               echo "AWS_REGION=${var.aws_region}" >> /opt/webapp/src/.env
# #               echo "S3_BUCKET_NAME=${aws_s3_bucket.private_bucket.bucket}" >> /opt/webapp/src/.env
# #               echo "LOG_FILE_PATH=${var.log_file_path}" >> /opt/webapp/src/.env
# #               sudo chown csye6225:csye6225 /opt/webapp/src/.env
# #               sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/cloudwatch-config.json -s
# #               sudo systemctl restart webapp.service
# #               EOF

# #   root_block_device {
# #     volume_size           = 25
# #     volume_type           = "gp2"
# #     delete_on_termination = true
# #   }

# #   disable_api_termination = false

# #   tags = {
# #     Name = "${var.vpc_name}-app-server"
# #   }
# # }

# #------------------------------------------------

# resource "aws_s3_bucket" "private_bucket" {
#   bucket = uuid()
#   # acl    = "private"
#   force_destroy = true

#   tags = {
#     Name = "private-s3-bucket"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "private_bucket_encryption" {
#   bucket = aws_s3_bucket.private_bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# resource "aws_s3_bucket_lifecycle_configuration" "private_bucket_lifecycle" {
#   bucket = aws_s3_bucket.private_bucket.id

#   rule {
#     id     = "transition-to-ia"
#     status = "Enabled"

#     transition {
#       days          = 30
#       storage_class = "STANDARD_IA"
#     }
#   }
# }


# resource "aws_iam_role" "ec2_s3_role" {
#   name = "ec2-s3-access-role"

#   assume_role_policy = <<EOF
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Principal": {
#           "Service": "ec2.amazonaws.com"
#         },
#         "Action": "sts:AssumeRole"
#       }
#     ]
#   }
#   EOF
# }

# resource "aws_iam_policy" "s3_access_policy" {
#   name        = "s3-access-policy"
#   description = "Policy for EC2 to access S3"

#   policy = <<EOF
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": [
#           "s3:ListBucket",
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:DeleteObject"
#         ],
#         "Resource": [
#           "arn:aws:s3:::${aws_s3_bucket.private_bucket.id}",
#           "arn:aws:s3:::${aws_s3_bucket.private_bucket.id}/*"
#         ]
#       }
#     ]
#   }
#   EOF
# }

# resource "aws_iam_role_policy_attachment" "s3_attach" {
#   policy_arn = aws_iam_policy.s3_access_policy.arn
#   role       = aws_iam_role.ec2_s3_role.name
# }

# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "ec2-instance-profile"
#   role = aws_iam_role.ec2_s3_role.name
# }

# #---------------------------------------------------
# resource "aws_security_group" "db_sg" {
#   vpc_id = aws_vpc.main_vpc.id

#   ingress {
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [aws_security_group.app_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_db_parameter_group" "db_params" {
#   name   = "csye6225-db-params"
#   family = "mysql8.0"

#   parameter {
#     name  = "character_set_server"
#     value = "utf8mb4"
#   }
# }

# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "csye6225-db-subnet-group"
#   subnet_ids = aws_subnet.private[*].id
# }

# resource "aws_db_instance" "csye6225_db" {
#   identifier             = var.db_identifier
#   engine                 = var.db_engine
#   instance_class         = var.db_instance_class
#   allocated_storage      = var.db_allocated_storage
#   username               = var.db_username
#   password               = var.db_password
#   db_name                = var.db_name
#   db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
#   publicly_accessible    = false
#   vpc_security_group_ids = [aws_security_group.db_sg.id]
#   parameter_group_name   = aws_db_parameter_group.db_params.name

#   skip_final_snapshot = true
# }

# # -------------------------------------------------

# resource "aws_iam_policy" "cloudwatch_agent_policy" {
#   name = "cloudwatch-agent-policy"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "logs:PutLogEvents",
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:DescribeLogStreams",
#           "logs:GetLogEvents",
#           "logs:PutRetentionPolicy",
#           "cloudwatch:PutMetricData"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach" {
#   policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
#   role       = aws_iam_role.ec2_s3_role.name
# }

# # ALB ---------------------------------------------------------

# # Create Load Balancer
# resource "aws_lb" "web_alb" {
#   name               = "web-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = aws_subnet.public[*].id
# }

# #Target Group & Listener
# resource "aws_lb_target_group" "web_tg" {
#   name     = "web-target-group"
#   port     = var.app_port
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main_vpc.id

#   health_check {
#     path                = "/healthz"
#     protocol            = "HTTP"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#   }
# }

# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.web_alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.web_tg.arn
#   }
# }


# # Load Balancer Security Group
# resource "aws_security_group" "alb_sg" {
#   name        = "load-balancer-sg"
#   description = "Allow HTTP and HTTPS traffic from anywhere"
#   vpc_id      = aws_vpc.main_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.vpc_name}-alb-sg"
#   }
# }

# # Launch Template
# resource "aws_launch_template" "web_lt" {
#   name_prefix   = "csye6225-asg"
#   image_id      = var.ami_id
#   instance_type = "t2.micro"

#   key_name = var.key_pair_name

#   iam_instance_profile {
#     name = aws_iam_instance_profile.ec2_instance_profile.name
#   }

#   user_data = base64encode(<<-EOF
#     #!/bin/bash
#     echo "DB_HOST=${aws_db_instance.csye6225_db.address}" >> /opt/webapp/src/.env
#     echo "DB_USER=${aws_db_instance.csye6225_db.username}" >> /opt/webapp/src/.env
#     echo "DB_PASSWORD=${aws_db_instance.csye6225_db.password}" >> /opt/webapp/src/.env
#     echo "DB_NAME=${aws_db_instance.csye6225_db.db_name}" >> /opt/webapp/src/.env
#     echo "AWS_REGION=${var.aws_region}" >> /opt/webapp/src/.env
#     echo "S3_BUCKET_NAME=${aws_s3_bucket.private_bucket.bucket}" >> /opt/webapp/src/.env
#     echo "LOG_FILE_PATH=${var.log_file_path}" >> /opt/webapp/src/.env
#     sudo chown csye6225:csye6225 /opt/webapp/src/.env
#     sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/cloudwatch-config.json -s
#     sudo systemctl restart webapp.service
#   EOF
#   )

#   block_device_mappings {
#     device_name = "/dev/xvda"

#     ebs {
#       volume_size           = 25
#       volume_type           = "gp2"
#       delete_on_termination = true
#     }
#   }

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [aws_security_group.app_sg.id]
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "${var.vpc_name}-asg-instance"
#     }
#   }

#   disable_api_termination = false
#   depends_on              = [aws_db_instance.csye6225_db]
# }



# # Auto Scaling Group Policies
# resource "aws_autoscaling_group" "web_asg" {
#   name                      = "csye6225_asg"
#   min_size                  = 3
#   max_size                  = 5
#   desired_capacity          = 3
#   vpc_zone_identifier       = aws_subnet.public[*].id
#   health_check_type         = "EC2"
#   health_check_grace_period = 300

#   launch_template {
#     id      = aws_launch_template.web_lt.id
#     version = "$Latest"
#   }

#   target_group_arns = [aws_lb_target_group.web_tg.arn]

#   tag {
#     key                 = "Name"
#     value               = "${var.vpc_name}-asg-instance"
#     propagate_at_launch = true
#   }
# }

# resource "aws_autoscaling_policy" "scale_up" {
#   name                   = "scale_up"
#   scaling_adjustment     = 1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 60
#   autoscaling_group_name = aws_autoscaling_group.web_asg.name
# }

# resource "aws_autoscaling_policy" "scale_down" {
#   name                   = "scale_down"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 60
#   autoscaling_group_name = aws_autoscaling_group.web_asg.name
# }

# #Route 53 Update
# resource "aws_route53_record" "web_app_dns" {
#   # zone_id = var.route53_zone_id
#   # name    = "dev.${var.domain_name}"
#   zone_id = "Z0419550Z6K46DPG8OIK"
#   name    = "dev.srane.me"

#   type = "A"

#   alias {
#     name                   = aws_lb.web_alb.dns_name
#     zone_id                = aws_lb.web_alb.zone_id
#     evaluate_target_health = true
#   }
# }

# # ------------------

# resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
#   alarm_name          = "scale-up-on-high-cpu"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 1
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 60
#   statistic           = "Average"
#   threshold           = 8
#   alarm_description   = "This metric monitors high CPU usage"
#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.web_asg.name
#   }
#   alarm_actions = [aws_autoscaling_policy.scale_up.arn]
# }

# resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
#   alarm_name          = "scale-down-on-low-cpu"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = 1
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 60
#   statistic           = "Average"
#   threshold           = 7
#   alarm_description   = "This metric monitors low CPU usage"
#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.web_asg.name
#   }
#   alarm_actions = [aws_autoscaling_policy.scale_down.arn]
# }
