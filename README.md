Using AWX Version 15.0.0 because of known inventory input issue: https://github.com/ansible/awx/issues/9043


get the tower cli better for automation
https://docs.ansible.com/ansible-tower/latest/html/towercli/examples.html

https://docs.ansible.com/ansible-tower/latest/html/towercli/usage.html#installation

export TOWER_HOST=http://localhost
export TOWER_USERNAME=admin
export TOWER_PASSWORD=password


# Create cp-ansible project

awx projects create --wait \
    --organization Default --name='CP-Ansible' \
    --scm_type git --scm_branch='6.0.1-post' \
    --scm_url 'https://github.com/confluentinc/cp-ansible' \
    -f human

# Create inventory project

awx projects create --wait \
    --organization Default --name='AWS Infrastructure' \
    --scm_type git --scm_branch='master' \
    --scm_url 'https://github.com/domenicbove/tower-blog' \
    -f human

# Create inventory

awx inventory create \
    --organization Default --name='AWS Infrastructure'

# Create Inventory source

awx inventory_sources create \
    --name='AWS Infrastructure' \
    --inventory='AWS Infrastructure' \
    --source_project='AWS Infrastructure' \
    --source scm \
    --source_path='terraform/hosts.yml' \
    --update_on_project_update true

# Create credential

awx credentials create --credential_type 'Machine' \
    --name 'AWS Key' --organization Default \
    --inputs '{"username": "centos", "ssh_key_data": "@~/.ssh/id_rsa"}'

# Create job template

awx job_templates create \
    --name='Deploy on AWS' --project 'CP-Ansible' \
    --playbook all.yml --inventory 'AWS Infrastructure' \
    --credentials 'AWS Key'

# Add Credential to Job
awx job_template associate \
    --credential 'AWS Key' 'Deploy on AWS'

# Run job
awx job_templates launch 'Deploy on AWS' --monitor
