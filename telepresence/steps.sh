#!/bin/env bash
source ../demo-magic.sh


# k3d cluster delete telepresence > /dev/null 2>&1 || true
# k3d cluster create telepresence -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-server-arg '--no-deploy=traefik' > /dev/null 2>&1
civo k8s delete tele -y
civo kubernetes create tele -n 3 -s g3.k3s.small -w -y

civo kubernetes config tele -sym

kubectl ctx tele

# kubectl ns default

clear

pe "helm repo add datawire https://www.getambassador.io"
wait
clear

pe "kubectl create namespace ambassador && helm install ambassador --namespace ambassador datawire/ambassador --set replicaCount=1 && kubectl -n ambassador wait --for condition=available --timeout=90s deploy -lproduct=aes"
wait
clear

pe "helm install traffic-manager --namespace ambassador datawire/telepresence"
wait
clear

pe "kubectl ns ambassador"
wait
clear

pe "kubectl get pods"
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

pe "curl -sL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -"
wait
clear

# pe "telepresence connect"
# wait
# clear

## Browse some shit

pe "kubectl get deploy -n ambassador ambassador -o yaml | linkerd inject --skip-inbound-ports \"80,443\" - | kubectl apply -f -"
wait
clear

pe "kubectl get deploy -n ambassador traffic-manager -o yaml | linkerd inject - | kubectl apply -f -"
wait
clear

pe "kubectl get deploy -n emojivoto -o yaml | linkerd inject - | kubectl apply -f -"
wait
clear

pe "linkerd viz dashboard"
wait
clear

p 'fin'
wait