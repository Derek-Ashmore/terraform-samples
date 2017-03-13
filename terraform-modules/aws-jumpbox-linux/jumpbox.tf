/*
 *  aws-jumpbox-linux - create an auto-scaled jumpbox set spread across three availability zones
 */

 provider "aws" {
   access_key = "${var.aws_key}"
   secret_key = "${var.aws_secret_key}"
   region     = "${var.aws_region}"
 }

 resource "aws_instance" "jumpBox" {
   ami           = "${data.aws_ami.linux_ami.id}"
   instance_type = "t2.micro"
   subnet_id  = "${var.subnet_id}"
   key_name = "${var.key_pair}"
   associate_public_ip_address = "${var.assignPublicIp}"

   tags {
     "Name" = "${var.instance_name} - ${data.aws_subnet.targetSubnet.tags.Name}"
   }

 }
