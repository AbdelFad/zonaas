terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

locals {
  merged_labels = merge(var.labels, {
    "mlz/gpu-profile" = var.gpu_profile
  })
}

resource "kubernetes_namespace" "this" {
  metadata {
    name   = var.name
    labels = local.merged_labels
  }
}

resource "kubernetes_resource_quota" "this" {
  metadata {
    name      = "compute-quota"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"          = var.cpu_requests
      "limits.cpu"            = var.cpu_limits
      "requests.memory"       = var.mem_requests
      "limits.memory"         = var.mem_limits
      "limits.nvidia.com/gpu" = var.gpu_limits
      "pods"                  = "100"
    }
  }
}

resource "kubernetes_limit_range" "this" {
  metadata {
    name      = "default-limits"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "1"
        memory = "2Gi"
      }
      default_request = {
        cpu    = "250m"
        memory = "512Mi"
      }
    }
  }
}

resource "kubernetes_network_policy" "deny_all" {
  metadata {
    name      = "default-deny-all"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }
}
