# Data Sovereignty Controls — ZONAAS

## Contrôles techniques
- Egress internet bloqué par défaut
- DNS autorisé uniquement vers résolveurs internes
- Stockage objet limité à endpoints privés
- Chiffrement TLS interne + rotation des certificats
- Secrets gérés par Vault (pas de secrets en clair dans manifests)

## Contrôles organisationnels
- Approbation SecOps pour toute exception réseau
- Journal d’exceptions avec date d’expiration
- Revue mensuelle des flux sortants autorisés
- Revue trimestrielle de conformité des namespaces LLM

## Contrôles applicatifs LLM
- Redaction PII sur logs applicatifs
- Interdiction de persister prompts bruts au-delà de la rétention définie
- Filtrage prompt injection et commandes out-of-scope
- Traçabilité utilisateur/app/source documentaire

## Contrôles de conformité (mapping simplifié)
- ISO27001: A.8, A.12, A.13, A.18
- SOC2: Security, Confidentiality
- RGPD: minimisation, limitation de conservation, sécurité de traitement
