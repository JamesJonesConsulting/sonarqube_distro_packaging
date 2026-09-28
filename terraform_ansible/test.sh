#!/usr/bin/env bash

terraform init
terraform plan -out=tfplan
terraform apply tfplan 
terraform apply -invoke=action.ansible_playbook_run.with_inventory_files
