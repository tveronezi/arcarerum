#!/bin/bash

source ./scripts/_env.sh
kind delete cluster --name $CLUSTER_NAME
