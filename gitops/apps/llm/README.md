# ZONAAS LLM Apps (Self-Hosted)

Ce dossier fournit des manifests GitOps pour démarrer une stack LLM souveraine:
- vLLM (API OpenAI-compatible interne)
- TGI (Text Generation Inference)
- NetworkPolicies deny-by-default
- ServiceMonitor pour observabilité
- ConfigMap de contrôle d’audit

## Principes de sécurité
- Tous les services en `ClusterIP`
- Namespace dédié `llm-platform`
- Labeling de classification (`zonaas/data-classification`)
- Egress limité par allowlist explicite

## Déploiement
```bash
kubectl apply -k gitops/apps/llm/base
```

## Important
Les images et chemins modèles sont des valeurs de démarrage.
En production, pointer vers:
- un registry interne approuvé
- des artefacts modèles hébergés en stockage privé interne
