# Runbook — Incident suspected data exfiltration (LLM)

## Détection
Triggers possibles:
- alert egress inattendue depuis namespace LLM
- requêtes vers domaines externes non autorisés
- volume anormal de tokens sortants

## Réponse immédiate (T0-T15)
1. Basculer namespace concerné en isolement (deny-all egress)
2. Geler déploiements ArgoCD du namespace
3. Capturer événements/k8s audit logs et snapshots configs
4. Notifier SecOps + owner produit

## Investigation (T15-T120)
1. Identifier workload source (pod/service account/image digest)
2. Corréler audit-id applicatif avec traces SIEM
3. Vérifier exceptions réseau actives et expirations
4. Évaluer type de données potentiellement exposées

## Remédiation
- Révoquer secrets/tokens
- Forcer rotation certificats
- Corriger policy ou pipeline ayant permis l’écart
- Déployer patch validé via PR + CI

## Post-mortem
- RCA sous 48h
- Actions préventives tracées
- Mise à jour documentation + policy packs
