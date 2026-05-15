module "ml_alpha_prod" {
  source = "../../modules/ml_namespace"

  name = "ml-alpha-prod"
  labels = {
    "mlz/environment" = var.environment
    "mlz/platform"    = "gcp"
    "mlz/cost-center" = "ml-alpha"
    "mlz/owner"       = "data-science"
  }
}
