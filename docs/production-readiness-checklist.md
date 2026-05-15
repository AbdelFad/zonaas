# Production Readiness Checklist

## Sécurité
- [ ] Vault Kubernetes auth activé
- [ ] Policies Kyverno en mode Enforce
- [ ] `:latest` interdit
- [ ] Pod security context (non-root, readOnlyRootFS)
- [ ] Registry allowlist active

## Fiabilité
- [ ] ArgoCD HA + sauvegarde Redis/Postgres (si utilisé)
- [ ] AppProject verrouillé (sourceRepos stricts)
- [ ] Rollback défini par application

## Ops
- [ ] Alerting Prometheus (latence, erreurs, saturation GPU)
- [ ] Dashboard coût par namespace
- [ ] Budget alert KubeCost

## Plateforme
- [ ] Conventions namespace `ml-<team>-<env>`
- [ ] Quotas revus trimestriellement
- [ ] Profils GPU/MIG documentés et appliqués

## Souveraineté LLM (V4)
- [ ] Namespace LLM labelé `zonaas/tenant-type=llm`
- [ ] Egress mode explicite (`deny-all` ou `strict-allowlist`)
- [ ] Services LLM en `ClusterIP` uniquement (pas de LB public)
- [ ] Label `zonaas/data-classification` sur workloads LLM
- [ ] Audit trail activé pour toutes les inférences
- [ ] Runbook exfiltration testé (table-top exercise)
