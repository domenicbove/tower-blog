start-tower:
	awx/start_tower.sh

create-tower-job:
	awx/start_tower.sh

stop-tower:
	awx/stop_tower.sh

create-infra:
	terraform/provision.sh
