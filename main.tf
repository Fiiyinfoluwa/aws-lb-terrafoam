resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.subnets_cidr, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "main" {
  name        = "main"
  description = "Allow SSH, HTTP, HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "alb" {
  name   = "alb_security_group"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-alb-security-group"
  }
}

resource "aws_lb_target_group" "target" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb" "alb" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.fiiyinfoluwa_live.arn
  default_action {
    target_group_arn = aws_lb_target_group.target.arn
    type             = "forward"
  }
}


resource "aws_route53_record" "terraform-test" {
  zone_id = data.aws_route53_zone.fiiyinfoluwa_live.zone_id
  name    = "terraform-test.${data.aws_route53_zone.fiiyinfoluwa_live.name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "fiiyinfoluwa_live" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
}

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

resource "aws_acm_certificate_validation" "fiiyinfoluwa_live" {
  certificate_arn         = aws_acm_certificate.fiiyinfoluwa_live.arn
  validation_record_fqdns = [for record in aws_route53_record.fiiyinfoluwa_live_acm_validation : record.fqdn]
}

resource "aws_instance" "main" {
  count                       = length(var.instance_name)
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.web.id
  vpc_security_group_ids      = [aws_security_group.main.id]
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  associate_public_ip_address = true
  tags = {
    Name = element(var.instance_name, count.index)
  }

}

resource "aws_key_pair" "web" {
  public_key = file("/home/vagrant/web.pub")
}

resource "aws_lb_target_group_attachment" "tg-attachment" {
  count            = length(var.instance_name)
  target_group_arn = aws_lb_target_group.target.arn
  target_id        = element(aws_instance.main.*.id, count.index)
  port             = 80
}

resource "local_file" "host" {
  content  = join("\n", aws_instance.main.*.public_ip)
  filename = "host"
}

resource "null_resource" "playbook" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key /home/vagrant/web1.pem -i host playbook.yml"


    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/vagrant/web1.pem")
      host        = "${element(aws_instance.main.*.public_ip, 0)}"
    }
  }

  depends_on = [
    local_file.host
  ]
}

output "public_ip" {
  value = aws_instance.main.*.public_ip
}

