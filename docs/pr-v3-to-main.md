# PR Plan — Merge `v3-prod-hardening` into `main`

## Objectif
Promouvoir le hardening V3 en branche principale après validation.

## Résumé des changements
- Durcissement ArgoCD via AppProject restreint
- Politiques egress réseau plus fines
- Adoption PSS `restricted`
- Enrichissement du template Backstage (gouvernance)
- Documentation V3 dédiée

## Checklist pré-merge
- [ ] CI verte sur la branche `v3-prod-hardening`
- [ ] Validation kustomize des manifests bootstrap/policies
- [ ] Validation Terraform des environnements ciblés
- [ ] Relecture sécurité (plateforme + SecOps)
- [ ] Plan de rollback documenté

## Commandes (quand un remote est configuré)
```bash
git checkout v3-prod-hardening
git push origin v3-prod-hardening
gh pr create \
  --base main \
  --head v3-prod-hardening \
  --title "feat: V3 enterprise hardening for ZONAAS" \
  --body-file docs/pr-v3-to-main.md
```

## Rollback
- Revenir à `v2.0.0` (tag stable)
- Réappliquer le bootstrap V2 si nécessaire

## Critères d’acceptation
- Aucun drift critique sur les apps ArgoCD
- Aucun blocage de flux ML légitime dû aux policies
- KPI coût/sécurité conformes aux objectifs d’exploitation
