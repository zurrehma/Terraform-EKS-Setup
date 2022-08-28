# Resource: Persistent Volume Claim
resource "kubernetes_persistent_volume_claim" "pvc" {
  metadata {
    name = "mongo-db-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "500Mi"
      }
    }
  }
}

resource "kubernetes_service" "mongo-svc" {
  metadata {
    name = "mongo-db"
  }
  spec {
    selector = {
      app = kubernetes_deployment.mongo.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 27017
      target_port = 27017
    }
  }
}

resource "kubernetes_deployment" "mongo" {
  metadata {
    name = "mongo-db"
    labels = {
      app = "mongo-db"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mongo-db"
      }
    }
    template {
      metadata {
        labels = {
          app = "mongo-db"
        }
      }
      spec {
        volume {
          name = "mongo-persistent-storage"
          persistent_volume_claim {
            claim_name = "mongo-db-pvc"
          }
        }

        container {
          image = "mongo:5.0"
          name  = "mongo-db"

          port {
            container_port = 27017
          }

          volume_mount {
            name       = "mongo-persistent-storage"
            mount_path = "/data/mongo-db"
          }
        }
      }
    }
  }
}

