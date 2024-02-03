#!/bin/bash

helm repo add nextcloud https://nextcloud.github.io/helm/ | true
helm repo add bitnami https://charts.bitnami.com/bitnami | true
helm repo update
