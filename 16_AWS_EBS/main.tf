
provider "aws" {
  region = "us-east-1"
}

# Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

// Create a dummy instance
resource "aws_instance" "myinstance" {
  availability_zone = "us-east-1a"
  ami               = "ami-2757f631"
  instance_type     = "t2.micro"
  tags = {
    Name = "myinstance"
  }
}

// Create a dummy volume
// Needs to be in same AZ as the instance
resource "aws_ebs_volume" "myebs" {
  availability_zone = "us-east-1a"
  size              = 200
}

// Attach the new volume to the newly created instance
// At this point, the instance should have two volumes assciated with it:
// 1. the default one that AWS have when creating the instance
// 2. the one that we explcitly attached
resource "aws_volume_attachment" "myattachment" {
  device_name = "/dev/sdh"
  instance_id = "${aws_instance.myinstance.id}"
  volume_id   = "${aws_ebs_volume.myebs.id}"
}
