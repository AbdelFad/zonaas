# Roadmap d'implémentation

## MVP (présent dans ce repo)
- Namespace provisioning
- ResourceQuota/LimitRange
- NetworkPolicy deny-by-default
- ArgoCD bootstrap + ApplicationSet projet
- Template Backstage prêt à l'emploi
- Dagster asset starter

## Phase 2
- Intégration Vault dynamique (auth Kubernetes)
- Intégration OPA/Gatekeeper ou Kyverno avancé
- SSO enterprise (OIDC/SAML) sur Backstage/ArgoCD
- Self-service catalog enrichi (GPU classes, SLA)

## Phase 3
- Multi-cluster scheduler (dev/stage/prod séparés)
- Data plane mesh (mTLS, egress gateway)
- Policy packs par BU/conformité (ISO, SOC2, HIPAA)
