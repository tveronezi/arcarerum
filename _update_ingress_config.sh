#!/bin/bash

URL="https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"

curl -sS "$URL" > config/ingress_nginx_deployment.yaml

URL="https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml"

curl -sSL "$URL" > config/cert_manager_deployment.yaml
