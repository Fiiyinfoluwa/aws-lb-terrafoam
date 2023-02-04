# Create a host file for ansible to use
resource "local_file" "host" {
  content  = join("\n", aws_instance.main.*.public_ip)
  filename = "host"
}

# Run the ansible playbook
resource "null_resource" "playbook" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key /home/vagrant/terraform-dir/aws-lb-terraform/web1.pem -i host /home/vagrant/terraform-dir/aws-lb-terraform/ansible/playbook.yml"


    connection {
      type        = "ssh"
      user        = var.user
      private_key = file("/home/vagrant/terraform-dir/aws-lb-terraform/web1.pem")
      host        = element(aws_instance.main.*.public_ip, 0)
    }
  }

  depends_on = [
    local_file.host
  ]
}