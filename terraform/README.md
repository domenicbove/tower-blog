# Terraform to support cp-ansible

This repo is meant to help provision infrastructure that can be handed off to cp-ansible. The terraform code is opinionated and far from perfect but runs smoothly (in us-west-2 at least)!

**Dependencies:**

 - Latest version of terraform (0.12+)
 - Ansible version 2.7 or greater

## Instructions

### 1. Set AWS Specific Environment Variables

Set below AWS

```
export AWS_ACCESS_KEY_ID="key"
export AWS_SECRET_ACCESS_KEY="secret"
export TF_VAR_vpc_id=vpc-xxxx
export TF_VAR_subnet=subnet-xxxx
```

### 2. Customize installation by setting variables in variables.tf

All EC2 amis are specific to us-west-2. You can select another region through variables but will need a new ami as well. Examine variables.tf for other customization options.

Terraform will create an ssh key in AWS and give it to your hosts out of your public key found at ~/.ssh/id_rsa.pub If you would like to use a different local key, change this variable: *ssh_key_public_path*. If you would like to use a pre existing key in AWS follow the commented instructions in variables.tf

### 3. Provision Infrastructure

Creating instances takes two commands! Be sure to put your own unique identifier and key pair name to avoid naming collisions.

```
terraform init
terraform apply -var 'unique_identifier=dbove1'
```

### 4. Examine your inventory file (Can be skipped)

Terraform will create you ansible inventory file for you in the file *hosts.yml*. This is the file where you set installation variables. Examine it with:

```
cat hosts.yml
```

### 5. SSH to a host (Can be skipped)

Provided a local ssh key was used in the provisioning, it is very easy to ssh to your hosts. Copy a public hostname from the hosts.yml and run:

```
ssh centos@<public hostname>
```

### 6. Install Confluent Platform

Using the generated *hosts.yml* file, you can very easily install all the components by running:

```
cd /path/to/cp-ansible
ansible-playbook -i /path/to/cp-ansible-tools/terraform/hosts.yml all.yml
```

### 7. View your deployment in the browser!

Copy c3's public hostname from *hosts.yml* and to *https://<public_hostname_of_c3>:9021* in your browser

### 8. Destroy Infrastructure

Don't be ~~wasty~~ and destroy everything that you have deployed, so we do not get billed. To destroy run:

```
cd /path/to/cp-ansible-tools/terraform
terraform destroy --auto-approve
```
