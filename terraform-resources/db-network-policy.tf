resource "kubernetes_network_policy" "db-network-policy" {
  metadata {
    name      = "mongo-network-policy"
    namespace = "default"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "app"
        operator = "In"
        values   = [kubernetes_deployment.mongo.spec.0.template.0.metadata.0.labels.app]
      }
    }

    ingress {
      ports {
        port = "27017"
      }

      from {
        pod_selector {
          match_labels = {
            app = kubernetes_deployment.node-app-deployment.spec.0.template.0.metadata.0.labels.app
          }
        }
      }
    }

    egress {}

    policy_types = ["Ingress", "Egress"]
  }
}