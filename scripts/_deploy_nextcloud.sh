#!/bin/bash

kubectl apply -f ./config/nextcloud_ingress.yaml

helm upgrade --values ./config/nextcloud_values.yaml --install nextcloud nextcloud/nextcloud
