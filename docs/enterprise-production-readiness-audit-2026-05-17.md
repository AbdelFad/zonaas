# Audit Enterprise Production Readiness — ZONAAS

_Date: 2026-05-17_

## Portée et méthode

Audit statique du repo avec vérification des manifests/policies/docs + rendu Kustomize.

### Vérifications exécutées
- `kubectl kustomize gitops/bootstrap`
- `kubectl kustomize policies/kyverno`
- `kubectl kustomize gitops/apps/llm/base`
- `kubectl kustomize gitops/apps/overlays/onprem`
- `kustomize build gitops/apps/llm/base`

### Limite runtime
- Validation cluster (`kubectl apply --dry-run` contre API server) impossible ici: pas de cluster/kube-apiserver accessible (`localhost:8080` refusé).

---

## Résumé exécutif

- **Sécurité:** **WARN**
- **Gouvernance/Conformité:** **WARN**
- **Fiabilité/Opérations:** **WARN**
- **Contrôles commerciaux (licensing/enforcement):** **WARN**

**Conclusion globale: WARN (pas encore prêt “enterprise production” sans patchs complémentaires).**

---

## Checklist détaillée (PASS/WARN/FAIL)

## 1) Sécurité

- **PASS** — Pas d’image `:latest` dans les workloads déployés (`vllm`, `tgi`).
- **PASS** — `runAsNonRoot: true` présent au pod/container pour `vllm` et `tgi`.
- **PASS** — `allowPrivilegeEscalation: false` et `readOnlyRootFilesystem: true` présents côté containers.
- **PASS** — `seccompProfile: RuntimeDefault` présent au niveau pod.
- **PASS** — Services LLM en `ClusterIP` (`vllm-service`, `tgi-service`).
- **PASS** — NetworkPolicy `default-deny-all` + exceptions DNS/object-store présentes.
- **WARN** — Policy Kyverno `require-pod-security-context` n’impose pas explicitement `seccompProfile` (couvert par manifestes, pas par garde-fou global).
- **FAIL** — Policy `allowed-registries.yaml` semble incorrecte (pattern unique `"registry.../* | ghcr.../*"`), risque de non-application réelle.

## 2) Gouvernance / conformité

- **PASS** — Labels souveraineté LLM présents (`zonaas/tenant-type`, `zonaas/egress-mode`, `zonaas/data-classification`).
- **PASS** — Policies Kyverno critiques en `Enforce` (latest tag, endpoints publics LLM, labels).
- **WARN** — Checklist `docs/production-readiness-checklist.md` encore majoritairement non cochée et non reliée à une preuve automatisée.
- **WARN** — AppProject ArgoCD restreint sur `sourceRepos`, mais autorisation namespace resources très large (`group: '*'`, `kind: '*'`).

## 3) Fiabilité / opérations

- **PASS** — ServiceMonitor LLM présent.
- **WARN** — Pas de probes `livenessProbe/readinessProbe/startupProbe` visibles sur `vllm` et `tgi`.
- **WARN** — Pas de PDB/HPA/VPA dédiés sur workloads LLM.
- **WARN** — Pas de strategy explicite (rolling/canary) ni guardrails de disruption pour inferencing.

## 4) Contrôles commerciaux (licensing/enforcement)

- **PASS** — `docs/licensing-strategy.md` couvre Trial/Free/Pro/Enterprise, entitlements, enforcement, lifecycle.
- **WARN** — Implémentation technique (`license-service`, enforcement gateway/API, quotas runtime) pas encore matérialisée dans manifests/code.
- **WARN** — Tests E2E par plan et tests de downgrade/expiry non présents dans CI.

## 5) CI / Quality gates sécurité

- **PASS** — Workflow `.github/workflows/validate.yaml` valide Terraform + kustomize build.
- **WARN** — Pas de job policy testing (Kyverno tests), pas de scan manifest security (kube-linter/kube-score/polaris), pas de scan secrets (gitleaks/trufflehog).
- **WARN** — Pas de tests de régression sécurité (ex: service LLM en LoadBalancer rejeté, label classification manquant rejeté).

---

## Registre de risques priorisé

1. **R1 (Élevé)** — `allowed-registries` potentiellement non fonctionnelle -> images non approuvées peuvent passer.
2. **R2 (Élevé)** — Absence de RBAC dédié namespace LLM (least privilege incomplet pour opérateurs/workloads).
3. **R3 (Moyen/Élevé)** — Secrets management non industrialisé pour workloads LLM (pas d’ExternalSecret/CSI/KMS visible).
4. **R4 (Moyen)** — CI sans tests de régression policy -> risque de réintroduire des régressions de conformité.
5. **R5 (Moyen)** — Pas de probes/PDB/HPA -> risque SLO/SLA en charge/incident.

---

## Verdict

Base solide et nette progression, mais pour un niveau **enterprise prod**, il manque encore des garde-fous automatisés (RBAC/secrets/CI security regression) et 1 correction policy importante (`allowed-registries`).
