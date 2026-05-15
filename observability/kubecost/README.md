# KubeCost Integration

1. Installer Kubecost (Helm chart officiel)
2. Mapper les labels namespace:
   - `mlz/cost-center`
   - `mlz/owner`
3. Créer des vues coût par namespace projet

Exemple query (Kubecost API):
- coût GPU mensuel par namespace
- coût CPU/RAM journalier
