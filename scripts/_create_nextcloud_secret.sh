#!/bin/bash

source .env

SECRET_NAME="nextcloud-secrets"

kubectl get secret "$SECRET_NAME" \
|| kubectl create secret generic "$SECRET_NAME" \
    --from-literal=nextcloud-password="$DEV_NEXTCLOUD_PASSWORD" \
    --from-literal=nextcloud-token="$DEV_NEXTCLOUD_TOKEN" \
    --from-literal=nextcloud-username="$DEV_NEXTCLOUD_USERNAME"
