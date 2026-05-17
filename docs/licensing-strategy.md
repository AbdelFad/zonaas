# Stratégie de licences (Trial / Free / Enterprise)

## Objectif
Mettre en place un modèle commercial progressif, techniquement contrôlable, et adapté à des budgets différents sans fragiliser la sécurité plateforme.

## 1) Modèle de packaging recommandé

### Trial (14 à 30 jours)
- Usage limité (CPU/GPU, requêtes/jour, nombre de projets)
- Connecteurs restreints
- Support communautaire
- Expiration automatique avec période de grâce (7 jours)

### Free
- 1 projet actif
- Pas de SSO entreprise
- Pas d’export audit avancé
- Quotas stricts (requests/minute, tokens/jour, stockage)

### Pro / Team
- Multi-projets
- SSO/OIDC, RBAC avancé
- Observabilité et alerting enrichis
- SLA standard

### Enterprise
- Souveraineté des données (no-egress, allowlist stricte)
- Audit trail complet + export SIEM
- Gouvernance (policy-as-code, séparation des rôles, approbations)
- Support prioritaire + SLA fort

## 2) Implémentation technique des licences

## 2.1 Service d’entitlements (source de vérité)
Créer un service interne `license-service` exposant:
- type de plan
- date d’expiration
- features activées
- quotas
- limites hard/soft

Format conseillé:
- clé signée (JWT/JWS) ou enregistrement DB signé
- champs minimaux: `tenant_id`, `plan`, `features[]`, `limits{}`, `exp`, `signature_version`

## 2.2 Enforcement côté plateforme
Appliquer les droits à 4 niveaux:
1. **API gateway**: rate limit, feature flags, blocage plan expiré
2. **Backstage / portail**: masquer actions non autorisées
3. **Kubernetes admission/policies**: empêcher ressources hors plan
4. **Workloads inference**: quotas tokens/requêtes par tenant

## 2.3 Feature flags orientés licence
- `feature.sso`
- `feature.audit_export`
- `feature.multi_project`
- `feature.private_model_registry`
- `feature.siem_integration`

Chaque feature doit avoir:
- règle de fallback
- message UX explicite en cas de refus
- métrique d’usage

## 2.4 Billing & cycle de vie
- Webhooks de facturation (création, renouvellement, annulation, échec de paiement)
- État licence: `active`, `grace_period`, `suspended`, `expired`
- Journal d’événements immuable (audit)

## 3) Gouvernance et sécurité liées aux licences

- Ne jamais faire confiance au front pour l’autorisation
- Vérifier la licence server-side sur chaque opération sensible
- Horodatage et validation de signature systématiques
- Rotation des clés de signature
- Anti-replay (nonce / jti) pour tokens d’entitlement
- Journaliser toutes les décisions d’autorisation

## 4) Contrôles de production (minimum)

- Tests E2E par plan (Trial/Free/Pro/Enterprise)
- Test d’expiration et de période de grâce
- Test de downgrade (Enterprise -> Free) sans fuite de privilèges
- Test de résilience si `license-service` indisponible (mode fail-safe défini)
- Dashboard d’erreurs d’autorisation

## 5) KPIs à suivre

- Taux de conversion Trial -> Payant
- Taux de refus d’opérations pour dépassement quota
- Erreurs d’enforcement de licence
- Temps moyen de propagation d’un changement de plan

## 6) Plan de rollout

1. Implémenter `license-service` + schéma entitlement
2. Intégrer enforcement gateway + API
3. Ajouter tests E2E par plan
4. Activer facturation et webhooks
5. Activer gouvernance Enterprise (audit/SIEM/policies)

---

Ce document couvre la structure produit et les points techniques nécessaires pour monétiser sans compromettre la posture sécurité/ops en environnement entreprise.
