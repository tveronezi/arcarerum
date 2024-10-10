# arcarerum

Check `.env.sample` for the required variables.

> **Important:** Copy ".env.sample" as ".env" and update the values of the variables with your own.


Check the .github/workflows/ci.yaml file to see the usage of all other commands.

```bash
cp .env.sample .env

./scripts/_kill_cluster.sh  \
    && ./scripts/_create_cluster.sh \
    && ./scripts/_setup_ingress.sh  \
    && ./scripts/_setup_ingress.sh  \
    && ./scripts/_create_nextcloud_mariadb_secret.sh  \
    && ./scripts/_create_nextcloud_mariadb_volume.sh  \
    && ./scripts/_deploy_nextcloud_mariadb.sh \
    && ./scripts/_create_nextcloud_secret.sh  \
    && ./scripts/_create_nextcloud_volume.sh  \
    && ./scripts/_deploy_nextcloud.sh \
    && kubectl wait --for=condition=available --timeout=300s deployment/nextcloud \
    && ./scripts/_status.sh

watch ./scripts/_status_all.sh
```
