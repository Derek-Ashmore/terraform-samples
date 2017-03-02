# Test for aws-vpc module

variable "aws_key" {}
variable "aws_secret_key" {}

module "aws-vpc" {
  source  = "../../terraform-modules/aws-vpc"
  aws_key = "${var.aws_key}"
  aws_secret_key = "${var.aws_secret_key}"
  vpc_name = "TerraformVPC"
}
