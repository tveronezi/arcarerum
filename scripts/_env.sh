#!/bin/bash

# Path to the .env file
ENV_FILE=".env"

# Function to set a default value if the environment variable is not already set
set_default() {
    local var_name="$1"
    local default_value="$2"
    # Using eval to indirectly reference variable
    if [ -z "${!var_name}" ]; then
        eval export "$var_name=\"$default_value\""
    fi
}

# Source the .env file if it exists
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

# Set defaults if variables are not set
set_default CLUSTER_NAME "banana"

set_default DEV_NEXTCLOUD_MARIADB_ROOT_PASSWORD "this password is bad. please dont use it."
set_default DEV_NEXTCLOUD_MARIADB_REPLICATION_PASSWORD "this password is bad. please dont use it."
set_default DEV_NEXTCLOUD_MARIADB_PASSWORD "this password is bad. please dont use it."

set_default DEV_NEXTCLOUD_PASSWORD "this password is bad. please dont use it."
set_default DEV_NEXTCLOUD_TOKEN "this token is horrible. dont use it in production."
set_default DEV_NEXTCLOUD_USERNAME "admin"

# At this point, environment variables are either sourced from .env or set to default values

# Debug: Uncomment the following line to print all variables for verification
declare -p CLUSTER_NAME DEV_NEXTCLOUD_MARIADB_ROOT_PASSWORD DEV_NEXTCLOUD_MARIADB_REPLICATION_PASSWORD DEV_NEXTCLOUD_MARIADB_PASSWORD DEV_NEXTCLOUD_PASSWORD DEV_NEXTCLOUD_TOKEN DEV_NEXTCLOUD_USERNAME
