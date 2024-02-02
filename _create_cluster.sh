#!/bin/bash

source ./_env.sh
kind create cluster --name $CLUSTER_NAME --config ./config/kind_cluster.yaml --wait 1m
