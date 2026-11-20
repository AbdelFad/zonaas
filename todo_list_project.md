# To-Do List : Plan d'Amélioration Stratégique ZONAAS

*Créé automatiquement suite à l'audit du 03/07/2026.*
**Objectif:** Transformer les points de vigilance en tâches concrètes, séquencées et mesurables.

## 💡 Phase I : Stabilisation & Gouvernance (Court Terme)
Ces tâches visent à éliminer les risques latents identifiés par l'audit.

*   [ ] **Tâche 1 : Implémentation du Drift Detection (Terraform)**
    *   **Description:** Automatiser la vérification des dérives d'infrastructure entre l'état `tfstate` et l'environnement réel en production, en utilisant une politique de code (`Policy as Code`).
    *   **Dépendance:** Accès au pipeline CI/CD.
    *   **Critère de Complétion :** Déploiement réussi d'un plan de correction automatique pour un environnement non-conforme, sans intervention manuelle.

*   [ ] **Tâche 2 : Automatisation de la Rotation des Secrets (Vault)**
    *   **Description:** Créer un service ou une tâche CronJob dédiée qui vérifie et force le renouvellement cyclique des secrets critiques dans tous les consommateurs de services (Monitoring, Logging).
    *   **Dépendance:** Accès au mécanisme d'identité système.
    *   **Critère de Complétion :** Le renouvellement se fait automatiquement sans alerte manuelle pendant 24h et que le système reste stable.

## 🚀 Phase II : Avancement Fonctionnel (Moyen Terme)
Ces tâches implémentent les fonctionnalités à haute valeur ajoutée en utilisant l'architecture existante.

*   [ ] **Tâche 3 : Mise en œuvre de OpenTelemetry (Observabilité Corrélée)**
    *   **Description:** Intégrer un standard de traçage distribué dans tous les services pour pouvoir corréler un unique ID de transaction entre Loki, Prometheus et le code applicatif.
    *   **Dépendance :** Nécessite l'accès au code source des applications ML/DevOps critiques.
    *   **Critère de Complétion :** Réalisation d'un bout de souffle (end-to-end) où un bug est identifié en moins de 5 minutes, grâce à la corrélation des logs et métriques par l'ID unique.

## ✨ Phase III : Idéation & Évolution (Long Terme)
Ces tâches sont pour les cycles stratégiques futurs.

*   [ ] **Tâche N/A : Réflexion sur le Modèle de Revenus / Partenariats**
    *   **Description:** Étudier des modèles d'externalisation ou de monétisation basés sur l'expertise du système (ex: audit payant, licence de module).
    *   **Dépendance :** Discussion et recherche externes.

# Instructions pour le Suivi :
1.  Chaque fois qu'une tâche est complétée, elle doit être marquée `[COMPLETED]`.
2.  En cas d'échec ou de blocage, la tâche doit être mise à jour avec un commentaire explicatif et son statut passé en `BLOCKED` (et le rattrapage sera planifié).