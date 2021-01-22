Using AWX Version 15.0.0 because of known inventory input issue: https://github.com/ansible/awx/issues/9043


get the tower cli better for automation
https://docs.ansible.com/ansible-tower/latest/html/towercli/examples.html

# Create cp-ansible project

awx --conf.host http://localhost \
    --conf.username admin \
    --conf.password password \
    projects create --wait \
    --organization Default --name='CP-Ansible 2' \
    --scm_type git --scm_branch='6.0.1-post' \
    --scm_url 'https://github.com/confluentinc/cp-ansible' \
    -f human

# Create inventory project

awx --conf.host http://localhost \
    --conf.username admin \
    --conf.password password \
    projects create --wait \
    --organization Default --name='Infra 2' \
    --scm_type git --scm_branch='master' \
    --scm_url 'https://github.com/domenicbove/tower-blog' \
    -f human

# Create credential

awx --conf.host http://localhost \
    --conf.username admin \
    --conf.password password \
    credentials create --credential_type 'Machine' \
    --name 'AWS Key' --organization Default \
    --inputs '{"username": "centos", "ssh_key_data": "@~/.ssh/id_rsa"}'

# Create job template

awx job_templates create \
    --name='Deploy on AWS' --project 'CP-Ansible 2' \
    --playbook all.yml --inventory 'Infra 2' \
    -f human

# Run job
awx job_templates launch 'Deploy on AWS' --monitor -f human
