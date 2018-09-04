
provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" { }

resource "aws_instance" "instance" {
  
  count                   = "${var.number_instances}"
  ami                     = "${var.ami}"
  instance_type           = "t2.micro"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  key_name                = "${var.key_name}"
  vpc_security_group_ids  = ["${var.sg_id}"]

  lifecycle {
    create_before_destroy = true
  }

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file(var.private_key)}"
  }

  # Copy from local to ec2
  provisioner "file" {
    source      = "./test"
    destination = "~/"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ~/test",
      "cat a.txt >> ~/a.copy",
      "cat b.txt >> ~/b.copy"
    ]
  }
}