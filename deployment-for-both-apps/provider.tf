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



resource "kubernetes_namespace" "kube-namespace-socks" {
  metadata {
    name = "sock-shop"
  }
}