#!/bin/env bash
source ../demo-magic.sh
k3d cluster delete emissary > /dev/null 2>&1 || true
k3d cluster create emissary -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-arg '--no-deploy=traefik@server:*;agents:*' > /dev/null 2>&1
k ns default

clear

pe "helm repo add datawire https://www.getambassador.io"
wait
clear

pe "kubectl apply -f https://app.getambassador.io/yaml/edge-stack/2.2.0/aes-crds.yaml"
wait
clear

pe "kubectl wait --timeout=90s --for=condition=available deployment emissary-apiext -n emissary-system"
wait
clear

pe "kubectl create namespace ambassador"
wait
clear

pe "helm install -n ambassador edge-stack datawire/edge-stack"
wait
clear

pe "kubectl rollout status  -n ambassador deployment/edge-stack -w"
wait
clear

pe "bat -l yaml manifests/listener.yaml"
wait
clear

pe "kubectl apply -f manifests/listener.yaml"
wait
clear

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

pe "kubectl get deploy -n ambassador edge-stack -o yaml | linkerd inject --skip-inbound-ports \"80,443\" - | kubectl apply -f -"
wait
clear

pe "bat -l yaml ../101/podinfo/mapping.yaml"
wait
clear

# pe "curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -"
# wait
# clear

pe "kubectl apply -k ../101/podinfo/"
wait
clear

p 'fin'
wait
