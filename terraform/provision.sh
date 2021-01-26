#!/bin/bash
cd "$(dirname "$0")"

alias terraform="docker run -it --rm -v '$(pwd):$(pwd)' -w '$(pwd)' hashicorp/terraform:light"

terraform init

terraform apply --auto-approve
