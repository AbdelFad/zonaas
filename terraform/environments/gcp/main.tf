module "ml_alpha_prod" {
  source = "../../modules/ml_namespace"

  name = "ml-alpha-prod"
  labels = {
    "zonaas/environment" = var.environment
    "zonaas/platform"    = "gcp"
    "zonaas/cost-center" = "ml-alpha"
    "zonaas/owner"       = "data-science"
  }
}
