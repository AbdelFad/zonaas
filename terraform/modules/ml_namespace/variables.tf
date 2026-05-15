variable "name" {
  type        = string
  description = "Namespace name"
}

variable "labels" {
  type        = map(string)
  description = "Namespace labels"
  default     = {}
}

variable "cpu_requests" { type = string default = "8" }
variable "cpu_limits"   { type = string default = "16" }
variable "mem_requests" { type = string default = "32Gi" }
variable "mem_limits"   { type = string default = "64Gi" }
variable "gpu_limits"   { type = string default = "2" }
variable "gpu_profile" {
  type        = string
  default     = "none"
  description = "none|small|medium|large (MIG profile policy label)"
}

variable "vault_cidr" {
  type        = string
  default     = "10.10.0.0/24"
  description = "CIDR where Vault endpoint is exposed"
}

variable "object_storage_cidr" {
  type        = string
  default     = "10.20.0.0/16"
  description = "CIDR where object storage endpoint is exposed"
}
