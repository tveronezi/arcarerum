#!/bin/bash

source ./scripts/_env.sh

SECRET_NAME="nextcloud-mariadb-secrets"

kubectl get secret "$SECRET_NAME" \
|| kubectl create secret generic "$SECRET_NAME" \
    --from-literal=mariadb-root-user=root \
    --from-literal=mariadb-root-password=$DEV_NEXTCLOUD_MARIADB_ROOT_PASSWORD
