provider "aws" {
  region = "us-east-1"
  
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

data "aws_eks_cluster" "oneapp" {
  name = "oneapp"
}

data "aws_eks_cluster_auth" "oneapp" {
  name = "oneapp"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.oneapp.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.oneapp.certificate_authority[0].data)
  # version          = "2.16.1"

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.oneapp.name]
    command     = "aws"
  }
}


resource "kubernetes_namespace" "kube-namespace-socks" {
  metadata {
    name = "sock-shop"
  }
}