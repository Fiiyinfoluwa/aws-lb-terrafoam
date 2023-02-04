# AWS LOADBALACER INFRASTRUCTURE CONFIGURATION WITH TERRAFORM AND CONFIGURATION MANAGEMENT WITH ANSIBLE

## Introduction

This project uses Terraform to create an AWS Loadbalancer infrastructure and Ansible to configure it to display each server's hostname.

## Requirements

- Terraform
- Ansible
- AWS CLI configured with your credentials

## What Main.tf does

- Imports the modules

## What vpc.tf does

- Creates a VPC
- Creates a public subnet
- Creates a public route table
- Creates a public route table association
- Creates an internet gateway
- Creates a public route

## What provider.tf does

- Defines the AWS provider
- Defines the AWS region

## What EC2.tf does

- Creates multiple EC2 instance
- Imports the public key

## What security.tf does

- Creates a security group for the EC2 instances
- Creates a security group for the load balancer

## What variables.tf does

- Defines the default variables used in the project

## What loadbalancer.tf does

- Creates a load balancer
- Creates a http and https load balancer listener rule

## What target.tf does

- Creates a load balancer target group
- Creates a load balancer target group attachment

## What subdomain.tf does

- Creates a subdomain for the load balancer
- Creates a A record for the subdomain

## What ssl.tf does

- Creates a SSL certificate
- Creates a validation record for the SSL certificate
- Creates a SSL policy for the load balancer
- Validates the SSL certificate

## What inventory.tf does

- Creates a host inventory file for Ansible
- Configures the Servers with Ansible

## What data.tf does

- Imports the hosted zone id

## What playbook.yml does

- Installs Apache
- Sets the hostname of the servers
- Sets the timezone of the server
- Configures Apache to display the hostname

## How to use

- Clone this repository
- Define your variables in `terraform.tfvars` file
- Run `terraform init` to initialize the project
- Run `terraform plan` to see the changes that will be applied
- Run `terraform apply` to apply the changes
