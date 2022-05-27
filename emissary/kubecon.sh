#!/bin/env bash
source ../demo-magic.sh
# k3d cluster delete emissary > /dev/null 2>&1 || true
k3d cluster create emissary -p "80:80@loadbalancer" -p "443:443@loadbalancer"  --k3s-arg '--no-deploy=traefik@server:*;agents:*' > /dev/null 2>&1 || true
kubectl ns default
curl -sL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -

clear


## Install emissary
pe "helm repo add datawire https://www.getambassador.io"
wait
clear

pe "kubectl apply -f https://app.getambassador.io/yaml/emissary/2.2.2/emissary-crds.yaml"
wait
clear

pe "kubectl wait --timeout=90s --for=condition=available deployment emissary-apiext -n emissary-system"
wait
clear

pe "helm install -n emissary --create-namespace emissary-ingress datawire/emissary-ingress --set replicaCount=1 --wait"
# helm install -n emissary --create-namespace emissary-ingress ./emissary/emissary-ingress-7.3.2.tgz --set replicaCount=1 --wait
wait
clear

pe "kubectl create secret tls wildcard --cert ~/.certs/config/live/k8s.59s.io/cert.pem --key ~/.certs/config/live/k8s.59s.io/privkey.pem"
wait
clear

pe "bat -l yaml manifests/podinfo/all-in-one.yaml"
wait
clear

pe "kubectl apply -f manifests/podinfo/all-in-one.yaml"
wait
clear

# pe "kubectl get ambassador-crds"
# wait
# clear

## Install Linkerd
pe "curl -sL https://run.linkerd.io/install | sh"
wait
clear

pe "export PATH=\$PATH:\$HOME/.linkerd2/bin"
clear

pe "linkerd version"
wait
clear

pe "linkerd check --pre"
wait
clear

pe "linkerd install | kubectl apply -f - && linkerd check"
wait
clear

pe "linkerd viz install | kubectl apply -f - && linkerd viz check"
wait
clear

## Instegrate apps
pe "kubectl get deploy -n emissary emissary-ingress -o yaml | linkerd inject - | kubectl apply -f -"
wait
clear

pe "kubectl get deploy -n emojivoto -o yaml | linkerd inject - | kubectl apply -f -"
wait
clear

pe "linkerd check -n emojivoto --proxy"
wait
clear

pe "linkerd viz tap deployment/emissary-ingress --namespace emissary --to deployment/web --to-namespace emojivoto --path / -o json"
wait
clear

p "fin"
wait
clear

