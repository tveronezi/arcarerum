#!/bin/bash
set -e

./_kill_cluster.sh 
./_create_cluster.sh 
./_setup_ingress.sh 
./_create_nextcloud_mariadb_secret.sh 
./_create_nextcloud_mariadb_volume.sh 
./_deploy_nextcloud_mariadb.sh

./_create_nextcloud_volume.sh 
./_create_nextcloud_secret.sh 
./_deploy_nextcloud.sh





