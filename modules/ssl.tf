# Create an ACM certificate
resource "aws_acm_certificate" "fiiyinfoluwa_live" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
}

# Create a DNS record to validate the ACM certificate
resource "aws_route53_record" "fiiyinfoluwa_live_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.fiiyinfoluwa_live.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.fiiyinfoluwa_live.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [
    each.value.record,
  ]

  allow_overwrite = true
}

# Validate the ACM certificate using the DNS record
resource "aws_acm_certificate_validation" "fiiyinfoluwa_live" {
  certificate_arn         = aws_acm_certificate.fiiyinfoluwa_live.arn
  validation_record_fqdns = [for record in aws_route53_record.fiiyinfoluwa_live_acm_validation : record.fqdn]
}