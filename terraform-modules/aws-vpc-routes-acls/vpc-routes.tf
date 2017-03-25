/*
 * Define the Internet Gateway, Route table, and associate all subnets for a new VPC.
 */

 provider "aws" {
   access_key = "${var.aws_key}"
   secret_key = "${var.aws_secret_key}"
   region     = "${var.aws_region}"
 }

# Defines an internet gateway for the VPC so that instances can make internet calls.
resource "aws_internet_gateway" "internetGateway" {
    vpc_id = "${data.aws_vpc.targetVpc.id}"
    tags {
        Name = "${data.aws_vpc.targetVpc.tags.Name}.internetGateway"
    }
}

# Elastic IP for nat gateway
resource "aws_eip" "natElasticIp" {
  vpc      = true
}

resource "aws_nat_gateway" "natGateway" {
  allocation_id = "${aws_eip.natElasticIp.id}"
  subnet_id  = "${data.aws_subnet.publicSubnet0.id}"
  depends_on = ["aws_internet_gateway.internetGateway"]
}

# Define new main Route table.
resource "aws_route_table" "mainRouteTable" {
    vpc_id = "${data.aws_vpc.targetVpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.natGateway.id}"
    }
    tags {
        Name = "${data.aws_vpc.targetVpc.tags.Name}.mainRouteTable"
    }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = "${data.aws_vpc.targetVpc.id}"
  route_table_id = "${aws_route_table.mainRouteTable.id}"
}

# Define Route table for public subnets to properly route internet traffic.
resource "aws_route_table" "publicSubnetsRouteTable" {
    vpc_id = "${data.aws_vpc.targetVpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.internetGateway.id}"
    }
    tags {
        Name = "${data.aws_vpc.targetVpc.tags.Name}.publicSubnetsRouteTable"
    }
}

# Associate the route table to public subnets.
resource "aws_route_table_association" "publicRouteTableAssociation" {
  count = 3  # Boo!  The 'length' interpolation doesn't work with 'data' variables. Had the list been a 'var', it would have.
  subnet_id = "${element(list(data.aws_subnet.publicSubnet0.id, data.aws_subnet.publicSubnet1.id, data.aws_subnet.publicSubnet2.id), count.index)}"
  route_table_id = "${aws_route_table.publicSubnetsRouteTable.id}"
}
