
#
# Uses a separate file for variables (when explicitly passed from command line and IGNORE THE LOCAL VARIABLE)
# Will create once instance each in "us-east-1c" and "us-east-1d"
#

provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
}

variable "zones" {
  type    = "list"
  default = ["us-east-1a", "us-east-1b"]
}

resource "aws_instance" "myinstance" {
  count                 = 2
  availability_zone     = "${var.zones[count.index]}"
  ami                   = "ami-2757f631"
  instance_type         = "t2.micro"
}

# terraform init
# terraform apply -var-file=zones.tfvars (create resources and use a separate var file)
# terraform show (render local state)
# terraform destroy (delete everything)
