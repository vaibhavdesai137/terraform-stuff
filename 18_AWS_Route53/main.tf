
provider "aws" {
  region = "us-east-1"
}

// Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

// Create a new DNS name
// Will create AWS nameservers
// If bought from somewhere else, set the nameservers accordingly
resource "aws_route53_zone" "primary" {
  name = "my-site.com"
}

// Create a new A record and point one our WEB server IP address to the DNS
resource "aws_route53_record" "web" {
  zone_id   = "${aws_route53_zone.primary.id}"
  name      = "web.my-site.com"
  type      = "A"
  ttl       = "300"
  records   = ["10.10.1.18"]
}

// Create a new A record and point one our MAIL server IP address to the DNS
resource "aws_route53_record" "mail" {
  zone_id   = "${aws_route53_zone.primary.id}"
  name      = "mail.my-site.com"
  type      = "A"
  ttl       = "300"
  records   = ["10.10.1.38"]
}

// You can also create different record types, set name servers, add health checks, etc.
