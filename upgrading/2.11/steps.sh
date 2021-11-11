#!/bin/env bash
source ../../demo-magic.sh
clear

k3d cluster delete linkerd > /dev/null 2>&1 || true
k3d cluster create linkerd -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-server-arg '--no-deploy=traefik'
export LINKERD2_VERSION=stable-2.10.2 ; curl -sL https://run.linkerd.io/install | sh > /dev/null 2>&1 || true
unset LINKERD2_VERSION
wait 
clear

linkerd install | kubectl apply -f - && linkerd check
linkerd viz install | kubectl apply -f - && linkerd check
curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -
wait
clear

pe "linkerd version"
wait
clear

pe "linkerd check"
wait
clear

pe "curl -sL https://run.linkerd.io/install | sh"
wait
clear

pe "linkerd version"
wait
clear

pe "linkerd upgrade | kubectl apply --prune -l linkerd.io/control-plane-ns=linkerd -f -"
wait
clear

pe "linkerd upgrade | kubectl apply --prune -l linkerd.io/control-plane-ns=linkerd \
  --prune-whitelist=rbac.authorization.k8s.io/v1/clusterrole \
  --prune-whitelist=rbac.authorization.k8s.io/v1/clusterrolebinding \
  --prune-whitelist=apiregistration.k8s.io/v1/apiservice -f -"
wait
clear

pe "linkerd check"
wait
clear

pe "linkerd viz install | kubectl apply -f -"
wait
clear

pe "linkerd check"
wait
clear

pe "kubectl rollout restart deployment -n emojivoto"
wait
clear

pe "linkerd viz dashboard"
wait
clear

pe "kubectl annotate namespaces emojivoto \"config.linkerd.io/default-inbound-policy=deny\""
wait
clear

pe "kubectl rollout restart deployment -n emojivoto"
wait
clear

# pe "watch kubectl get pods"
# wait
# clear

pe "curl -sL https://run.linkerd.io/emojivoto-policy.yml | kubectl apply -f -"
wait
clear

pe "kubectl rollout restart deployment -n emojivoto"
wait
clear

pe "linkerd viz dashboard"
wait
clear