resource "kubernetes_secret" "nextcloud_mariadb_secrets" {
  metadata {
    name      = "nextcloud-mariadb-secrets"
    namespace = var.nextcloud_namespace
  }
  data = {
    "mariadb-root-user"     = "root"
    "mariadb-root-password" = var.nextcloud_mariadb_root_password
  }
}

resource "kubernetes_persistent_volume" "nextcloud_mariadb_pv" {
  metadata {
    name = "${var.nextcloud_namespace}-nextcloud-mariadb-pv"
  }
  spec {
    capacity = {
      storage = var.nextcloud_mariadb_storage
    }
    volume_mode                      = "Filesystem"
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "local-path"
    persistent_volume_source {
      host_path {
        path = var.nextcloud_mariadb_pvc_host_path
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "nextcloud_mariadb_pvc" {
  depends_on = [kubernetes_persistent_volume.nextcloud_mariadb_pv]
  metadata {
    name      = "nextcloud-mariadb-pvc"
    namespace = var.nextcloud_namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.nextcloud_mariadb_storage
      }
    }
    volume_name        = "${var.nextcloud_namespace}-nextcloud-mariadb-pv"
    storage_class_name = "local-path"
  }
}

resource "helm_release" "nextcloud_mariadb" {
  depends_on = [
    kubernetes_persistent_volume_claim.nextcloud_mariadb_pvc
  ]
  name       = "nextcloud-mariadb"
  chart      = "mariadb"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.nextcloud_namespace
  version    = "20.0.0"
  values = [
    yamlencode({
      auth = {
        existingSecret = "nextcloud-mariadb-secrets"
      }
      primary = {
        persistence = {
          existingClaim = "nextcloud-mariadb-pvc"
        }
      }
      volumePermissions = {
        enabled = true
      }
    })
  ]
  timeout           = 300
  dependency_update = true
}

resource "kubernetes_secret" "nextcloud-secrets" {
  metadata {
    name      = "nextcloud-secrets"
    namespace = var.nextcloud_namespace
  }
  data = {
    "nextcloud-password" = var.nextcloud_password
    "nextcloud-token"    = var.nextcloud_token
    "nextcloud-username" = var.nextcloud_username
  }
}

resource "kubernetes_persistent_volume" "nextcloud_pv" {
  metadata {
    name = "${var.nextcloud_namespace}-nextcloud-pv"
  }
  spec {
    capacity = {
      storage = var.nextcloud_storage
    }
    volume_mode                      = "Filesystem"
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "local-path"
    persistent_volume_source {
      host_path {
        path = var.nextcloud_pvc_host_path
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "nextcloud_pvc" {
  depends_on = [kubernetes_persistent_volume.nextcloud_pv]
  metadata {
    name      = "nextcloud-pvc"
    namespace = var.nextcloud_namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.nextcloud_storage
      }
    }
    volume_name        = "${var.nextcloud_namespace}-nextcloud-pv"
    storage_class_name = "local-path"
  }
}

resource "kubernetes_manifest" "traefik_redirect" {
  manifest = {
    "apiVersion" = "traefik.containo.us/v1alpha1"
    "kind"       = "Middleware"
    "metadata" = {
      "name"      = "redirect"
      "namespace" = var.nextcloud_namespace
    }
    "spec" = {
      "redirectScheme" = {
        "scheme"    = "https"
        "permanent" = true
      }
    }
  }
}

resource "kubernetes_manifest" "traefik_hsts" {
  manifest = {
    "apiVersion" = "traefik.containo.us/v1alpha1"
    "kind"       = "Middleware"
    "metadata" = {
      "name"      = "hsts"
      "namespace" = var.nextcloud_namespace
    }
    "spec" = {
      "headers" = {
        "stsSeconds"           = 15552000
        "stsIncludeSubdomains" = true
        "stsPreload"           = true
      }
    }
  }
}

resource "helm_release" "nextcloud" {
  depends_on = [
    helm_release.nextcloud_mariadb,
    kubernetes_manifest.traefik_redirect,
    kubernetes_manifest.traefik_hsts,
    kubernetes_persistent_volume_claim.nextcloud_pvc
  ]
  name       = "nextcloud"
  chart      = "nextcloud"
  repository = "https://nextcloud.github.io/helm"
  namespace  = var.nextcloud_namespace
  version    = "6.2.4"  

  values = [
    yamlencode({
      livenessProbe = {
        enabled = true
      }
      readinessProbe = {
        enabled = true
      }
      cronjob = {
        enabled = true
      }
      service = {
        annotations = {
          "traefik.ingress.kubernetes.io/service.sticky.cookie" = "true"
        }
      }
      ingress = {
        enabled = true
        annotations = {
          "kubernetes.io/ingress.class"                      = "traefik"
          "cert-manager.io/cluster-issuer"                   = var.cert_issuer
          "traefik.ingress.kubernetes.io/router.middlewares" = "${var.nextcloud_namespace}-redirect@kubernetescrd,${var.nextcloud_namespace}-hsts@kubernetescrd"
        }
        tls = [{
          secretName = "${var.nextcloud_host}-tls"
          hosts      = [var.nextcloud_host]
        }]
      }
      nextcloud = {
        host = var.nextcloud_host
        # NOTE: You might need to comment these out during first deployment (health check won't pass due to some weird behaviour)
        # NOTE: If you face a problem, disable the readidess and liveness probes above.
        configs = {
          "custom.config.php" = <<-EOT
          <?php
          $CONFIG = array (
            'maintenance_window_start' => 1,
            'trusted_proxies' => ['10.42.0.0/16'],
            'overwriteprotocol' => 'https',
            'default_phone_region' => 'CA',
            'overwritehost' => '${var.nextcloud_host}',
            'overwrite.cli.url' => 'https://${var.nextcloud_host}',
          );
          EOT
        }
        existingSecret = {
          enabled     = true
          secretName  = "nextcloud-secrets"
          usernameKey = "nextcloud-username"
          passwordKey = "nextcloud-password"
          tokenKey    = "nextcloud-token"
        }
      }
      internalDatabase = {
        enabled = false
        name    = "nextcloud"
      }
      externalDatabase = {
        enabled  = true
        type     = "mysql"
        host     = "nextcloud-mariadb:3306"
        user     = "root"
        password = ""
        database = "my_database"
        existingSecret = {
          enabled     = true
          secretName  = "nextcloud-mariadb-secrets"
          usernameKey = "mariadb-root-user"
          passwordKey = "mariadb-root-password"
        }
      }
      persistence = {
        enabled       = true
        existingClaim = "nextcloud-pvc"
      }
    })
  ]
  timeout           = 300
  dependency_update = true
}
