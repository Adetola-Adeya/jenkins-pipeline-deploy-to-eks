# Create kubernetes Name space for socks shop app

# resource "null_resource" "create_namespace" {
#   # Use a null_resource to execute a local provisioner
#   provisioner "local-exec" {
#     # Use the kubectl command to check if the namespace already exists
#     command = "kubectl get namespace sock-shop"

#     # Set the namespace_exists variable to true if the command returns 0, indicating success
#     # Set it to false if the command returns a non-zero code, indicating failure
#     environment = {
#       namespace_exists = sh("kubectl get namespace sock-shop", return_code: [0,1]) == 0,
#     }
#   }
# }



# resource "kubernetes_namespace" "kube-namespace-socks" {
#   metadata {
#     name = "sock-shop"
#   }

#   count = length(kubernetes_namespace.kube-namespace-socks.*.id) == 0 ? 1 : 0
#   # Set the namespace to depend on the null_resource to ensure it is created first
#   # depends_on = [null_resource.create_namespace]
# }

resource "kubernetes_namespace" "kube-namespace-socks" {
  metadata {
    name = "sock-shop"
  }
}

# resource "kubernetes_namespace" "kube-namespace-socks" {
#   metadata {
#     name = "sock-shop"
#   }
# }

# Create kubectl deployment for socks app

data "kubectl_file_documents" "docs" {
    content = file("eks-manifest.yaml")
}

resource "kubectl_manifest" "kube-deployment-socks" {
    for_each  = data.kubectl_file_documents.docs.manifests
    yaml_body = each.value
}

# Create separate kubernetes service for socks shop frontend

resource "kubernetes_service" "kube-service-socks" {
  metadata {
    name      = "front-end"
    namespace = kubernetes_namespace.kube-namespace-socks.id
    annotations = {
      "prometheus.io/scrape" = "true"
    }
    labels = {
      name = "front-end"
    }
  }
  spec {
    selector = {
      name = "front-end"
    }
    port {
      name = "metrics"
      port        = 80
      target_port = 8079
    }
    type = "LoadBalancer"
  }

    lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}


# CHECK IF AWS KMS ALIAS EXIST
# data "aws_kms_alias" "existing_alias" {
#   name = "alias/eks/socks-web-shop"
# }

# resource "aws_kms_alias" "this" {
#   # Only create the alias if it does not exist
#   count = data.aws_kms_alias.existing_alias.arn ? 0 : 1

#   name          = "alias/eks/socks-web-shop"
#   target_key_id = aws_kms_key.this.key_id
# }


# Check if cloudwatch group exists
# data "aws_cloudwatch_log_group" "existing_log_group" {
#   name = "/aws/eks/socks-web-shop/cluster"
# }

# resource "aws_cloudwatch_log_group" "this" {
#   # Only create the log group if it does not exist
#   count = data.aws_cloudwatch_log_group.existing_log_group.arn ? 0 : 1

#   name = "/aws/eks/socks-web-shop/cluster"
# }
