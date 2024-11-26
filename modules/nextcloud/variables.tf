variable "nextcloud_namespace" {
  description = "The namespace to install nextcloud"
  type        = string
}

variable "nextcloud_mariadb_root_password" {
  description = "The MariaDB root password"
  type        = string
  sensitive   = true
}

variable "nextcloud_mariadb_storage" {
  description = "The size of the disk used by the MariaDB server"
  type        = string
}

variable "nextcloud_password" {
  description = "Nextcloud password"
  type        = string
  sensitive   = true
}

variable "nextcloud_token" {
  description = "Nextcloud token"
  type        = string
  sensitive   = true
}

variable "nextcloud_username" {
  description = "Nextcloud"
  type        = string
}

variable "nextcloud_storage" {
  description = "The size of the disk used by the Nextcloud server"
  type        = string
}

variable "nextcloud_host" {
  description = "Nextcloud ingress host"
  type        = string
}

variable "cert_issuer" {
  description = "The name of the certificate issuer"
  type        = string
}

variable "nextcloud_mariadb_pvc_host_path" {
  description = "The path of the persistent volume in the host machine"
  type        = string
}

variable "nextcloud_pvc_host_path" {
  description = "The path of the persistent volume in the host machine"
  type        = string
}
