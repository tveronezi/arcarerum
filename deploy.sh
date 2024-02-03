#!/bin/bash
set -e

./scripts/_create_nextcloud_mariadb_secret.sh 
./scripts/_create_nextcloud_mariadb_volume.sh 
./scripts/_deploy_nextcloud_mariadb.sh

./scripts/_create_nextcloud_secret.sh 
./scripts/_create_nextcloud_volume.sh 
./scripts/_deploy_nextcloud.sh
