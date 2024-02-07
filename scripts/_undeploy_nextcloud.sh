#!/bin/bash

kubectl delete -f -f ./config/nextcloud_ingress.yaml
helm delete nextcloud
