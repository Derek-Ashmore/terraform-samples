
provider "aws" {
  access_key = "${var.aws_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "newVPC" {
    cidr_block = "${var.cidr_block_prefix}.0.0${var.cidr_block_vpc_suffix}"

    tags {
        Name = "${var.vpc_name}"
    }
}

resource "aws_subnet" "primary" {
  count = 3
  vpc_id = "${aws_vpc.newVPC.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "${var.cidr_block_prefix}${var.cidr_block_public_subnet_segment_suffix_list[count.index]}"

  tags {
      Name = "${var.vpc_name}.primary${count.index}"
  }
}

resource "aws_subnet" "dmz" {
  count = 3
  vpc_id = "${aws_vpc.newVPC.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "${var.cidr_block_prefix}${var.cidr_block_dmz_subnet_segment_suffix_list[count.index]}"

  tags {
      Name = "${var.vpc_name}.dmz${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = 3
  vpc_id = "${aws_vpc.newVPC.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "${var.cidr_block_prefix}${var.cidr_block_private_subnet_segment_suffix_list[count.index]}"

  tags {
      Name = "${var.vpc_name}.private${count.index}"
  }
}
