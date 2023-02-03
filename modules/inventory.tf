# Create a host file for ansible to use
resource "local_file" "host" {
  content  = join("\n", aws_instance.main.*.public_ip)
  filename = "host"
}