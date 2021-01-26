start-tower:
	awx/start_tower.sh

create-tower-job:
	awx/create_tower_job.sh

stop-tower:
	awx/stop_tower.sh

create-infra:
	terraform/provision.sh

destroy-infra:
	cd terraform && docker run -it --rm -v '$(pwd):$(pwd)' -w '$(pwd)' hashicorp/terraform:light destroy --auto-approve 
