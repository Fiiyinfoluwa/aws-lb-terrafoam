# Create a subdomain record in the hosted zone and associate it with the load balancer
resource "aws_route53_record" "terraform-test" {
  zone_id = data.aws_route53_zone.fiiyinfoluwa_live.zone_id
  name    = "${var.sub_domain_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
