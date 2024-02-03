#!/bin/bash

kubectl apply -f ./config/nextcloud_ingress.yaml

# helm template --values ./config/nextcloud_values.yaml nextcloud nextcloud/nextcloud
helm upgrade --values ./config/nextcloud_values.yaml --install nextcloud nextcloud/nextcloud
