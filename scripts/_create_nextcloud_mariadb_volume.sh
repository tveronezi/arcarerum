#!/bin/bash

source ./_env.sh

kubectl apply -f ../config/nextcloud_mariadb_pv.yaml
kubectl apply -f ../config/nextcloud_mariadb_pvc.yaml