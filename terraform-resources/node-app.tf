resource "kubernetes_deployment" "node-app-deployment" {
  metadata {
    name = "node-app"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "node-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "node-app"
        }
      }
      spec {
        container {
          image             = var.image
          name              = "node-app"
          image_pull_policy = "Always"
          port {
            container_port = 3000
          }
          env {
            name  = "MONGO_URL"
            value = var.mongo_url
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "node-app-svc" {
  metadata {
    name = "node-app"
  }
  spec {
    selector = {
      app = kubernetes_deployment.node-app-deployment.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 3000
    }
  }
}