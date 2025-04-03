# Launch Template
resource "aws_launch_template" "web_lt" {
  name_prefix   = "csye6225-asg"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  key_name = var.key_pair_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "DB_HOST=${aws_db_instance.csye6225_db.address}" >> /opt/webapp/src/.env
    echo "DB_USER=${aws_db_instance.csye6225_db.username}" >> /opt/webapp/src/.env
    echo "DB_PASSWORD=${aws_db_instance.csye6225_db.password}" >> /opt/webapp/src/.env
    echo "DB_NAME=${aws_db_instance.csye6225_db.db_name}" >> /opt/webapp/src/.env
    echo "AWS_REGION=${var.aws_region}" >> /opt/webapp/src/.env
    echo "S3_BUCKET_NAME=${aws_s3_bucket.private_bucket.bucket}" >> /opt/webapp/src/.env
    echo "LOG_FILE_PATH=${var.log_file_path}" >> /opt/webapp/src/.env
    sudo chown csye6225:csye6225 /opt/webapp/src/.env
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/cloudwatch-config.json -s
    sudo systemctl restart webapp.service
  EOF
  )

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 25
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.vpc_name}-asg-instance"
    }
  }

  disable_api_termination = false
  depends_on              = [aws_db_instance.csye6225_db]
}



# Auto Scaling Group Policies
resource "aws_autoscaling_group" "web_asg" {
  name                      = "csye6225_asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = aws_subnet.public[*].id
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.vpc_name}-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = var.autoscaling_policy_adjustment_type
  cooldown               = var.cooldown_period
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = var.autoscaling_policy_adjustment_type
  cooldown               = var.cooldown_period
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}