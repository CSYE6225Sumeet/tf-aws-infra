# Create Load Balancer
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id
}

#Target Group & Listener
resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = var.app_port
  protocol = var.tg_protocol
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/healthz"
    protocol            = var.tg_protocol
    interval            = var.tg_interval
    timeout             = var.tg_timeout
    healthy_threshold   = var.tg_healthy_threshold
    unhealthy_threshold = var.tg_unhealthy_threshold
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}