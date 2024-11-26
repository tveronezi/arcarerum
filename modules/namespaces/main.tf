resource "kubernetes_namespace" "nextcloud" {
  metadata {
    name = var.nextcloud_namespace
  }
}
