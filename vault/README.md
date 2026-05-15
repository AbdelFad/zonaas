# Vault Integration (Production Pattern)

## Objectif
Injection de secrets en **mémoire** via Vault Agent Sidecar + auth Kubernetes.

## Étapes
1. Activer auth Kubernetes dans Vault
2. Créer policy Vault par namespace projet
3. Créer role Vault lié au serviceAccount Kubernetes
4. Annoter les pods pour injection

## Exemples fournis
- `vault/policies/ml-alpha-prod.hcl`
- `vault/kubernetes/vault-role-ml-alpha-prod.json`
- `vault/kubernetes/serviceaccount-ml-workload.yaml`
- `vault/kubernetes/pod-vault-injection-example.yaml`
