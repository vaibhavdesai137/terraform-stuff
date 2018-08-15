
# All Providers
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
  alias      = "us-east-1"
}
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-1"
  alias      = "us-west-1"
}

# Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

# DataSources
data "aws_availability_zones" "us-east-1" {
  provider = "aws.us-east-1"
}
data "aws_availability_zones" "us-west-1" {
  provider = "aws.us-west-1"  
}

# Variables
variable us-east-1-ami {
  default = "ami-2757f631"
}
variable us-west-1-ami {
  default = "ami-07585467"
}
variable instance-type {
  default = "t2.micro"
}
variable instance-name {
  default = "placeholder-ec2-instance"
}

# All Locals
# Local values assign a name to an expression, that can then be used multiple times within a module.
locals {
  frontend_instance_name = "${replace(var.instance-name, "placeholder", "frontend")}"
  backend_instance_name  = "${replace(var.instance-name, "placeholder", "backend")}"
}

resource "aws_instance" "east-frontend" {
  tags {
    Name = "${local.frontend_instance_name}"
  }
  count                 = "2"
  provider              = "aws.us-east-1"
  availability_zone     = "${data.aws_availability_zones.us-east-1.names[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
}

resource "aws_instance" "east-backend" {
  tags {
    Name = "${local.backend_instance_name}"
  }
  count                 = "2"
  provider              = "aws.us-east-1"
  availability_zone     = "${data.aws_availability_zones.us-east-1.names[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
}

resource "aws_instance" "west-frontend" {
  tags {
    Name = "${local.frontend_instance_name}"
  }
  count                 = "2"
  provider              = "aws.us-west-1"
  availability_zone     = "${data.aws_availability_zones.us-west-1.names[count.index]}"
  ami                   = "${var.us-west-1-ami}"
  instance_type         = "${var.instance-type}"
}

resource "aws_instance" "west-backend" {
  tags {
    Name = "${local.backend_instance_name}"
  }
  count                 = "2"
  provider              = "aws.us-west-1"
  availability_zone     = "${data.aws_availability_zones.us-west-1.names[count.index]}"
  ami                   = "${var.us-west-1-ami}"
  instance_type         = "${var.instance-type}"
}

output "east-frontend-ips" {
  value = "${aws_instance.east-frontend.*.public_ip}"
}

output "east-backend-ips" {
  value = "${aws_instance.east-backend.*.public_ip}"
}

output "west-frontend-ips" {
  value = "${aws_instance.west-frontend.*.public_ip}"
}

output "west-backend-ips" {
  value = "${aws_instance.west-backend.*.public_ip}"
}

# terraform init
# terraform apply (create resources)
# terraform output (show our output variables)
# terraform show (render local state)
# terraform destroy (delete everything)
