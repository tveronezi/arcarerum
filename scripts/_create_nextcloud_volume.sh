#!/bin/bash

source .env

kubectl apply -f ./config/nextcloud_pv.yaml
kubectl apply -f ./config/nextcloud_pvc.yaml
