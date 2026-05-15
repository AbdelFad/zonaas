# Guide de déploiement (On-Prem & Cloud)

## On-Prem
1. Pointer `kube_context` vers le cluster on-prem
2. Appliquer `terraform/environments/dev`
3. Bootstrap ArgoCD depuis `gitops/bootstrap`
4. Déployer overlays `gitops/apps/overlays/onprem`

## AWS (EKS)
1. Configurer kubeconfig EKS
2. Appliquer `terraform/environments/aws`
3. Utiliser overlay `gitops/apps/overlays/aws`

## Azure (AKS)
1. Configurer kubeconfig AKS
2. Appliquer `terraform/environments/azure`
3. Utiliser overlay `gitops/apps/overlays/azure`

## GCP (GKE)
1. Configurer kubeconfig GKE
2. Appliquer `terraform/environments/gcp`
3. Utiliser overlay `gitops/apps/overlays/gcp`
