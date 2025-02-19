#!/bin/bash

if [ "$1" != "dev" ] && [ "$1" != "demo" ]; then
  echo "Usage: $0 {dev|demo}"
  exit 1
fi

echo "Deploying to $1 account..."
terraform init
terraform apply -var-file="$1.tfvars" -auto-approve
