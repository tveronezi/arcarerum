#!/bin/bash

helm template --values ./config/nextcloud_values.yaml nextcloud nextcloud/nextcloud

echo ""
echo "###########################################################"
echo "###########################################################"
echo "###########################################################"
echo ""

helm upgrade --values ./config/nextcloud_values.yaml --install nextcloud nextcloud/nextcloud
