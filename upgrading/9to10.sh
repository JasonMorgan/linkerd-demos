#!/bin/env bash
source ../demo-magic.sh
clear

k3d cluster delete myapp > /dev/null 2>&1 || true
k3d cluster create myapp -p "8081:80@loadbalancer"
rm ~/.linkerd2/bin/linkerd-stable-2.9.4 > /dev/null 2>&1 || true
rm ~/.linkerd2/bin/linkerd-stable-2.10.0 > /dev/null 2>&1 || true
export LINKERD2_VERSION=stable-2.9.4 ; curl -sL https://run.linkerd.io/install | sh # > /dev/null 2>&1 || true
unset LINKERD2_VERSION
wait 
clear
kubectl create ns booksapp
kubectl ns booksapp
kubectl apply -f ~/git_repos/buoyant/booksapp/k8s/mysql-backend.yml
kubectl apply -f ~/git_repos/buoyant/booksapp/k8s/mysql-app.yml
kubectl apply -f artifacts/
wait
linkerd install | kubectl apply -f -
linkerd check
kubectl get deploy -n booksapp -o yaml | linkerd inject - | kubectl apply -f -
kubectl get deploy -n kube-system -o yaml traefik | linkerd inject - | kubectl apply -f -
curl -sL https://run.linkerd.io/booksapp/webapp.swagger | linkerd -n booksapp profile --open-api - webapp | kubectl -n booksapp apply -f -
curl -sL https://run.linkerd.io/booksapp/authors.swagger | linkerd -n booksapp profile --open-api - authors | kubectl -n booksapp apply -f -
curl -sL https://run.linkerd.io/booksapp/books.swagger | linkerd -n booksapp profile --open-api - books | kubectl -n booksapp apply -f -
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

pe "linkerd viz check"
wait
clear

pe "kubectl rollout restart deployment -n booksapp"
wait
clear

pe "linkerd viz dashboard"
wait
clear