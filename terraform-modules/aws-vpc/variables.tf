variable "aws_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
	default = "us-east-1"
}
variable "vpc_name" {
	description = "Name of the VPC"
}
variable "cidr_block" {
	description = "CIDR block used by the VPC"
	default = "10.0.0.0/16"
}
