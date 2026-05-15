module "ml_alpha_prod" {
  source = "../../modules/ml_namespace"

  name = "ml-alpha-prod"
  labels = {
    "mlz/environment" = var.environment
    "mlz/platform"    = "aws"
    "mlz/cost-center" = "ml-alpha"
    "mlz/owner"       = "data-science"
  }

  cpu_requests = "16"
  cpu_limits   = "32"
  mem_requests = "64Gi"
  mem_limits   = "128Gi"
  gpu_limits   = "4"
}
