
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myinstance" {
  
  availability_zone      = "${var.us-east-zones[count.index]}"
  ami                    = "ami-66506c1c"
  instance_type          = "t2.micro"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.sg-id}"]

  lifecycle {
    create_before_destroy = true
  }

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
  }

  # Copy from local to ec2
  provisioner "file" {
    source      = "./test"
    destination = "~/"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ~/test",
      "cat a.txt",
      "cat b.txt"
    ]
  }
}
