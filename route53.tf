#Route 53 Update
resource "aws_route53_record" "web_app_dns" {
  zone_id = var.route53_zone_id
  name    = var.domain_name

  type = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}