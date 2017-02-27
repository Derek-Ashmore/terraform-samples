
provider "aws" {
  access_key = "${var.aws_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_vpc" "newVPC" {
    cidr_block = "${var.cidr_block}"

    tags {
        Name = "${var.vpc_name}"
    }
}
