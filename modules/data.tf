data "aws_route53_zone" "fiiyinfoluwa_live" {
  name         = var.domain_name
  private_zone = false
}



