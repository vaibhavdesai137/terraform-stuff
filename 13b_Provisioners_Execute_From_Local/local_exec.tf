
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

# Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

resource "aws_instance" "myinstance" {
  
  availability_zone      = "${var.us-east-zones[count.index]}"
  ami                    = "ami-2757f631"
  instance_type          = "t2.micro"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.sg-id}"]

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
  }

  # force Terraform to wait until a connection can be made, so that Ansible doesn't fail when trying to provision
  provisioner "remote-exec" {
    inline = [
      "echo Successfully connected"
    ]
  }
}

# Executes commands on endpoint via ansible (local-exec) instead of relying on terraform to do it using remote-exec
# See previous example for remote execution
# 
# Ensure you have ansible installed
# 
# SSH into endpoint and verify the copy was successful
#
# Change permissions on .pem file before SSHing because private keys must be readable only by the owner
# chmod 400 ~/.ssh/vaibhavdesai137-aws.pem 
#
# ssh -i ~/.ssh/vaibhavdesai137-aws.pem ubuntu@
#
# ubuntu@ip-172-31-75-151:~$ 
# ubuntu@ip-172-31-75-151:~$ cat /tmp/test.txt 
# FOO BAR
# ubuntu@ip-172-31-75-151:~$ 
#
resource "null_resource" "ansible-main" {
  
  provisioner "local-exec" {
    command = "ansible-playbook -e sshKey=${var.pvt_key} -i '${aws_instance.myinstance.public_ip},' ./ansible/playbook.yaml -vvvv"
  }

  depends_on = ["aws_instance.myinstance"]
}
