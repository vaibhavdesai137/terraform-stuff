 
# All Providers
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

# All Variables
variable us-east-1-ami {
  default = "ami-2757f631"
}
variable us-west-1-ami {
  default = "ami-07585467"
}
variable instance-type {
  default = "t2.micro"
}
variable us-east-1-zones {
  default = ["us-east-1a", "us-east-1b"]
}
variable us-west-1-zones {
  default = ["us-west-1b", "us-west-1c"]
}

# us-east-1a and us-east-1b frontend instance
resource "aws_instance" "us-east-1-frontend" {
  depends_on            = ["aws_instance.us-east-1-backend"]
  count                 = 2
  provider              = "aws.us-east-1"
  availability_zone     = "${var.us-east-1-zones[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
  lifecycle {
    create_before_destroy = true
  }
}

# us-east-1a and us-east-1b backend instance
resource "aws_instance" "us-east-1-backend" {
  count                 = 2
  provider              = "aws.us-east-1"
  availability_zone     = "${var.us-east-1-zones[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
  lifecycle {
    prevent_destroy = true
    ignore_changes = true
  }
}

# us-west-1a and us-west-1b frontend instance
resource "aws_instance" "us-west-1-frontend" {
  depends_on            = ["aws_instance.us-west-1-backend"]
  count                 = 2
  provider              = "aws.us-west-1"
  availability_zone     = "${var.us-west-1-zones[count.index]}"
  ami                   = "${var.us-west-1-ami}"
  instance_type         = "${var.instance-type}"
  lifecycle {
    create_before_destroy = true
  }
}

# us-west-1a and us-west-1b backend instance
resource "aws_instance" "us-west-1-backend" {
  count                 = 2
  provider              = "aws.us-west-1"
  availability_zone     = "${var.us-west-1-zones[count.index]}"
  ami                   = "${var.us-west-1-ami}"
  instance_type         = "${var.instance-type}"
  lifecycle {
    prevent_destroy = true
    ignore_changes = true
  }
}

output "us-east-1-frontend-ips" {
  value = "${aws_instance.us-east-1-frontend.*.public_ip}"
}

output "us-east-1-backend-ips" {
  value = "${aws_instance.us-east-1-backend.*.public_ip}"
}

output "us-west-1-frontend-ips" {
  value = "${aws_instance.us-west-1-frontend.*.public_ip}"
}

output "us-west-1-backend-ips" {
  value = "${aws_instance.us-west-1-backend.*.public_ip}"
}

# terraform init
# terraform apply (create resources)
# terraform output (show our output variables)
# terraform show (render local state)
# terraform destroy (delete everything)
