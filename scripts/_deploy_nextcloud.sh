#!/bin/bash

helm template --values ../config/nextcloud_values.yaml nextcloud nextcloud/nextcloud

echo ""
echo "###########################################################"
echo "###########################################################"
echo "###########################################################"
echo ""

# kubectl apply -f ../config/nextcloud_self_signed_cert.yaml
kubectl apply -f ../config/nextcloud_ingress.yaml

helm upgrade --values ../config/nextcloud_values.yaml --install nextcloud nextcloud/nextcloud
