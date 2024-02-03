#!/bin/bash

source ./scripts/_env.sh

kubectl apply -f ./config/nextcloud_pv.yaml
kubectl apply -f ./config/nextcloud_pvc.yaml
