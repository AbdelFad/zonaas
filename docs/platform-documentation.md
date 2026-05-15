# ZONAAS — Documentation Plateforme

## 1) Résumé exécutif

**ZONAAS** est la marque courte de la plateforme **ML Landing Zone as a Service** (alias: **MLLZONAAS**). Elle standardise le provisioning d’environnements ML via un modèle **self-service contrôlé**.

Objectifs:
- Accélérer l’onboarding projets ML
- Garantir un socle sécurité/observabilité/FinOps homogène
- Réduire la dérive entre environnements (dev, preprod, prod)

Piliers techniques:
- **Kubernetes** pour l’exécution
- **Terraform** pour l’infrastructure déclarative
- **ArgoCD (GitOps)** pour la convergence applicative
- **Backstage** pour le portail développeur
- **Kyverno/Vault/Prometheus/Grafana/KubeCost** pour la gouvernance opérationnelle

---

## 2) Portée de la plateforme

### Inclus
- Provisioning de namespaces/projets ML isolés
- Déploiement GitOps des composants plateforme
- Baselines sécurité (quotas, policies, restrictions réseau)
- Observabilité initiale (métriques + dashboards)
- Documentation d’exploitation et de hardening V3

### Non inclus (à intégrer selon contexte client)
- IAM/SSO d’entreprise (Azure AD/Okta/Keycloak)
- Gestion certifiée des secrets HSM/KMS externes
- Runbooks SOC/SIEM complets
- Processus CAB/Change Management spécifiques

---

## 3) Architecture de référence

### Control Plane
- Backstage (catalogue + scaffolder)
- ArgoCD (sync applicatif)
- Terraform (provisioning infra)
- Référentiels Git (source of truth)

### Execution Plane
- Cluster(s) Kubernetes cibles
- Namespaces ML par équipe/projet
- Services MLOps (pipelines, notebooks, serving)

Consulter aussi: `docs/architecture.md`

---

## 4) Flux opérationnel standard

1. L’équipe plateforme définit les politiques globales et templates.
2. Un projet ML est créé via template Backstage.
3. Le repo projet embarque sa configuration GitOps.
4. ArgoCD déploie automatiquement vers l’environnement cible.
5. Les garde-fous sécurité/coût s’appliquent par défaut.
6. L’exploitation supervise via Grafana/KubeCost/alerting.

---

## 5) Environnements et branches

- `main`: baseline V2 stable
- `v2-stable`: référence release V2
- `v3-prod-hardening`: hardening entreprise (ArgoCD, egress, PSS, gouvernance)

Tags release recommandés:
- `v2.0.0`
- `v3.0.0`

---

## 6) Bootstrap cluster vierge

Script one-shot:

```bash
./scripts/bootstrap-one-shot.sh
```

Options:

```bash
./scripts/bootstrap-one-shot.sh --context <kube-context> --namespace argocd
```

Le script:
- vérifie les prérequis CLI
- applique le bootstrap ArgoCD
- applique les policies Kyverno
- affiche les commandes de vérification

---

## 7) Sécurité et conformité

Contrôles de base:
- segmentation réseau deny-by-default
- contraintes images/ressources/securityContext
- labels de gouvernance (coût, criticité, conformité)
- séparation des responsabilités (plateforme vs utilisateurs ML)

Hardening avancé V3:
- AppProject ArgoCD restreint (repo/destination allowlist)
- egress autorisé uniquement vers dépendances nécessaires
- adoption PSS `restricted`

Références:
- `docs/production-readiness-checklist.md`
- `docs/v3-enterprise-hardening.md`

---

## 8) SRE / Exploitation

Indicateurs clés:
- disponibilité control-plane (ArgoCD, Vault)
- taux d’échec sync GitOps
- saturation ressources namespaces
- coût par projet et par environnement

Rituels recommandés:
- revue hebdo des exceptions politiques
- revue mensuelle coût/performance
- test trimestriel de restauration et reprise

---

## 9) Processus de release

1. Validation CI (`scripts/validate.sh` + workflow GitHub)
2. Tag release sémantique
3. Publication notes de version
4. Promotion vers environnement supérieur
5. Contrôle post-déploiement

---

## 10) Documentation associée

- `README.md`
- `docs/deployment-guide.md`
- `docs/implementation-roadmap.md`
- `docs/architecture.md`
- `docs/production-readiness-checklist.md`
- `docs/v3-enterprise-hardening.md`
