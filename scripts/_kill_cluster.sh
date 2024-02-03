#!/bin/bash

source .env
kind delete cluster --name $CLUSTER_NAME
