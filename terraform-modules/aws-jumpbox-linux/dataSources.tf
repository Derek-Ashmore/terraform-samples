/*
 * Data sources needed for aws-jumpbox-linux
 */

data "aws_ami" "linux_ami" {
  most_recent      = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "image-type"
    values = ["machine"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  name_regex = "^amzn-ami-hvm.*"
}

data "aws_subnet" "targetSubnet" {
  id = "${var.subnet_id}"
}
