# terraform-samples

This project contains experiments using the Terraform product for scripting infrastructure.

## Samples

* first-sample -- Simple AWS instance creation

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

### Module Organization

Treat all scripts as modules.

Don't be afraid to layer them with the lowest being the most granular and working up to the entire environment creation.

The outer layer will be environment specific and just be one module call.  This call should specify all needed input so that nothing needs to be entered by the person
executing the script.

### Module not found error

This is a misleading error.  Issue for following command for a clearer error message:

```  
terraform get
```  
