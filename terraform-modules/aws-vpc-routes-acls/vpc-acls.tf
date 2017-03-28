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
}

resource "aws_network_acl_rule" "privateSubnetsNetworkACLRuleStandardEgress" {
  network_acl_id = "${aws_network_acl.privateSubnetsNetworkACL.id}"
  rule_number = 100
  egress = true
  rule_action = "allow"
  cidr_block =  "0.0.0.0/0"
  protocol = "all"
}

resource "aws_network_acl_rule" "privateSubnetsNetworkACLRuleDefaultIngress" {
  network_acl_id = "${aws_network_acl.privateSubnetsNetworkACL.id}"
  rule_number = 900
  egress = false
  rule_action = "allow"
  cidr_block =  "0.0.0.0/0"
  protocol = "all"
}

# Deny direct access to private subnets from public subnets.
resource "aws_network_acl_rule" "privateSubnetsNetworkACLRules" {
  network_acl_id = "${aws_network_acl.privateSubnetsNetworkACL.id}"
  count = "${length(var.cidr_block_public_subnets)}"
  rule_number = "2${count.index}0"
  egress = false
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "${var.cidr_block_public_subnets[count.index]}"
  from_port = 0
  to_port = 16384
}

# Define Network Acl for DMZ subnets
resource "aws_network_acl" "dmzSubnetsNetworkACL" {
  vpc_id = "${data.aws_vpc.targetVpc.id}"
  subnet_ids = ["${list(data.aws_subnet.dmzSubnet0.id, data.aws_subnet.dmzSubnet1.id, data.aws_subnet.dmzSubnet2.id)}"]
  tags {
      Name = "${data.aws_vpc.targetVpc.tags.Name}.DmzSubnetsNetworkACL"
      Scope = "DMZ"
  }

}

resource "aws_network_acl_rule" "dmzSubnetsNetworkACLRuleStandardEgress" {
  network_acl_id = "${aws_network_acl.dmzSubnetsNetworkACL.id}"
  rule_number = 100
  egress = true
  rule_action = "allow"
  cidr_block =  "0.0.0.0/0"
  protocol = "all"
}

resource "aws_network_acl_rule" "dmzSubnetsNetworkACLRuleDefaultIngress" {
  network_acl_id = "${aws_network_acl.dmzSubnetsNetworkACL.id}"
  rule_number = 900
  egress = false
  rule_action = "allow"
  cidr_block =  "0.0.0.0/0"
  protocol = "all"
}

# Deny direct access to DMZ subnets from private subnets.
resource "aws_network_acl_rule" "dmzSubnetsNetworkACLRules" {
  network_acl_id = "${aws_network_acl.dmzSubnetsNetworkACL.id}"
  count = "${length(var.cidr_block_private_subnets)}"
  rule_number = "2${count.index}0"
  egress = false
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "${var.cidr_block_private_subnets[count.index]}"
  from_port = 0
  to_port = 16384
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
    to_port = 0
  }

  # Allow all inbound traffic from Everywhere
  ingress {
    protocol = "all"
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
}
