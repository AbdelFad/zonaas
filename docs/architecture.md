# Architecture ML-Landing-Zone

## Flux principal

1. Data Scientist demande un nouveau projet dans Backstage
2. Scaffolder crée repo + bootstrap MLOps template
3. Terraform/Crossplane provisionne namespace + garde-fous
4. ArgoCD synchronise workloads projet dans le namespace
5. Vault/Kyverno/NetworkPolicy sécurisent l'exécution
6. Prometheus/Grafana/KubeCost fournissent métriques et coûts

## Séparation des plans

- **Control Plane**: repo plateforme, templates, modules IaC, AppSets, policies globales
- **Execution Plane**: namespaces projet (`ml-<team>-<env>`), jobs d'entraînement, serving

## Design cloud-agnostic

- ressources K8s exprimées en manifests standards
- variables provider encapsulées en overlays/modules (`terraform/providers/*`)
- pas de dépendance dure à un cloud unique dans la couche core
