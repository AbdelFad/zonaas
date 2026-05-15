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
