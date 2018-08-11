
# Providers
provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
  alias      = "us-east-1"
}
provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-west-1"
  alias      = "us-west-1"
}

# DataSources
data "aws_availability_zones" "us-east-1" {
  provider = "aws.us-east-1"
}
data "aws_availability_zones" "us-west-1" {
  provider = "aws.us-west-1"  
}

# Variables
variable multi-az-deploy {
  default = true
}
variable us-east-1-ami {
  default = "ami-2757f631"
}
variable us-west-1-ami {
  default = "ami-07585467"
}
variable instance-type {
  default = "t2.micro"
}

# Locals
locals {
  frontend_instance_name = "my-ec2-instance-frontend"
  backend_instance_name  = "my-ec2-instance-backend"
}

resource "aws_instance" "east-frontend" {
  tags {
    Name = "${local.frontend_instance_name}"
  }
  provider              = "aws.us-east-1"
  availability_zone     = "${data.aws_availability_zones.us-east-1.names[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
}

resource "aws_instance" "east-backend" {
  tags {
    Name = "${local.backend_instance_name}"
  }
  provider              = "aws.us-east-1"
  count                 = "${var.multi-az-deploy ? 2 : 1}"
  availability_zone     = "${data.aws_availability_zones.us-east-1.names[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
}

resource "aws_instance" "west-frontend" {
  tags {
    Name = "${local.frontend_instance_name}"
  }
  provider              = "aws.us-west-1"
  availability_zone     = "${data.aws_availability_zones.us-west-1.names[count.index]}"
  ami                   = "${var.us-west-1-ami}"
  instance_type         = "${var.instance-type}"
}

resource "aws_instance" "west-backend" {
  tags {
    Name = "${local.backend_instance_name}"
  }
  provider              = "aws.us-west-1"
  count                 = "${var.multi-az-deploy ? 2 : 1}"
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
