# Test for aws-vpc-routes-acls module

variable "aws_key" {}
variable "aws_secret_key" {}

variable "vpc_id" {
	description = "ID of the VPC that will be outfitted with Routes and Network ACLs"
}

module "aws-vpc-routes-acls" {
  source  = "../../terraform-modules/aws-vpc-routes-acls"
  aws_key = "${var.aws_key}"
  aws_secret_key = "${var.aws_secret_key}"
  vpc_id = "${var.vpc_id}"
}
