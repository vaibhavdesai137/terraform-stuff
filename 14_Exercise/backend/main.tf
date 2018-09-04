
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

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file(var.private_key)}"
  }

  # force Terraform to wait until a connection can be made, so that Ansible doesn't fail when trying to provision
  provisioner "remote-exec" {
    inline = [
      "echo Successfully connected"
    ]
  }
}

resource "null_resource" "ansible-main" {
  
  provisioner "local-exec" {
    command = "ansible-playbook -e sshKey=${var.private_key} -i '${aws_instance.instance.public_ip},' ./ansible/playbook.yaml -vvvv"
  }

  depends_on = ["aws_instance.instance"]
}
