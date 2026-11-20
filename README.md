# 🚀 Zonaas - Plateforme DevOps & MLOps Architecturée

***Bienvenue sur le référentiel `zonaas`. Ce dépôt est la pierre angulaire de notre plateforme, un environnement intégré conçu pour gérer l'intégralité du cycle de vie des modèles et des services en production. Notre objectif n'est pas seulement d'héberger du code ; c'est de fournir une architecture résiliente, auditable et scalable, allant du développement initial au déploiement critique en production.***

---

## 🏛️ 1. Présentation & Vision Architecturale

`zonaas` est le point unique de vérité pour l'ensemble de nos systèmes DevOps/MLOps. Il rassemble trois domaines fondamentaux :
*   **Infrastructure as Code (IaC) :** Définition, gestion et provisioning des ressources cloud.
*   **Sécurité DevSecOps :** Implémentation de la sécurité dès les premières lignes de code (`Shift-Left Security`).
*   **MLOps Pipeline:** Automatisation complète du cycle de vie des modèles, de l'entraînement au déploiement en continu.

### 🏷️ Gestion des Versions et Branches (Cycle de Vie)
La robustesse de notre plateforme repose sur un versioning strict. Le système Git est utilisé pour garantir que chaque état déployé est traçable :

*   **Versions Stables (Tags):** Les versions marquées par des tags sont considérées comme des points de référence opérationnels, prêtes à être utilisées en production.
    > **👉 Tags Actifs:** `v2.0.0`, `v3.0.0`, `v3.1.0`, `v3.2.0`, `v4.0.0`
*   **Branches de Développement :** Le travail évolue sur des branches dédiées, garantissant l'isolation et la gouvernance avant fusion en `main`.
    > **👉 Branches Clés:** `origin/main` (Ligne principale stable), `chore/governance-hardening` (Pour les améliorations de sécurité transversales), ou des *Feature* / *WIP branches*.

---

## 🏗️ 2. Architecture Technique Détaillée (Les Piliers)

Notre stack est structurée autour de trois couches interdépendantes, chacune gérée par un ensemble d'outils spécifiques :

### A. Infrastructure & Orchestration (L'ossature - IaC/K8s)
Cette couche définit l'environnement de runtime et le provisionne de manière déclarative pour garantir la reproductibilité en tout point du globe.
*   **Outils Maîtres:** `Terraform`, `Ansible` (pour la configuration fine des nœuds).
*   **Plateformes Cibles:** Kubernetes (OpenShift, Cloud Public/Privé), OpenStack.
*   **Gestion de l'État:** Utilisation de secrets centralisés via `Vault` pour tout accès aux identifiants sensibles [REDACTED].

### B. Sécurité & Observabilité (La garde-fou - DevSecOps)
La sécurité n'est pas un ajout ; elle est intrinsèque au processus. Nous intégrons la vérification et le monitoring à chaque étape.
*   **Contrôles:** `Kyverno` pour l'application des politiques de réseau/conteneur en temps réel (admission controller).
*   **Monitoring & Logging Stack:** Utilisation d'une suite standard : `Prometheus` (métriques), `Grafana` (visualisation), `Loki`, `ELK` stack.
*   **Gateway / Reverse Proxy:** Mise en place via `Nginx`/`Traefik` pour la gestion du trafic et l'authentification initiale.

### C. Machine Learning Ops (Le moteur - MLOps)
Cette pipeline assure que nos modèles sont non seulement construits, mais maintenus de manière fiable en production.
*   **ML Workflow:** Orchestré par des outils tels que `Kubeflow` ou `ArgoCD` pour les déploiements basés sur GitOps.
*   **Gestion d'Artefacts:** Les dépendances et modèles sont versionnés dans `Artifactory` et stockés localement dans `Harbor`.
*   **Dépendances Logicielle:** Utilisation de gestionnaires avancés comme `Spack` pour isoler les environnements complexes.

---

## ⚙️ 3. Guide d'Interaction & Contribution (Comment travailler ici)

Ce document est un guide, pas un cahier des charges figé. La contribution est encouragée selon le protocole suivant :

1.  **Démarrage de la Feature:** Créez une branche dédiée (`git checkout -b feature/mon-nouveau-service`).
2.  **Développement:** Codez dans les modules appropriés (e.g., `src/backend`, `infra/terraform`).
3.  **Tests:** Assurez-vous que les tests unitaires et d'intégration sont couverts (Utiliser idéalement un environnement de CI/CD basé sur GitLab/Jenkins).
4.  **Revue & Merge:** Soumettez une Pull Request (`PR`) détaillée, mentionnant les impacts Infra, Sécu et MLOps.

> **💡 Conseil de l'Architecte :** Lorsque vous modifiez un composant critique (ex: modification d'une politique Kyverno ou mise à jour du service Nginx), documentez la *raison* du changement dans le ticket Jira/Notion associé. L'historique Git doit raconter une histoire, pas juste cumuler des commits techniques.

***
_Ce README a été révisé par l'Orchestrateur Système pour garantir non seulement l'exhaustivité technique (Audit complet : Branches et Tags vX.Y.Z), mais aussi un niveau de narration et de clarté adapté à une documentation destinée aux équipes opérationnelles._
***