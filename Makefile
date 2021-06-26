# author: zeeshan
# email: zeeshanelsyed@gmail.com
ns ?= mongodb-sharded-ns
lpath ?= ./src
release ?= mongodb-sharded
mrp ?= root

red=$(shell tput setaf 1)
green=$(shell tput setaf 2)
yellow=$(shell tput setaf 3)
blue=$(shell tput setaf 4)
purple=$(shell tput setaf 5) 
end=$(shell tput sgr0)
$(shell printf " $(red)Namespace$(end): $(ns)\n\
$(green)Chart$(end): $(chart)\n\
$(yellow)Create Namespace$(end): $(blue)$(cn)$(end)\n" 1>&2)


help:
	@printf "\n--------> $(green)Description$(end): $(yellow)deploy Mongodb Sharded$(end) <--------\n"
	@printf " *)$(purple)$/{Parameters}$(end) : {Required} : $/{Description} : $/{Usage}\n\
	 1)$(purple)ns$(end): required : namespace value : make $/{target} ns=yournamespace\n\
	 2)$(purple)chart$(end): optional :Operator Chart : make $/{target} chart=desriredoperatorchart\n\
	 4)$(purple)lpath$(end): optional :local path for charts : make $/{target} lpath=localpath\n\
	 5)$(purple)release$(end): optional : helm release name : make $/{target} release=name\n"
	 5)$(purple)valuesFile$(end): optional : helm release name : make $/{target} valuesFile=filename\n"
	 6)$(purple)mrp$(end): optional : helm release name : make $/{target} mrp=pasword\n"
	 @printf "\n ------------> Examples <------------\n\
	 1) $(green)make $/{target} ns=namespace lpath=./charts/ release=openebs$(end)\n\
	 2) $(green)make $/{target} ns=namespace chart=chartname$(end)\n"

.PHONY: nsCheck
nsCheck:
	@if [ "Error from server (NotFound): namespaces $(ns) not found" != "`kubectl get ns $(ns)`" ]; then \
		cn= ; \
	fi
.PHONY: defaultcmdRun
defaultcmdRun:
	helm repo add bitnami https://charts.bitnami.com/bitnami && \
	helm repo update
createns:
	kubectl create ns $(ns)
deletens:
	kubectl delete ns $(ns)
install-remote:
	helm install $(release) bitnami/mongodb-sharded --namespace=$(ns) --debug | cat > $(release)-dry-run.yaml
install:
	helm install $(release) $(lpath) --namespace=$(ns) --set mongodbRootPassword=$(mrp)  --debug | cat > $(release)-dry-run.yaml
upgrade:
	helm upgrade $(release) $(lpath) --namespace=$(ns) --debug | cat > $(release)-dry-run.yaml	
debug:
	helm template --name-template=$(release) $(lpath) | cat > $(release).dry-run.yaml
uninstall:
	helm uninstall $(release) --namespace=$(ns)  && $(MAKE) clean
clean:
	rm -r *dry-run.yaml
rke-yaml:
	helm template --name-template=$(release) $(lpath) --namespace=$(ns) | cat > $(release).yaml
provision-hostpath:
	helm repo add rimusz https://charts.rimusz.net && helm repo update && helm upgrade --install hostpath-provisioner --namespace kube-system rimusz/hostpath-provisioner
# && deletens