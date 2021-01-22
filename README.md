Using AWX Version 15.0.0 because of known inventory input issue: https://github.com/ansible/awx/issues/9043

cat ~/.ssh/id_rsa | pbcopy

Create Machine Type Credential, paste in private key and put user centos

Create Project for CP-Ansible

Create Project for Inventory

Create Job under cp-ansible project, selecting the credential and inventory


Theres no reason these steps should be manual. Use Config as Code: track this project https://github.com/Tompage1994/ansible-tower-manage
