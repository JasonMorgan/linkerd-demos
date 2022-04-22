#!/usr/bin/env bash
. ../../demo-magic.sh
clear

k3d cluster delete gitops &>/dev/null
k3d cluster create gitops -s 3 -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-arg '--no-deploy=traefik@server:*;agents:*' > /dev/null 2>&1
kubectl ns default

clear

pe "flux check --pre"
wait
clear

pe "flux install"
wait
clear

# pe "kubectl get crd | grep flux"
# wait
# clear

pe "linkerd check --pre"
wait
clear

pe "bat -l yaml runtime/manifests/repo.yaml"
wait
clear

pe "kubectl apply -f runtime/manifests/repo.yaml"
wait
clear

pe "kubectl apply -f runtime/manifests/cluster.yaml"
wait
clear

pe "bat -l yaml runtime/manifests/cluster.yaml"
wait
clear



### This looks good as it shows the live install


pe "kubectl apply -f apps/manifests/apps.yaml"
wait
clear

pe "bat -l yaml apps/manifests/apps.yaml"
wait
clear

pe "linkerd check"
wait
clear

