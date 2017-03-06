# Module aws-vpc-routes-acls

This module creates route tables and network acls for a VPC created with module [aws-vpc](../aws-vpc/README.md).

This VPC is also outfitted with an Internet Gateway and needed routes to use it.

## Prerequisites
* Module ```aws-vpc``` must be applied before this module will work.
* You must know the ID of the VPC that will be modified by this module.
