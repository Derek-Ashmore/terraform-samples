/*
 * Sample creates an instance in AWS.
 */

variable "aws_region" {
	default = "us-east-1"
}
variable "aws_key" {}
variable "aws_secret_key" {}
variable "subnet_id" {
	description = "The subnet that the instance will be started in"
}
variable "instance_name" {
	description = "The name of the instance"
}

provider "aws" {
  access_key = "${var.aws_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "example" {
  ami           = "ami-0d729a60"
  instance_type = "t2.micro"
  subnet_id  = "${var.subnet_id}"

  tags {
    "Name" = "${var.instance_name}"
  }
}
