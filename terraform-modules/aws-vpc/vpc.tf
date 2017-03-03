/*
 * aws-vpc - Terreform to create and configure an AWS VPC instance.
 *
 * The VPC has nine subnets spread across three availability zones.
 *   public subnets - are accessible from the internet and are designed for firewalls.
 *   dmz subnets - are accessible from public subnets and contains application servers and jump boxes.
 *   private subnets - are accessible from dmz subnets and contain resources like database servers and message queue servers.
 */

provider "aws" {
  access_key = "${var.aws_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

# List of currently defined availability zones in the current region.
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
      Scope = "Public"
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
      Scope = "DMZ"
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
      Scope = "Private"
  }
}

data "aws_subnet" "allSubnets" {
  vpc_id = "${aws_vpc.newVPC.id}"
}

# Associate the route table to all subnets.
resource "aws_route_table_association" "routeTableAssociation" {
  count = 9  # Boo!  The 'length' interpolation doesn't work with 'data' variables. Had the list been a 'var', it would have.
  subnet_id = "${element(data.aws_subnet.allSubnets.id, count.index)}"
  route_table_id = "${aws_route_table.allSubnetsRouteTable.id}"
}

# Find all private subnets
data "aws_subnet" "privateSubnets" {
  vpc_id = "${aws_vpc.newVPC.id}"
  filter {
    name = "tag:Scope"
    values = ["Private"]
  }
}

# Define Network Acl for private subnets
resource "aws_network_acl" "privateSubnetsNetworkACL" {
  vpc_id = "${aws_vpc.newVPC.id}"
  subnet_ids = ["${data.aws_subnet.privateSubnets.id}"]
  tags {
      Name = "${var.vpc_name}.privateSubnetsNetworkACL"
      Scope = "Private"
  }

  egress {
    protocol = "all"
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 65535
  }

  # Part 1: Allow all inbound traffic from other private/DMZ subnets (10.0.0.0 - 10.0.191.255)
  ingress {
    protocol = "all"
    rule_no = 100
    action = "allow"
    cidr_block =  "10.0.0.0/17"
    from_port = 0
    to_port = 65535
  }

  # Part 2: Allow all inbound traffic from other private/DMZ subnets (10.0.0.0 - 10.0.191.255)
  ingress {
    protocol = "all"
    rule_no = 200
    action = "allow"
    cidr_block =  "10.0.128.0/18"
    from_port = 0
    to_port = 65535
  }

  # Deny all inbound traffic **NOT** from other private/DMZ subnets (10.0.0.0 - 10.0.191.255)
  ingress {
    protocol = "all"
    rule_no = 300
    action = "deny"
    cidr_block =  "0.0.0.0/16"
    from_port = 0
    to_port = 65535
  }
}

# Find all DMZ subnets
data "aws_subnet" "dmzSubnets" {
  vpc_id = "${aws_vpc.newVPC.id}"
  filter {
    name = "tag:Scope"
    values = ["DMZ"]
  }
}

# Define Network Acl for DMZ subnets
resource "aws_network_acl" "dmzSubnetsNetworkACL" {
  vpc_id = "${aws_vpc.newVPC.id}"
  subnet_ids = ["${data.aws_subnet.dmzSubnets.id}"]
  tags {
      Name = "${var.vpc_name}.DmzSubnetsNetworkACL"
      Scope = "DMZ"
  }

  egress {
    protocol = "all"
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 65535
  }

  # Part 1: Allow all inbound traffic from DMZ subnets (10.0.96.0 - 10.0.191.255)
  ingress {
    protocol = "all"
    rule_no = 100
    action = "allow"
    cidr_block =  "10.0.96.0/19"
    from_port = 0
    to_port = 65535
  }

  # Part 2: Allow all inbound traffic from DMZ subnets (10.0.96.0 - 10.0.191.255)
  ingress {
    protocol = "all"
    rule_no = 200
    action = "allow"
    cidr_block =  "10.0.128.0/18"
    from_port = 0
    to_port = 65535
  }

  # Part 1: Allow all inbound traffic from Public subnets (10.0.240.0 - 10.0.243.255)
  ingress {
    protocol = "all"
    rule_no = 300
    action = "allow"
    cidr_block =  "10.0.240.0/21"
    from_port = 0
    to_port = 65535
  }

  # Part 2: Allow all inbound traffic from Public subnets (10.0.240.0 - 10.0.243.255)
  ingress {
    protocol = "all"
    rule_no = 400
    action = "allow"
    cidr_block =  "10.0.248.0/22"
    from_port = 0
    to_port = 65535
  }

  # Deny all inbound traffic **NOT** from other DMZ/Public subnets (10.0.96.0 - 10.0.191.255, 10.0.240.0 - 10.0.251.255)
  ingress {
    protocol = "all"
    rule_no = 500
    action = "deny"
    cidr_block =  "0.0.0.0/16"
    from_port = 0
    to_port = 65535
  }
}
