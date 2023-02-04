# Create a load balancer target group
resource "aws_lb_target_group" "target" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Create a target group attachment for each instance
resource "aws_lb_target_group_attachment" "tg-attachment" {
  count            = length(var.instance_name)
  target_group_arn = aws_lb_target_group.target.arn
  target_id        = element(aws_instance.main.*.id, count.index)
  port             = 80
}