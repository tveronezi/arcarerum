SHELL := /bin/bash

include sample.env
export

ifneq (,$(wildcard .env))
    include .env
    export
endif

# These variables have precedence
ifneq ($(AWS_ACCESS_KEY),)
    export TF_VAR_aws_access_key=$(AWS_ACCESS_KEY)
endif

# These variables have precedence
ifneq ($(AWS_SECRET_ACCESS_KEY),)
    export TF_VAR_aws_secret_key=$(AWS_SECRET_ACCESS_KEY)
endif

# These variables have precedence
ifneq ($(AWS_ACCOUNT_ID),)
    export TF_VAR_aws_account_id=$(AWS_ACCOUNT_ID)
endif

DIRECTORIES := \
	modules/namespaces \
	modules/nextcloud

.PHONY: \
	init \
	apply \
	destroy-nextcloud \
	nextcloud-occ-fixes \
	fmt \
	ci

init:
	@set -e; \
	for dir in $(DIRECTORIES); do \
	  (echo "init terraform in $$dir" && cd $$dir && terraform init -upgrade); \
	done

apply:
	@set -e; \
	for dir in $(DIRECTORIES); do \
	  (echo "apply terraform in $$dir" && cd $$dir && terraform apply -auto-approve); \
	done

## Commented out to avoid accidental destruction! 
# destroy-nextcloud:
# 	@set -e; \
# 	(cd modules/nextcloud && terraform destroy -auto-approve)

scaledown:
	kubectl -n "${TF_VAR_nextcloud_namespace}" scale deployment nextcloud --replicas=0
	kubectl -n "${TF_VAR_nextcloud_namespace}" scale statefulset nextcloud-mariadb --replicas=0

scaleup:
	kubectl -n "${TF_VAR_nextcloud_namespace}" scale deployment nextcloud --replicas=1
	kubectl -n "${TF_VAR_nextcloud_namespace}" scale statefulset nextcloud-mariadb --replicas=1

nextcloud-occ-fixes:
	kubectl -n "${TF_VAR_nextcloud_namespace}" exec -c nextcloud -it deploy/nextcloud -- su -s /bin/bash www-data -c "php -d memory_limit=-1 /var/www/html/occ maintenance:repair --include-expensive"
	kubectl -n "${TF_VAR_nextcloud_namespace}" exec -c nextcloud -it deploy/nextcloud -- su -s /bin/bash www-data -c "php -d memory_limit=-1 /var/www/html/occ db:add-missing-indices"

fmt:
	@for dir in $(DIRECTORIES); do \
	  (cd $$dir && terraform fmt); \
	done

ci: init
	@for dir in $(DIRECTORIES); do \
	  (cd $$dir && terraform fmt -check && terraform validate); \
	done
