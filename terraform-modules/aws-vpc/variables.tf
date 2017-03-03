/*
 * Variables defined for the aws-vpc module.
 */

variable "aws_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
	default = "us-east-1"
}
variable "vpc_name" {
	description = "Name of the VPC"
}
variable "cidr_block_prefix" {
	description = "CIDR block prefix (two nodes) used by the VPC"
	default = "10.0"
}
variable "cidr_block_vpc_suffix" {
	description = "CIDR block suffix (including slash) used by the VPC"
	default = "/16"
}

variable "cidr_block_public_subnet_segment_suffix_list" {
  type    = "list"
	description = "CIDR block suffix (two nodes plus slash) for individual public subnets"
  default = [".248.0/22", ".244.0/22", ".240.0/22"]
}

variable "cidr_block_dmz_subnet_segment_suffix_list" {
  type    = "list"
	description = "CIDR block suffix (two nodes plus slash) for individual dmz subnets"
  default = [".96.0/19", ".128.0/19", ".160.0/19"]
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
