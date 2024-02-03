#!/bin/bash

source .env
kind create cluster --name "$CLUSTER_NAME" --config ./config/kind_cluster.yaml --wait 1m
