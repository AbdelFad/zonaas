# GPU / MIG Profiles

## But
Standardiser la consommation GPU par classes de projets.

## Profils recommandés
- `small`: 1g.10gb (petits batchs, fine-tuning léger)
- `medium`: 2g.20gb (entraînement moyen)
- `large`: 3g.40gb ou GPU dédié

Le module Terraform annote le namespace avec `zonaas/gpu-profile`.
Ces labels peuvent être utilisés par:
- admission policies
- scheduler constraints
- dashboards FinOps par profil
