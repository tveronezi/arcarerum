#!/bin/bash

source .env

kubectl apply -f ./config/nextcloud_mariadb_pv.yaml
kubectl apply -f ./config/nextcloud_mariadb_pvc.yaml
