/*
 * Variables defined for the aws-jumpbox-linux module.
 */

variable "aws_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
	default = "us-east-1"
}

variable "instance_name" {
	default = "Jump Box"
}
variable "subnet_id" {
	description = "Subnet where the jump box will be placed"
}
variable "key_pair" {
	description = "Key pair to use when launching instance"
}
variable "assignPublicIp" {
	description = "should a public IP be associated to the jump box (True / False)"
	default = "False"
}
