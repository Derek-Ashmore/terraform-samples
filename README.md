# terraform-samples

This project contains experiments using the Terraform product for scripting infrastructure.

## Samples

* terraform-modules\aws-first-sample -- Simple AWS instance creation
* [terraform-modules\aws-vpc](./terraform-modules/aws-vpc) -- Provides a standard VPC with public, dmz, and private subnets spread across three availability zones.
* [terraform-modules\aws-vpc-routes-acls](./terraform-modules/aws-vpc-routes-acls) -- Adds an internet gateway, routes, and network acls for a standard VPC.
* [terraform-modules\aws-jumpbox-linux](./terraform-modules/aws-jumpbox-linux) -- Adds a linux jump-box to the environment.

> Warning:  These scripts create and start cloud resources!  If you're running them to experiment, terminate what you create to conserve costs after you're through.

### Prerequisites

You need the following to run these samples:
* AWS Account with a generated AWS key and secret key and privs to create VPCs, route tables, etc.
* Terraform installed and in your path

### Running the Samples

To start, AWS keys are passed as environment variables.  Before any of these configurations will work,
execute setkeys.sh or setkeys.bat in the same command line you intend to execute Terraform configurations.
these scripts will prompt you for the AWS key and secret key.

Establish a command prompt and make your directory the directory of the module you want to run. Directory
terraform-module-tests contain modules are a convenient way to run the sample modules as they supply inputs automatically
instead of depending on you for manual input.

> Set your directory to terraform-module-tests/aws-first-sample

Execute this command to display the actions Terraform "plans" to take (e.g. create an instance):
```  
terraform plan
```  

Execute this command to affect (e.g. physically create) the displayed changes:
```  
terraform apply
```  

Execute this command to show the displayed changes:
```  
terraform show
```  

Execute this command to terminate/delete the displayed changes:
```  
terraform destroy
```  

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

### Data source references are quirky

> Not all data sources support list returns

Most data sources **require** a unique result or they will error out.  At least with the AWS provider,
those data sources ending in "s" will support multiple object returns while those that don't won't. For
example, 'aws_subnet' requires a unique return while 'aws_availability_zones' will return
a list.

> Data source returns what is physically present, not what's "planned" in your template.

If it doesn't physically exist yet, a data source won't list it.

> An enhancement to provide a 'aws_subnets' (plural) is desperately needed.

Currently, the existing 'aws_subnet' data source only supports **one** return item - not a list.
A lot of code blat in this sample could be avoided with such a creature.

### Module Organization

Use environment specific modules to manage different environments. Leaving module execution relying on manual input
introduces a possibility of error.  In other words, if you've a Terraform configuration that manages VPC creation, have
separate modules for prod, dev, QA, and any of your other environments that execute that VPC configuration.

### Module not found error

This is a misleading error.  Issue for following command for a clearer error message:

```  
terraform get
```  
