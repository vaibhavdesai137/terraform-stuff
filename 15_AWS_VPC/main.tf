
provider "aws" {
  region = "us-west-1"
}

# Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

module "vpc" {

  // Use the terraform module from AWS & override the defaults
  source = "terraform-aws-modules/vpc/aws"

  // 64 IPs available
  // 32 IPs in private subnet and 32 IPs in public subnet
  // 16 IPs in each subnet in each az
  cidr = "10.10.0.0/26"

  azs = ["us-east-1a", "us-east-1b"]

  // Will create route table using IGW for inbound/outbound access on public subnet
  public_subnets = ["10.10.0.0/28", "10.10.0.16/28"]

  // No inbound/outbound access
  private_subnets = ["10.10.0.32/28", "10.10.0.48/28"]

  // Gives outbound access to our EC2 instances in private subnet
  // Will create route tables automatically and use NAT for it
  enable_nat_gateway = true

  tags = {
    Name = "terraform-vpc"
    Workspace = "${terraform.workspace}"
  }

}