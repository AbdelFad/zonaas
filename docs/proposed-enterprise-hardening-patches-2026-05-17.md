# Propositions de patchs supplémentaires (RBAC, secrets, CI policies, tests régression sécurité)

_Objectif: passer de WARN à PASS sur les points enterprise critiques._

## Patch Set A — RBAC (least privilege)

### A1. Ajouter un ServiceAccount dédié par workload LLM
- `gitops/apps/llm/base/sa-vllm.yaml`
- `gitops/apps/llm/base/sa-tgi.yaml`

### A2. Ajouter Role/RoleBinding minimaux namespace `llm-platform`
- `gitops/apps/llm/base/role-llm-runtime-readonly.yaml`
- `gitops/apps/llm/base/rolebinding-llm-runtime-readonly.yaml`

Permissions proposées (minimum):
- read-only sur ConfigMaps nécessaires
- pas d’accès Secret direct
- pas de verbes write cluster-scope

### A3. Binder SA dans `vllm-deployment.yaml` et `tgi-deployment.yaml`
```yaml
spec:
  template:
    spec:
      serviceAccountName: vllm-sa   # ou tgi-sa
      automountServiceAccountToken: false
```

---

## Patch Set B — Secrets management

### B1. Interdire les secrets en clair dans le repo
- Introduire SOPS (age/KMS) ou External Secrets Operator (ESO).

### B2. Pattern recommandé (ESO)
- `gitops/apps/llm/base/externalsecret-llm-credentials.yaml`
- backend: Vault/KMS/Secrets Manager
- refresh interval + labels de rotation

### B3. Policy Kyverno anti-secret-inline
- `policies/kyverno/disallow-inline-sensitive-env.yaml`
- rejeter `env.value` sur clés sensibles (`*TOKEN*`, `*PASSWORD*`, `*API_KEY*`), imposer `valueFrom.secretKeyRef`.

---

## Patch Set C — CI policy checks renforcés

Étendre `.github/workflows/validate.yaml` avec jobs supplémentaires:

### C1. Kyverno policy testing
- Installer `kyverno-cli`
- Ajouter dossier tests: `policies/kyverno/tests/*.yaml`
- Exécuter:
```bash
kyverno test policies/kyverno/tests
```

### C2. Manifest security lint
- kube-linter (ou kube-score/polaris)
```bash
kube-linter lint gitops/apps/llm/base
```

### C3. Scan secrets
- gitleaks
```bash
gitleaks detect --source . --redact
```

### C4. Conftest/OPA optionnel
- règles custom sur conventions `zonaas/*` labels + egress mode.

---

## Patch Set D — Tests de régression sécurité (obligatoires)

Créer des fixtures négatives/positives pour empêcher toute régression:

### D1. `disallow-public-llm-endpoints`
- **Doit FAIL:** Service LLM type `LoadBalancer`
- **Doit PASS:** Service LLM type `ClusterIP`

### D2. `require-llm-data-classification-label`
- **Doit FAIL:** Deployment LLM sans `zonaas/data-classification`
- **Doit PASS:** avec label conforme

### D3. `disallow-latest-tag`
- **Doit FAIL:** image `:latest`
- **Doit PASS:** image pinée

### D4. `require-pod-security-context`
- **Doit FAIL:** container sans `readOnlyRootFilesystem`/`allowPrivilegeEscalation: false`
- **Doit PASS:** manifestes durcis

---

## Patch Set E — Corrections ciblées immédiates

### E1. Corriger `policies/kyverno/allowed-registries.yaml`
Le pattern actuel semble invalide pour une allowlist multi-registry.

Approche robuste recommandée:
- utiliser `foreach` + `AnyIn`/regex explicite
- ou `verifyImages` avec règles registry autorisées

### E2. Corriger portée namespace de `require-resources.yaml`
Actuellement: `namespaces: [ml-*]` alors que LLM est dans `llm-platform`.

Action:
- inclure `llm-platform`
- ou basculer vers un match basé label namespace (`zonaas/tenant-type=llm`).

### E3. Ajouter probes + PDB
- `readinessProbe`, `livenessProbe`, `startupProbe` sur `vllm`/`tgi`
- `PodDisruptionBudget` minAvailable=1 (ou selon SLO)

---

## Ordre d’implémentation recommandé (rapide → impact)

1. **E1 + E2** (corriger policies critiques)
2. **C1 + D1..D4** (gates CI + régression)
3. **A1..A3** (RBAC workload)
4. **B1..B3** (secrets industrialisés)
5. **E3** (fiabilité/SLA)

---

## Critères de sortie (pour passer en PASS)

- Policies Kyverno validées par tests automatiques en CI
- RBAC namespace LLM least-privilege appliqué
- Secrets sans clair dans repo + rotation définie
- Régression sécurité couverte (FAIL/PASS fixtures)
- Workloads LLM avec probes + PDB
