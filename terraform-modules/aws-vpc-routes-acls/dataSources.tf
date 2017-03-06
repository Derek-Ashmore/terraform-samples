/*
 * Data sources needed for aws=vpc-routes-acls
 */

data "aws_vpc" "targetVpc" {
   id = "${var.vpc_id}"
}

####  We desparately need a 'aws-subnets' (plural) data source. This ugliness
####  could have been avoided with such a creature.

# Find all DMZ subnets
data "aws_subnet" "dmzSubnet0" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  filter {
    name = "tag:Name"
    values = ["${data.aws_vpc.targetVpc.tags.Name}.dmz0"]
  }
}
data "aws_subnet" "dmzSubnet1" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  filter {
    name = "tag:Name"
    values = ["${data.aws_vpc.targetVpc.tags.Name}.dmz1"]
  }
}
data "aws_subnet" "dmzSubnet2" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  filter {
    name = "tag:Name"
    values = ["${data.aws_vpc.targetVpc.tags.Name}.dmz2"]
  }
}

# Find all private subnets
data "aws_subnet" "privateSubnet0" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  filter {
    name = "tag:Name"
    values = ["${data.aws_vpc.targetVpc.tags.Name}.private0"]
  }
}
data "aws_subnet" "privateSubnet1" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  filter {
    name = "tag:Name"
    values = ["${data.aws_vpc.targetVpc.tags.Name}.private1"]
  }
}
data "aws_subnet" "privateSubnet2" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  filter {
    name = "tag:Name"
    values = ["${data.aws_vpc.targetVpc.tags.Name}.private2"]
  }
}

# Find all Public subnets
data "aws_subnet" "publicSubnet0" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  filter {
    name = "tag:Name"
    values = ["${data.aws_vpc.targetVpc.tags.Name}.public0"]
  }
}
data "aws_subnet" "publicSubnet1" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  filter {
    name = "tag:Name"
    values = ["${data.aws_vpc.targetVpc.tags.Name}.public1"]
  }
}

data "aws_subnet" "publicSubnet2" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  filter {
    name = "tag:Name"
    values = ["${data.aws_vpc.targetVpc.tags.Name}.public2"]
  }
}
