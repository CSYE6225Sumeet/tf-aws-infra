# Scale Up Alarm
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale-up-on-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.metric_period
  statistic           = var.statistic
  threshold           = var.scale_up_threshold
  alarm_description   = "This metric monitors high CPU usage"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

# Scale Down Alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "scale-down-on-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.metric_period
  statistic           = var.statistic
  threshold           = var.scale_down_threshold
  alarm_description   = "This metric monitors low CPU usage"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}