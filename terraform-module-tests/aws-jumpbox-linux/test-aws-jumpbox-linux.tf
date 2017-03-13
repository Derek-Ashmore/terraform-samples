# Test for aws-jumpbox-linux module

variable "aws_region" {
	default = "us-east-1"
}
variable "aws_key" {}
variable "aws_secret_key" {}
variable "subnet_id" {
	description = "The subnet that the instance will be started in"
	default = "subnet-4351666e"
}

variable "key_pair" {
	description = "Key Pair to use when launching instance"
	default = "TerraformKeyPair"
}

provider "aws" {
  access_key = "${var.aws_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

module "aws-jumpbox-linux" {
  source  = "../../terraform-modules/aws-jumpbox-linux"
  aws_key = "${var.aws_key}"
  aws_secret_key = "${var.aws_secret_key}"
  subnet_id = "${var.subnet_id}"
  key_pair = "${var.key_pair}"
	assignPublicIp = "True"
}
