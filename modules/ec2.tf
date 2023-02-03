# Create multiple instances in the public subnet
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

# Create a key pair for the instances
resource "aws_key_pair" "web" {
  public_key = file("/home/vagrant/terraform-dir/aws-lb-terraform/web.pub")
}