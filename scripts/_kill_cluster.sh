#!/bin/bash

source ./_env.sh
kind delete cluster --name $CLUSTER_NAME
