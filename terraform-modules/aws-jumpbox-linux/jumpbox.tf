/*
 *  aws-jumpbox-linux - create an auto-scaled jumpbox set spread across three availability zones
 */

 provider "aws" {
   access_key = "${var.aws_key}"
   secret_key = "${var.aws_secret_key}"
   region     = "${var.aws_region}"
 }

 resource "aws_security_group" "jumpBoxSecurityGroup" {
  name = "${var.instance_name} - Linux Jump Box Standard"
  description = "Allow ssh and sftp in - anything out"
  vpc_id = "${data.aws_subnet.targetSubnet.vpc_id}"
}

resource "aws_security_group_rule" "allowSsh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.jumpBoxSecurityGroup.id}"
}

resource "aws_security_group_rule" "allowAllEgress" {
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.jumpBoxSecurityGroup.id}"
}

 resource "aws_instance" "jumpBox" {
   ami           = "${data.aws_ami.linux_ami.id}"
   instance_type = "t2.micro"
   subnet_id  = "${var.subnet_id}"
   key_name = "${var.key_pair}"
   associate_public_ip_address = "${var.assignPublicIp}"
   vpc_security_group_ids = ["${aws_security_group.jumpBoxSecurityGroup.id}"]

   tags {
     "Name" = "${var.instance_name} - ${data.aws_subnet.targetSubnet.tags.Name}"
   }

 }
