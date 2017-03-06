# Module aws-vpc

This module creates a VPC in a specified region with the following nine subnets:

* Public subnets (across three availability zones)
* DMZ subnets (across three availability zones)
* Private subnets (across three availability zones)

## Public Subnets

Public subnets are for VMs that are exposed publicly through the internet.  Firewalls go here.

VMs in public subnets can access other VMs in any of the other Public or DMZ subnets.

Public subnets are tagged with "Scope=Public".

## DMZ Subnets

DMZ subnets are for VMs such as application servers and utility VMs (e.g. Ansible,
Jump Box VMs, Log Management, etc).

VMs in DMZ subnets can access other VMs in any of the other DMZ or Private subnets.

Public subnets are tagged with "Scope=DMZ".

## Private Subnets

Private subnets are for VMs with guarded data such as database servers and AMQP servers.

VMs in Private subnets can access other VMs in any of the other Private subnets.

Public subnets are tagged with "Scope=Private".
