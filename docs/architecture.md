# Architecture ZONAAS

> Nomenclature officielle : **ZONAAS** (nom court), **ML Landing Zone as a Service** (nom original), alias **MLLZONAAS**.

## 1) Vue d’ensemble

ZONAAS implémente une architecture en **2 plans** :

- **Control Plane** : gouvernance, self-service, GitOps, sécurité transverse
- **Execution Plane** : exécution des workloads ML par projet/équipe/environnement

Objectif : délivrer des environnements ML standardisés, sécurisés et pilotés par Git.

## 2) Schéma d’architecture (pro, clair)

```mermaid
flowchart TB
  %% Actors
  U["Data Scientist / ML Engineer"]
  P["Platform Team"]

  %% Control Plane
  subgraph CP["Control Plane (ZONAAS)"]
    B["Backstage\nProject Scaffolder"]
    G["Git Repositories\n(platform + projects)"]
    T["Terraform Modules\nNamespaces / Quotas / Labels"]
    A["ArgoCD + ApplicationSet\nGitOps Sync"]
    V["Vault\nSecrets Management"]
    K["Kyverno\nPolicy-as-Code"]
  end

  %% Execution Plane
  subgraph EP["Execution Plane (Kubernetes Clusters)"]
    N1["Namespace Team A - dev/prod"]
    N2["Namespace Team B - dev/prod"]
    W["ML Workloads\nTraining / Serving / Pipelines"]
    O["Observability\nPrometheus + Grafana"]
    C["FinOps\nKubeCost"]
  end

  U -->|"Self-service request"| B
  P -->|"Governance + templates"| B
  B -->|"Scaffold project repo"| G
  G -->|"Desired state"| A
  T -->|"Provision guardrails"| N1
  T -->|"Provision guardrails"| N2
  A -->|"Deploy apps/manifests"| N1
  A -->|"Deploy apps/manifests"| N2
  V -->|"Secrets injection"| W
  K -->|"Admission control"| W
  N1 --> W
  N2 --> W
  W --> O
  W --> C

  classDef control fill:#0f2a43,stroke:#5eead4,color:#d1fae5;
  classDef exec fill:#2a1a4a,stroke:#c4b5fd,color:#ede9fe;
  classDef ops fill:#3f2a12,stroke:#fbbf24,color:#fef3c7;

  class B,G,T,A,V,K control;
  class N1,N2,W exec;
  class O,C ops;
```

## 3) Flux opérationnel principal

1. Le Data Scientist demande un nouveau projet via **Backstage**.
2. Le Scaffolder génère le repo projet (template ML + conventions GitOps).
3. **Terraform** provisionne namespace(s), quotas, labels, policies de base.
4. **ArgoCD/ApplicationSet** synchronise automatiquement les workloads.
5. **Vault + Kyverno + NetworkPolicies** appliquent la posture sécurité.
6. **Prometheus/Grafana/KubeCost** donnent visibilité opérationnelle et coûts.

## 4) Séparation des plans

### Control Plane

- Repo plateforme, templates, modules IaC
- Politiques globales (sécurité / conformité)
- Orchestration GitOps multi-projets

### Execution Plane

- Namespaces projets (`<team>-<env>`)
- Workloads ML (train/serve/pipeline)
- Isolation réseau/ressources par tenant

## 5) Principes cloud-agnostic

- Manifests Kubernetes standards pour la couche core
- Variantes cloud encapsulées via overlays et modules Terraform
- Pas de dépendance forte à un provider unique dans le cœur plateforme

## 6) Frontière de responsabilité

- **Platform Team** : standards, sécurité, templates, gouvernance, SLO
- **Équipes ML** : code métier, modèles, pipelines, métriques applicatives

## 7) Extensions recommandées

- SSO/RBAC centralisé (OIDC)
- Policy bundles conformité par niveau (standard/strict)
- Environnements éphémères preview pour projets ML
