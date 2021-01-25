#!/bin/bash
echo "______Build AWX CLI Docker Image________"
docker build . -t localhost/awx:latest

alias awx="docker run --rm -it --env TOWER_HOST=http://localhost:8052 --env TOWER_USERNAME=admin --env TOWER_PASSWORD=password localhost/awx:latest awx"

echo "______Create Default Organization________"
awx organizations create --name Default

echo "______Create cp-ansible project________"
awx projects create --wait \
    --organization Default --name='CP-Ansible' \
    --scm_type git --scm_branch='6.0.1-post' \
    --scm_url 'https://github.com/confluentinc/cp-ansible' \
    -f human

echo "______Create inventory project________"
awx projects create --wait \
    --organization Default --name='AWS Infrastructure' \
    --scm_type git --scm_branch='master' \
    --scm_url 'https://github.com/domenicbove/tower-blog' \
    -f human

echo "______Create Inventory________"
awx inventory create \
    --organization Default --name='AWS Infrastructure'

echo "______Create Inventory Source from Inventory Project________"
awx inventory_sources create \
    --name='AWS Infrastructure' \
    --inventory='AWS Infrastructure' \
    --source_project='AWS Infrastructure' \
    --source scm \
    --source_path='terraform/hosts.yml' \
    --update_on_project_update true

echo "______Create Machine Credential from SSH Key____________"
awx credentials create --credential_type 'Machine' \
    --name 'AWS Key' --organization Default \
    --inputs '{"username": "centos", "ssh_key_data": "@~/.ssh/id_rsa"}'

echo "______Create Deployment Job____________"
awx job_templates create \
    --name='Deploy on AWS' --project 'CP-Ansible' \
    --playbook all.yml --inventory 'AWS Infrastructure' \
    --credentials 'AWS Key'

echo "______Create Credential to Job____________"
awx job_template associate \
    --credential 'AWS Key' 'Deploy on AWS'

# Run job
# awx job_templates launch 'Deploy on AWS' --monitor
