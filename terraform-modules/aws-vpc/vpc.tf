
provider "aws" {
  access_key = "${var.aws_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

data "aws_availability_zones" "available" {}

# Define VPC
resource "aws_vpc" "newVPC" {
    cidr_block = "${var.cidr_block_prefix}.0.0${var.cidr_block_vpc_suffix}"

    tags {
        Name = "${var.vpc_name}"
    }
}

# Defines an internet gateway for the VPC so that instances can make internet calls.
resource "aws_internet_gateway" "internetGateway" {
    vpc_id = "${aws_vpc.newVPC.id}"
    tags {
        Name = "${var.vpc_name}.internetGateway"
    }
}

# Define Route table for all subnets to properly route internet traffic.
resource "aws_route_table" "allSubnetsRouteTable" {
    vpc_id = "${aws_vpc.newVPC.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.internetGateway.id}"
    }
    tags {
        Name = "${var.vpc_name}.allSubnetsRouteTable"
    }
}

# Define three public subnets across different avaialbility zones. Firewalls go here.
# Public traffic allowed in; firewall determines/logs what passes beyond.
resource "aws_subnet" "public" {
  count = 3
  vpc_id = "${aws_vpc.newVPC.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "${var.cidr_block_prefix}${var.cidr_block_public_subnet_segment_suffix_list[count.index]}"

  tags {
      Name = "${var.vpc_name}.public${count.index}"
  }
}

# Define three DMZ subnets across different availability zones.  Application server type instances go here
# Resources here can only be accessed from public and dmz subnets.
resource "aws_subnet" "dmz" {
  count = 3
  vpc_id = "${aws_vpc.newVPC.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "${var.cidr_block_prefix}${var.cidr_block_dmz_subnet_segment_suffix_list[count.index]}"

  tags {
      Name = "${var.vpc_name}.dmz${count.index}"
  }
}

# Define three private subnets across different availability zones. Database servers and other private resources go here.
# Resources here can only be accessed from dmz and private subnets.
resource "aws_subnet" "private" {
  count = 3
  vpc_id = "${aws_vpc.newVPC.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "${var.cidr_block_prefix}${var.cidr_block_private_subnet_segment_suffix_list[count.index]}"

  tags {
      Name = "${var.vpc_name}.private${count.index}"
  }
}

data "aws_subnet" "subnets" {
  vpc_id = "${aws_vpc.newVPC.id}"
}

# Associate the route table to all subnets.
resource "aws_route_table_association" "routeTableAssociation" {
  count = 9  # Boo!  The 'length' interpolation doesn't work with 'data' variables. Had the list been a 'var', it would have.
  subnet_id = "${element(data.aws_subnet.subnets.id, count.index)}"
  route_table_id = "${aws_route_table.allSubnetsRouteTable.id}"
}
