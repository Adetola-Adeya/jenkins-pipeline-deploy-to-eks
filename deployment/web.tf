resource "kubernetes_namespace" "web-namespace" {
  metadata {
    name = "web-namespace"
    labels = {
      app = "web"
    }
  }
}

# Create kubernetes deployment for portfolio

resource "kubernetes_deployment" "web-deployment" {
  metadata {
    name      = "web"
    namespace = kubernetes_namespace.web-namespace.id
    labels = {
      app = "web"
    } 
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "web"
      }
    }
    template {
      metadata {
        labels = {
          app = "web"
        }
      }
      spec {
        container {
          image = var.docker-image
          name  = "web"
          env {
            name  = "MYSQL_HOST"
            value = "mysql"
          }
          env {
            name  = "MYSQL_PORT"
            value = "3306"
          }
        }
      }
    }
  }
}

# Create kubernetes service for portfolio

resource "kubernetes_service" "web-service-" {
  metadata {
    name      = "web"
    namespace = kubernetes_namespace.web-namespace.id
  }
  spec {
    selector = {
      app = "web"
    }
    port {
      name = "metrics"
      port        = 80
      target_port = 80
    }
    port {
      name = "mysql"
      port        = 3306
      target_port = 3306
    }
    type = "LoadBalancer"
  }
}

# MYSQL database for portfolio app

resource "kubernetes_deployment" "web-db" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.web-namespace.id
    labels = {
      app = "mysql"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name = "mysql"
          image = "mysql:latest"

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value = var.mysql-password
          }

          port {
            name = "mysql"
            container_port = 3306
          }

          volume_mount {
            name = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mysql-persistent-storage"
          empty_dir {
            medium = "Memory"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "web-db-service" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.web-namespace.id
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      name = "mysql"
      port = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}
