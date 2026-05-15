# V4 Roadmap — ZONAAS Sovereign LLM Platform

## Vision
Permettre aux entreprises de **déployer, servir et gouverner leurs LLM en interne** avec une posture **data sovereignty first** : aucune donnée sensible ne sort du périmètre de l’entreprise sans exception approuvée.

## Objectifs V4
1. Exécution LLM self-hosted standardisée (vLLM/TGI)
2. No-egress strict + sécurité zero trust intra-cluster
3. Gouvernance et audit des usages prompts/réponses
4. Conformité entreprise (ISO27001/SOC2/RGPD mapping)
5. UX plateforme orientée adoption métier et sécurité

## Architecture cible
Voir `docs/sovereign-llm-architecture.md`.

## Plan 90 jours

### Phase 1 (J1-J30) — Fondations sécurité
- Policy packs Kyverno LLM (classification, exposition, egress mode)
- Namespaces LLM dédiés + NetworkPolicies deny-by-default
- Templates de déploiement self-hosted vLLM/TGI
- Checklist de contrôles de sortie de données

### Phase 2 (J31-J60) — Opérations LLM
- ServiceMonitor LLM + dashboards latence/tokens/coûts
- Audit trail des inférences (app + gateway + SIEM)
- Runbook incident exfiltration / prompt injection
- Baselines DLP/redaction dans les logs

### Phase 3 (J61-J90) — Gouvernance & adoption
- Model catalog interne validé par la plateforme
- Pipeline d’évaluation sécurité/qualité avant promotion
- Parcours frontend “Deploy / Govern / Observe”
- Pack conformité et dossier d’audit standardisé

## KPI de succès
- 100% des services LLM en ClusterIP (0 exposition publique)
- 100% des namespaces LLM en `deny-all` + allowlist explicite
- < 15 min pour provisionner un endpoint LLM interne
- 100% des appels inférence traçables (audit ID)

## Risques & mitigations
- Risque: contournement egress via exceptions ad hoc
  - Mitigation: exceptions temporisées + approbation SecOps
- Risque: coûts GPU mal maîtrisés
  - Mitigation: profils capacité + budget alerts + autoscaling policy
- Risque: faible adoption
  - Mitigation: templates prêts à l’emploi + documentation “golden paths”
