# tf-aws-infra

# AWS Infrastructure Setup Using Terraform

## Prerequisites
Before setting up the infrastructure, ensure you have the following installed:

- [AWS CLI](https://aws.amazon.com/cli/) (Configured with your AWS account)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)

## Step 1: Clone the Repository
```bash
git clone <your-repository-url>
cd <your-repository-name>
```

## Step 2: Configure AWS CLI
Set up AWS CLI profiles if not configured already:
```bash
aws configure --profile dev
aws configure --profile demo
```
## Step 3: Format with Terraform
```bash
terraform fmt
```

## Step 4: Initialize Terraform
```bash
terraform init
```
This command initializes Terraform, downloading required providers and setting up the backend.

## Strp 5: Validate
```bash
terraform validate
```

## Step 6: Plan the Infrastructure Deployment
```bash
terraform plan
```
This command shows the planned changes before applying them.

## Step 7: Apply
Use apply command to create all the resources
```bash
terraform apply -var-file="dev/demo.tfvars"
```

## Step 8: Destroy
Once your work is over, use destroy command to delete all the resources
```bash
terraform destroy -var-file="dev/demo.tfvars"
```

#
