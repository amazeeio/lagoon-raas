.DEFAULT_GOAL:=help
SHELL:=/bin/bash
NAMESPACE=lagoon-raas
K8S_CLI=oc
IMAGE=8thom/lagoon-raas:v0.0.2

##@ Application

build: 
	- operator-sdk build ${IMAGE}
	- docker push ${IMAGE}

install: ## Install all resources (CR/CRD's, RBAC and Operator)
	@echo ....... Creating namespace ....... 
	- ${K8S_CLI} create namespace ${NAMESPACE}
	@echo ....... Applying CRDS and Operator .......
	- ${K8S_CLI} apply -f deploy/crds/amazee.io_redisservices_crd.yaml -n ${NAMESPACE}
	@echo ....... Applying Rules and Service Account .......
	- ${K8S_CLI} apply -f deploy/role.yaml -n ${NAMESPACE}
	- ${K8S_CLI} apply -f deploy/role_binding.yaml  -n ${NAMESPACE}
	- ${K8S_CLI} apply -f deploy/service_account.yaml  -n ${NAMESPACE}
	@echo ....... Applying Operator .......
	- ${K8S_CLI} apply -f deploy/operator.yaml -n ${NAMESPACE}
	@echo ....... Creating the Database .......
	- ${K8S_CLI} apply -f deploy/crds/amazee.io_v1alpha1_redisservice_cr.yaml -n ${NAMESPACE}

uninstall: ## Uninstall all that all performed in the $ make install
	@echo ....... Uninstalling .......
	@echo ....... Deleting CRDs.......
	- ${K8S_CLI} delete -f deploy/crds/amazee.io_redisservices_crd.yaml -n ${NAMESPACE}
	@echo ....... Deleting Rules and Service Account .......
	- ${K8S_CLI} delete -f deploy/role.yaml -n ${NAMESPACE}
	- ${K8S_CLI} delete -f deploy/role_binding.yaml -n ${NAMESPACE}
	- ${K8S_CLI} delete -f deploy/service_account.yaml -n ${NAMESPACE}
	@echo ....... Deleting Operator .......
	- ${K8S_CLI} delete -f deploy/operator.yaml -n ${NAMESPACE}
	@echo ....... Deleting namespace ${NAMESPACE}.......
	- ${K8S_CLI} delete namespace ${NAMESPACE}

test:
	molecule test -s test-local

converge:
	molecule converge -s test-local

.PHONY: build help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
