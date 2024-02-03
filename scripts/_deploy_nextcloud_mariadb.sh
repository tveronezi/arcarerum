#!/bin/bash

helm upgrade --values ../config/nextcloud_mariadb_values.yaml --install nextcloud-mariadb bitnami/mariadb
