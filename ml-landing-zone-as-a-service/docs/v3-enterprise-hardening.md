# V3 Enterprise Hardening

## Nouveautés
- AppProject ArgoCD restreint à une whitelist de repos
- Namespace forcé en Pod Security Standard `restricted`
- Egress réseau explicite (DNS + Vault + Object Storage)
- Backstage template enrichi avec gouvernance (SLA, cost-center, compliance, profil GPU)

## Notes opérationnelles
- Remplacer `vault_cidr` et `object_storage_cidr` par vos plages réelles.
- En cloud public, préférer des egress gateways/NAT avec IP fixes pour politiques stables.
- Pour workloads GPU nécessitant exceptions PSS, utiliser un namespace dédié + policy d'exception contrôlée.
