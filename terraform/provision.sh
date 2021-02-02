#!/bin/bash
cd "$(dirname "$0")"

shopt -s expand_aliases
alias terraform="docker run -it --rm -v '$(pwd):$(pwd)' -w '$(pwd)' hashicorp/terraform:light"

terraform init

terraform apply --auto-approve
