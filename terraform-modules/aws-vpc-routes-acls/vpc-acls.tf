/*
 * Define standard network ACLs for all subnets for a new VPC.
 */

# Define Network Acl for private subnets
resource "aws_network_acl" "privateSubnetsNetworkACL" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  subnet_ids = ["${list(data.aws_subnet.privateSubnet0.id, data.aws_subnet.privateSubnet1.id, data.aws_subnet.privateSubnet2.id)}"]
  tags {
      Name = "${data.aws_vpc.targetVpc.tags.Name}.privateSubnetsNetworkACL"
      Scope = "Private"
  }

  # Allow outbound traffic everywhere
  egress {
    protocol = "all"
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 65535
  }

  # Deny all inbound traffic **NOT** from other private/DMZ subnets (10.0.0.0 - 10.0.191.255)
  ingress {
    protocol = "all"
    rule_no = 900
    action = "deny"
    cidr_block =  "0.0.0.0/16"
    from_port = 0
    to_port = 65535
  }
}

# Create ACL rules for private Subnet CIDR blocks.  Standard ACL rules with privateSubnetsNetworkACL.
resource "aws_network_acl_rule" "privateSubnetsNetworkACLRules" {
  network_acl_id = "${aws_network_acl.privateSubnetsNetworkACL.id}"
  count = "${length(var.cidr_block_private_subnet_allowed_ingress_cidr_list)}"
  rule_number = "2${count.index}0"
  egress = false
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "${var.cidr_block_private_subnet_allowed_ingress_cidr_list[count.index]}"
  from_port = 0
  to_port = 65535
}

# Define Network Acl for DMZ subnets
resource "aws_network_acl" "dmzSubnetsNetworkACL" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  subnet_ids = ["${list(data.aws_subnet.dmzSubnet0.id, data.aws_subnet.dmzSubnet1.id, data.aws_subnet.dmzSubnet2.id)}"]
  tags {
      Name = "${data.aws_vpc.targetVpc.tags.Name}.DmzSubnetsNetworkACL"
      Scope = "DMZ"
  }

  # Allow outbound traffic everywhere
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

  # Deny all inbound traffic **NOT** from other DMZ/Public subnets (10.0.96.0 - 10.0.191.255, 10.0.240.0 - 10.0.251.255)
  ingress {
    protocol = "all"
    rule_no = 900
    action = "deny"
    cidr_block =  "0.0.0.0/16"
    from_port = 0
    to_port = 65535
  }
}

# Create ACL rules for DMZ Subnet CIDR blocks.  Standard ACL rules with dmzSubnetsNetworkACL.
resource "aws_network_acl_rule" "dmzSubnetsNetworkACLRules" {
  network_acl_id = "${aws_network_acl.dmzSubnetsNetworkACL.id}"
  count = "${length(var.cidr_block_dmz_subnet_allowed_ingress_cidr_list)}"
  rule_number = "2${count.index}0"
  egress = false
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "${var.cidr_block_dmz_subnet_allowed_ingress_cidr_list[count.index]}"
  from_port = 0
  to_port = 65535
}

# Define Network Acl for Public subnets
resource "aws_network_acl" "publicSubnetsNetworkACL" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  subnet_ids = ["${list(data.aws_subnet.publicSubnet0.id, data.aws_subnet.publicSubnet1.id, data.aws_subnet.publicSubnet2.id)}"]
  tags {
      Name = "${data.aws_vpc.targetVpc.tags.Name}.PublicSubnetsNetworkACL"
      Scope = "Public"
  }

  # Allow outbound traffic everywhere
  egress {
    protocol = "all"
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 65535
  }

  # Allow all inbound traffic from Everywhere
  ingress {
    protocol = "all"
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 65535
  }
}
