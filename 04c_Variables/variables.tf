
#
# CURRENT TERRAFORM VERSION SEEMS TO HAVE BROKEN THE ENV VAR READING
#
# Uses env var to for variables
# Will create once instance each in "us-east-1e" and "us-east-1f"
#

provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
}

# will be set by env var TF_VAR_zones  
variable "zones" { }

resource "aws_instance" "myinstance" {
  count                 = 2
  availability_zone     = "${var.zones[count.index]}"
  ami                   = "ami-2757f631"
  instance_type         = "t2.micro"
}

# terraform init
# TV_VAR_zones='["us-east-1e", "us-west-1f"]' terraform apply (create resources)
# terraform show (render local state)
# terraform destroy (delete everything)
