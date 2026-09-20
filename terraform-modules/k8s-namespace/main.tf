# Creates a "tenant-ready" namespace: quota, default limits, and default-deny networking.
terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.30" }
  }
}

variable "name" { type = string }

variable "cpu_quota" {
  type    = string
  default = "4"
}

variable "memory_quota" {
  type    = string
  default = "8Gi"
}

resource "kubernetes_namespace" "this" {
  metadata {
    name   = var.name
    labels = { "managed-by" = "terraform" }
  }
}

resource "kubernetes_resource_quota" "this" {
  metadata {
    name      = "quota"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    hard = {
      "requests.cpu"    = var.cpu_quota
      "requests.memory" = var.memory_quota
      pods              = "50"
    }
  }
}

resource "kubernetes_limit_range" "this" {
  metadata {
    name      = "defaults"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    limit {
      type            = "Container"
      default         = { cpu = "250m", memory = "256Mi" }
      default_request = { cpu = "50m", memory = "64Mi" }
    }
  }
}

resource "kubernetes_network_policy" "default_deny_ingress" {
  metadata {
    name      = "default-deny-ingress"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    pod_selector {}
    policy_types = ["Ingress"]
  }
}

output "name" { value = kubernetes_namespace.this.metadata[0].name }
