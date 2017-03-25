/*
 * Variables defined for the aws-vpc-routes-acls module.
 */

variable "aws_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
	default = "us-east-1"
}
/*variable "vpc_id" {
	description = "ID of the VPC that will be outfitted with Routes and Network ACLs"
}*/
variable "vpc_name" {
	description = "Unique name of the VPC that will be outfitted with Routes and Network ACLs"
}

variable "cidr_block_private_subnets" {
  type    = "list"
	description = "CIDR blocks of Private subnets"
  default = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
}

variable "cidr_block_public_subnets" {
  type    = "list"
	description = "CIDR blocks of Public subnets"
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
