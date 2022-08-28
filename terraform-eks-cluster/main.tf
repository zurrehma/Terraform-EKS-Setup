# Kubernetes provider
# The Kubernetes provider is included in this file so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "eks-cluster"
  common_tags = {
    "Created_By"  = "DevOps Team"
    "Managed_By"  = "Terraform"
    "Modified_At" = timestamp()
  }
}

