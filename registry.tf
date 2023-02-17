variable "image" {}
variable "port" {}
variable "replicas" {}

variable "stack" {
  default = "registry"
}

resource "kubernetes_service" "main" {
  metadata {
    name = var.stack
  }
  spec {
    selector = {
      app = var.stack
    }
    port {
      port        = "5000"
      target_port = "5000"
      node_port   = var.port
    }
    type             = "NodePort"
    session_affinity = "ClientIP"
  }
}

resource "kubernetes_deployment" "main" {
  metadata {
    name = var.stack
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = var.stack
      }
    }
    template {
      metadata {
        labels = {
          app = var.stack
        }
      }
      spec {
        container {
          image = var.image
          name  = var.stack
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
            name = var.stack
          }
        }
      }
    }
  }
}
