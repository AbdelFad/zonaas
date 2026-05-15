variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}

variable "kube_context" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}
