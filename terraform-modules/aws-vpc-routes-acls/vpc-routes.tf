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

# Define Route table for all subnets to properly route internet traffic.
resource "aws_route_table" "allSubnetsRouteTable" {
    vpc_id = "${data.aws_vpc.targetVpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.internetGateway.id}"
    }
    tags {
        Name = "${data.aws_vpc.targetVpc.tags.Name}.allSubnetsRouteTable"
    }
}

# Associate the route table to all subnets.
resource "aws_route_table_association" "routeTableAssociation" {
  count = 9  # Boo!  The 'length' interpolation doesn't work with 'data' variables. Had the list been a 'var', it would have.
  subnet_id = "${element(list(data.aws_subnet.privateSubnet0.id, data.aws_subnet.privateSubnet1.id, data.aws_subnet.privateSubnet2.id,data.aws_subnet.dmzSubnet0.id, data.aws_subnet.dmzSubnet1.id, data.aws_subnet.dmzSubnet2.id,data.aws_subnet.publicSubnet0.id, data.aws_subnet.publicSubnet1.id, data.aws_subnet.publicSubnet2.id), count.index)}"
  route_table_id = "${aws_route_table.allSubnetsRouteTable.id}"
}
