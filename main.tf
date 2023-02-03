module "aws-lb" {
  source = "./modules"
  sub_domain_name = "terraform-test"
  private_file_path = "/home/vagrant/terraform-dir/aws-lb-terraform/web1.pem"
  public_file_path = "/home/vagrant/terraform-dir/aws-lb-terraform/web.pub" 
}

