module "ml_alpha_prod" {
  source = "../../modules/ml_namespace"

  name = "ml-alpha-prod"
  labels = {
    "zonaas/environment" = var.environment
    "zonaas/platform"    = "aws"
    "zonaas/cost-center" = "ml-alpha"
    "zonaas/owner"       = "data-science"
  }

  cpu_requests = "16"
  cpu_limits   = "32"
  mem_requests = "64Gi"
  mem_limits   = "128Gi"
  gpu_limits   = "4"
}
