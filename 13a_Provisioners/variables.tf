
variable "key_name" {
  default = "vaibhav-personal-aws"
}

variable "pvt_key" {
  default = "/home/vaibhav/.ssh/vaibhav-personal-aws.pem"
}

variable "us-east-zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "sg-id" {
  default = "sg-ac02d8d0"
}
