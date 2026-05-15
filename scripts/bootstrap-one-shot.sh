#!/usr/bin/env bash
set -euo pipefail

# One-shot bootstrap for a fresh Kubernetes cluster
# Usage:
#   ./scripts/bootstrap-one-shot.sh [--context <kube-context>] [--namespace argocd]

KUBE_CONTEXT=""
ARGOCD_NS="argocd"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --context)
      KUBE_CONTEXT="${2:-}"
      shift 2
      ;;
    --namespace)
      ARGOCD_NS="${2:-argocd}"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--context <kube-context>] [--namespace argocd]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "[ERROR] Missing required command: $1" >&2
    exit 1
  }
}

need_cmd kubectl
need_cmd kustomize

KUBECTL=(kubectl)
if [[ -n "$KUBE_CONTEXT" ]]; then
  KUBECTL+=(--context "$KUBE_CONTEXT")
fi

echo "[INFO] Checking cluster access..."
"${KUBECTL[@]}" cluster-info >/dev/null

echo "[INFO] Creating namespace ${ARGOCD_NS} (idempotent)..."
"${KUBECTL[@]}" create namespace "$ARGOCD_NS" --dry-run=client -o yaml | "${KUBECTL[@]}" apply -f -

echo "[INFO] Applying ArgoCD bootstrap resources..."
"${KUBECTL[@]}" apply -f "${ROOT_DIR}/gitops/bootstrap/argocd-namespace.yaml"
"${KUBECTL[@]}" apply -k "${ROOT_DIR}/gitops/bootstrap"

echo "[INFO] Applying Kyverno baseline policies..."
"${KUBECTL[@]}" apply -k "${ROOT_DIR}/policies/kyverno"

echo "[INFO] Bootstrap complete."
echo "[NEXT] Validate resources:"
echo "  kubectl get ns"
echo "  kubectl -n ${ARGOCD_NS} get pods"
echo "  kubectl get applications.argoproj.io -A"
