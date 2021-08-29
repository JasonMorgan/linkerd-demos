#!/usr/bin/env bash
. ../demo-magic.sh
clear

k3d cluster delete gitops &>/dev/null
k3d cluster create gitops -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-server-arg '--no-deploy=traefik' > /dev/null 2>&1

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

pe "bat -l yaml ~/git_repos/buoyant/gitops_examples/flux/runtime/manifests/runtime_git.yaml"
wait
clear

pe "kubectl apply -f ~/git_repos/buoyant/gitops_examples/flux/runtime/manifests/runtime_git.yaml"
wait
clear

pe "kubectl apply -f ~/git_repos/buoyant/gitops_examples/flux/runtime/manifests/dev_cluster.yaml"
wait
clear

pe "bat -l yaml ~/git_repos/buoyant/gitops_examples/flux/runtime/manifests/dev_cluster.yaml"
wait
clear

### THis looks good as it shows the live install

pe "linkerd check"
wait
clear

pe "linkerd viz check"
wait
clear

pe "kubectl apply -f ~/git_repos/buoyant/gitops_examples/flux/apps/manifests/podinfo.yaml"
wait
clear

pe "bat -l yaml ~/git_repos/buoyant/gitops_examples/flux/apps/manifests/podinfo.yaml"
wait
clear

