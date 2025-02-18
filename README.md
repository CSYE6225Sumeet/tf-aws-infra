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

## Step 3: Initialize Terraform
```bash
terraform init
```
This command initializes Terraform, downloading required providers and setting up the backend.

## Step 4: Plan the Infrastructure Deployment
```bash
terraform plan
```
This command shows the planned changes before applying them.