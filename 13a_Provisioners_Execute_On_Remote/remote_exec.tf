
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

  # Executes locally on endpoint
  # SSH into endpoint and verify the copy was successful
  #
  # Change permissions on .pem file before SSHing because private keys must be readable only by the owner
  # chmod 400 ~/.ssh/vaibhavdesai137-aws.pem 
  #
  # ssh -i ~/.ssh/vaibhavdesai137-aws.pem ubuntu@18.232.145.231
  #
  # ubuntu@ip-172-31-73-142:~$ 
  # ubuntu@ip-172-31-73-142:~$ ls -l
  # total 12
  # -rw-rw-r-- 1 ubuntu ubuntu    8 Aug 15 05:36 a.copy
  # -rw-rw-r-- 1 ubuntu ubuntu    8 Aug 15 05:36 b.copy
  # drwxr-xr-x 2 ubuntu ubuntu 4096 Aug 15 05:36 test
  # ubuntu@ip-172-31-73-142:~$
  # 

  provisioner "remote-exec" {
    inline = [
      "cd ~/test",
      "cat a.txt >> ~/a.copy",
      "cat b.txt >> ~/b.copy"
    ]
  }
}

output "public-ip" {
  value = "${aws_instance.myinstance.public_ip}"
}
