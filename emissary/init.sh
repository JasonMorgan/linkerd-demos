#!/bin/bash

civo kubernetes delete infra -y
civo kubernetes create infra -v 1.21.2+k3s1 -n 3 -w -y -r Traefik -s g3.k3s.small
civo kubernetes config infra > ~/.kube/configs/infra
export KUBECONFIG=~/.kube/configs/infra
linkerd install | k apply -f - && linkerd check
linkerd viz install | k apply -f - && linkerd check
kubectl create namespace ambassador && helm install ambassador --namespace ambassador datawire/ambassador --set replicaCount=1 && kubectl -n ambassador wait --for condition=available --timeout=90s deploy -lproduct=aes
k get deployments.apps -n ambassador ambassador -o yaml | linkerd inject --skip-inbound-ports "80,443" - | k apply -f -
kubectl apply -f https://buoyant.cloud/agent/buoyant-cloud-k8s-infra-suFLPSa7Aeeex89Z-doqipOxEDtXxkcFNMdAhkLfxhQevCCNKAGWzQ0JTZzU=.yml
curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | k apply -f -
k create ns booksapp
curl -sL https://run.linkerd.io/booksapp.yml | linkerd inject - | k apply -n booksapp -f -
kubectl apply -f ~/git_repos/jasonmorgan/linkerd-demos/101/service_profiles/source/booksapp.yaml
k create ns argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
k apply -f manifests/podinfo/rollout.yaml
k apply -f manifests/podinfo/mapping.yaml