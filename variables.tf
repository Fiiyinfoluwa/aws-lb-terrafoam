variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnets_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b"]
}

variable "ami" {
  type    = string
  default = "ami-0778521d914d23bc1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_name" {
  type    = list(string)
  default = ["webserver1", "webserver2", "webserver3"]
}

variable "domain_name" {
  type    = string
  default = "fiiyinfoluwa.live"
}