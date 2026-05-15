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
    "mlz/gpu-profile"                         = var.gpu_profile,
    "pod-security.kubernetes.io/enforce"      = "restricted",
    "pod-security.kubernetes.io/audit"        = "restricted",
    "pod-security.kubernetes.io/warn"         = "restricted"
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

resource "kubernetes_network_policy" "allow-egress-dns" {
  metadata {
    name      = "allow-egress-dns"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }
      }
      ports {
        port     = 53
        protocol = "UDP"
      }
      ports {
        port     = 53
        protocol = "TCP"
      }
    }
  }
}

resource "kubernetes_network_policy" "allow-egress-vault" {
  metadata {
    name      = "allow-egress-vault"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        ip_block {
          cidr = var.vault_cidr
        }
      }
      ports {
        port     = 8200
        protocol = "TCP"
      }
    }
  }
}

resource "kubernetes_network_policy" "allow-egress-object-storage" {
  metadata {
    name      = "allow-egress-object-storage"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        ip_block {
          cidr = var.object_storage_cidr
        }
      }
      ports {
        port     = 443
        protocol = "TCP"
      }
    }
  }
}
