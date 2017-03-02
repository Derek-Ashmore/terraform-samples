# Test for aws-first-sample module

variable "aws_key" {}
variable "aws_secret_key" {}
variable "subnet_id" {
  description = "Surf to the VPC / Subnets portion of your control panel and select a subnet_id (e.g. 'subnet-7fcd5f09') for your instance."
}

module "aws-first-sample" {
  source  = "../../terraform-modules/aws-first-sample"
  aws_key = "${var.aws_key}"
  aws_secret_key = "${var.aws_secret_key}"
  subnet_id = "${var.subnet_id}"
  instance_name = "MyFirstInstance"
}
