#!/bin/env bash
source ../demo-magic.sh
k3d cluster delete emissary > /dev/null 2>&1 || true
k3d cluster create emissary -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-server-arg '--no-deploy=traefik' > /dev/null 2>&1

clear

pe "helm repo add datawire https://www.getambassador.io"
wait
clear

pe "kubectl create namespace ambassador && helm install ambassador --namespace ambassador datawire/ambassador --set replicaCount=1 && kubectl -n ambassador wait --for condition=available --timeout=90s deploy -lproduct=aes"
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

pe "kubectl get deploy -n ambassador ambassador -o yaml | linkerd inject --skip-inbound-ports \"80,443\" - | kubectl apply -f -"
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
