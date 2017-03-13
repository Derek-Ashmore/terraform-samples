# Module aws-jump-box-linux

This module adds a Linux jump box VM for maintenance. The AMI used is the latest Amazon 64-bit, ebs-backed Linux
in your region with a name starting with "amzn-ami-hvm".

This module illustrates searching listed AMIs for the most recent release of a specific type
of image.

Typically, jump box VMs are placed in a DMZ subnet and not directly accessible via the
internet. Usually, you should utilize some type of VPN solution for access to it.
