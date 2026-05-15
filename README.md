# ML Landing Zone as a Service (ML-LZaaS)

Plateforme **Enterprise-Ready** pour provisionner des environnements ML isolés, sécurisés, observables et pilotés en GitOps.

Objectif: fournir une base **prête à l'emploi** applicable **on-prem** et sur **cloud public** (AWS/Azure/GCP/OVH/…)
avec un noyau Kubernetes + Terraform + ArgoCD + Backstage.

## Principes d'architecture

- **Control Plane**: Backstage, Terraform, ArgoCD, policies globales
- **Execution Plane**: cluster(s) Kubernetes, namespaces projets ML
- **Séparation stricte des rôles**: plateforme vs data scientists
- **Cloud-agnostic**: les abstractions Kubernetes restent communes, les détails cloud sont dans des overlays/modules dédiés

## Arborescence

```text
.
├── backstage/                  # Templates Scaffolder
├── terraform/                  # IaC (core + environnements)
├── gitops/                     # ArgoCD + manifests apps (+ overlays cloud)
├── policies/                   # Kyverno + security baselines
├── observability/              # Prometheus/Grafana/KubeCost starters
├── mlops/                      # Dagster starter assets
├── scripts/                    # Helpers bootstrap/validation
└── docs/                       # Guides architecture/opérations
```

## Démarrage rapide

### 1) Prérequis

- Kubernetes 1.27+
- `kubectl`, `kustomize`, `terraform`, `argocd` (CLI optionnel)
- cluster avec ingress + storage class

### 2) Provisionner la base namespace/policies via Terraform

```bash
cd terraform/environments/dev
terraform init
terraform plan -var='cluster_name=mlz-dev' -var='environment=dev'
terraform apply -var='cluster_name=mlz-dev' -var='environment=dev'
```

### 3) Déployer GitOps bootstrap

```bash
kubectl apply -f gitops/bootstrap/argocd-namespace.yaml
kubectl apply -k gitops/bootstrap
```

### 4) Créer un premier projet via template Backstage

Utiliser `backstage/templates/ml-project-template.yaml`:
- crée un repo projet ML
- génère structure `.argo/`, `devcontainer.json`, `Makefile`
- rattache le projet à l'ApplicationSet ArgoCD

## Cibles supportées

- **On-prem Kubernetes** (RKE2, OpenShift, kubeadm, Talos)
- **EKS / AKS / GKE** (via overlays/modules provider)

## Sécurité par défaut

- deny-all ingress/egress par namespace projet
- exceptions explicites (Vault, object storage, DNS)
- ResourceQuota + LimitRange
- policies Kyverno (images, labels, ressources)

## FinOps & Observabilité

- Dashboard Grafana par projet
- métriques coût via KubeCost
- annotations/tags coûts appliquées dès la création namespace

## Production-ready additions

- ApplicationSet dynamique via Git generator (`gitops/bootstrap/root-applicationset.yaml`)
- Intégration Vault Kubernetes auth (`vault/`)
- Policies Kyverno renforcées (`policies/kyverno/`)
- Profils GPU/MIG documentés et labelés (`docs/gpu-mig-profiles.md`)
- CI de validation (`.github/workflows/validate.yaml`)
- Checklist d’exploitation prod (`docs/production-readiness-checklist.md`)

## Documentation plateforme

- Vue d’ensemble professionnelle: `docs/platform-documentation.md`
- Guide de déploiement: `docs/deployment-guide.md`
- Roadmap d’implémentation: `docs/implementation-roadmap.md`
- Hardening V3: `docs/v3-enterprise-hardening.md`
- Plan de PR V3 -> main: `docs/pr-v3-to-main.md`

## Bootstrap one-shot cluster vierge

```bash
./scripts/bootstrap-one-shot.sh
```

## Prochaine étape

Voir `docs/implementation-roadmap.md` pour industrialiser (multi-cluster, multi-tenant, SSO, policy-as-code avancé).
