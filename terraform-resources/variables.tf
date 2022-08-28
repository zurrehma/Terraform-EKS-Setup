variable "cluster_name" {
  default = "eks-cluster"
  type    = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "image" {
  default = "zahid401/node-easy-notes:latest"
  type    = string
}

variable "mongo_url" {
  default = "mongodb://mongo-db:27017/easy-notes"
  type    = string
}