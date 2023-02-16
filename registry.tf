resource "kubernetes_service" "registry" {
  metadata {
    name = "registry"
  }
  spec {
    selector = {
      app = "registry"
    }
    port {
      port        = "5000"
      target_port = "5000"
      node_port   = "30500"
    }
    type         = "NodePort"
    session_affinity        = "ClientIP"
  }
}

resource "kubernetes_deployment" "registry" {
  metadata {
    name = "registry"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "registry"
      }
    }
    template {
      metadata {
        labels = {
          app = "registry"
        }
      }
      spec {
        container {
          image = "registry:2.8"
          name  = "registry"
          volume_mount {
            name       = "cert-vol"
            mount_path = "/var/run/secrets/certs"
          }
          volume_mount {
            name       = "config-yml"
            mount_path = "/etc/docker/registry/"
            read_only  = true
          }
          env {
            name  = "REGISTRY_HTTP_TLS_CERTIFICATE"
            value = "/var/run/secrets/certs/tls.crt"
          }
          env {
            name  = "REGISTRY_HTTP_TLS_KEY"
            value = "/var/run/secrets/certs/tls.key"
          }
        }
        volume {
          name = "cert-vol"
          secret {
            secret_name = "registry-cert"
          }
        }
        volume {
          name = "config-yml"
          config_map {
            name = "registry"
          }
        }
      }
    }
  }
}
