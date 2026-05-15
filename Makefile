SHELL := /bin/bash

.PHONY: fmt validate tf-init tf-plan tf-apply k8s-lint bootstrap-gitops

fmt:
	terraform -chdir=terraform/environments/dev fmt -recursive

validate:
	terraform -chdir=terraform/environments/dev validate

k8s-lint:
	kubectl kustomize gitops/bootstrap >/dev/null
	kubectl kustomize gitops/apps/base >/dev/null

bootstrap-gitops:
	kubectl apply -f gitops/bootstrap/argocd-namespace.yaml
	kubectl apply -k gitops/bootstrap

tf-init:
	terraform -chdir=terraform/environments/dev init

tf-plan:
	terraform -chdir=terraform/environments/dev plan -var='cluster_name=mlz-dev' -var='environment=dev'

tf-apply:
	terraform -chdir=terraform/environments/dev apply -var='cluster_name=mlz-dev' -var='environment=dev'
