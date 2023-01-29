# AWS LOADBALACER INFRASTRUCTURE CONFIGURATION WITH TERRAFORM AND CONFIGURATION MANAGEMENT WITH ANSIBLE

## Introduction

This project uses Terraform to create an AWS Loadbalancer infrastructure and Ansible to configure it to display each server's hostname.

## Requirements

- Terraform
- Ansible
- AWS CLI configured with your credentials

## What Main.tf does

- Creates a VPC
- Creates a public subnet
- Creates a public route table
- Creates a public route table association
- Creates an internet gateway
- Creates a public route
- Creates a security group for the load balancer and the instances
- Creates a load balancer
- Creates a http and https load balancer listener rule
- Creates a load balancer target group
- Creates a subdomain
- Creates a load balancer target group attachment
- Creates a SSL certificate and a validation record
- Creates a host inventory file for Ansible
- Configures the Servers with Ansible

## How to use

- Clone this repository
- Define your variables in `terraform.tfvars` file
- Run `terraform init` to initialize the project
- Run `terraform plan` to see the changes that will be applied
- Run `terraform apply` to apply the changes
