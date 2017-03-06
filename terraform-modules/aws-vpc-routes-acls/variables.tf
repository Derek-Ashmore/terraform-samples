/*
 * Variables defined for the aws-vpc-routes-acls module.
 */

variable "aws_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
	default = "us-east-1"
}
variable "vpc_id" {
	description = "ID of the VPC that will be outfitted with Routes and Network ACLs"
}

variable "cidr_block_dmz_subnet_allowed_ingress_cidr_list" {
  type    = "list"
	description = "CIDR blocks allowed into DMZ subnets"
  default = ["10.0.96.0/19", "10.0.128.0/18", "10.0.240.0/21", "10.0.248.0/22"]
}

variable "cidr_block_private_subnet_segment_suffix_list" {
  type    = "list"
	description = "CIDR block suffix (two nodes plus slash) for individual private subnets"
  default = [".0.0/19", ".32.0/19", ".64.0/19"]
}

variable "cidr_block_private_subnet_allowed_ingress_cidr_list" {
  type    = "list"
	description = "CIDR blocks allowed into Private subnets"
  default = ["10.0.0.0/17", "10.0.128.0/18"]
}
