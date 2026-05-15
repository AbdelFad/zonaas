#!/usr/bin/env bash
set -euo pipefail

terraform -chdir=terraform/environments/dev fmt -check -recursive
terraform -chdir=terraform/environments/dev validate
kubectl kustomize gitops/bootstrap >/dev/null
kubectl kustomize gitops/apps/base >/dev/null

echo "Validation OK"
