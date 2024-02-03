#!/bin/bash

kubectl apply -f ../config/ingress_nginx_deployment.yaml --wait

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

kubectl apply -f ../config/cert_manager_deployment.yaml

echo "cluster ready!"
