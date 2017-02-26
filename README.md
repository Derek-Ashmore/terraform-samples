# terraform-samples

This project contains experiments using the Terraform product for scripting infrastructure.

## Useful Discoveries

This section contains useful tidbits of information that are **NOT** well documented in terraform documentation.

### Using environment variables as input to configurations
> All environment variables for Terraform MUST be prefaced by "TF_VAR_"

Terraform will only acknowledge environment variables that following the naming convention TF_VAR_varName.  For example, TF_VAR_aws_key.

> Environment variables are declared and used as normal variables. 

If I set environment variable TF_VAR_aws_key=ASDFDFSASDF, in the Terraform configuration, I must define the variable 
before I can use it.  Any variables without a definition in the environment or declared default will be prompted.

```  
variable "aws_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = "${var.aws_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}
```  

