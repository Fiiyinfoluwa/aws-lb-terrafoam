# data "aws_acm_certificate" "amazon_issued" {
#   domain      = "fiiyinfoluwa.live"
#   types       = ["AMAZON_ISSUED"]
#   most_recent = true
# }

data "aws_route53_zone" "fiiyinfoluwa_live" {
  name         = "fiiyinfoluwa.live"
  private_zone = false
}

