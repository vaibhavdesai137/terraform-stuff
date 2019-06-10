
//
// THIS DOES NOT WORK. AWS's ELB MODULES ARE NOT UPDATED YET TO SUPPORT TERRAFORM VERSION v0.12.
//
// Running this with terraform v0.11 creates the ELBs successfully
//

provider "aws" {
  region = "us-east-1"
}

// Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

// Fetch all VPCs and get the default one
data "aws_vpc" "default" {
  default = true
}

// Fetch all subnets for our vpc
data "aws_subnet_ids" "subnets" {
  vpc_id = "${data.aws_vpc.default.id}"
}

// Fetch the default sg associated with our vpc
data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

variable "instance_count" {
  default     = 2
}

// Dummy instances to add to ELB later
resource "aws_instance" "myinstance" {
  availability_zone = "us-east-1a"
  ami               = "ami-2757f631"
  instance_type     = "t2.micro"
  count             = 2
  tags = {
    Name = "myinstance"
  }
}

// 
// Classic ELB
//
resource "aws_elb" "my_classic_elb" {
  
  name               = "my-classic-elb"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }

  instances                   = ["${aws_instance.myinstance.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    name = "my-classic-elb"
  }
}

//
// Application ELB
// 

// Create a new target group
resource "aws_lb_target_group" "my_targetgroup" {
  name     = "my-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.default.id}"
}

// Attach the ec2 instances to the target group on port 80
resource "aws_lb_target_group_attachment" "my_targetgroup_attachment_1" {
  target_group_arn = "${aws_lb_target_group.my_targetgroup.arn}"
  target_id        = "${element(aws_instance.myinstance.*.id, 0)}"
  port             = 80
}
resource "aws_lb_target_group_attachment" "my_targetgroup_attachment_2" {
  target_group_arn = "${aws_lb_target_group.my_targetgroup.arn}"
  target_id        = "${element(aws_instance.myinstance.*.id, 1)}"
  port             = 80
}

// Create the application ELB
resource "aws_lb" "my_app_elb" {
  
  name               = "my-app-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${data.aws_security_group.default.id}"]

  subnets = ["${data.aws_subnet_ids.subnets.ids}"]

  enable_deletion_protection = false

  tags {
    env = "prod"
  }
}

// Associate the target group to the ELB
resource "aws_lb_listener" "front_end" {
  
  load_balancer_arn = "${aws_lb.my_app_elb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.my_targetgroup.arn}"
    type             = "forward"
  }
}

