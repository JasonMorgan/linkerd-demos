#!/bin/env bash



# civo cluster create

civo kubernetes create linkerd-ingress -n 3 -s g3.k3s.small -w -y

civo kubernetes config linkerd-ingress > ~/.clusters/civo

kubectl ns default

# Install Linkerd and flagger


flux install

kubectl apply -f ~/git_repos/buoyant/gitops_examples/flux/runtime/manifests/

## new tab watch pods

linkerd check

# Create podinfo

kubectl apply -k ~/git_repos/buoyant/gitops_examples/flux/apps/source/podinfo/

kubectl ns podinfo

# launch dashboard - in another tab
watch linkerd viz dashboard

# Launch Traffic generator - in another tab

while true; do curl http://<ingress-ip>/; done

## Look at dashboard and edges

watch linkerd viz edges deploy

### No traefik data
### Explain what that means

# inject traefik

k get deploy -n kube-system traefik -o yaml | linkerd inject - | k apply -f -

# Checkout dashboard

# Talk through canary

micro ~/git_repos/buoyant/gitops_examples/flux/apps/source/podinfo/kustomization.yaml

kubectl apply -k ~/git_repos/buoyant/gitops_examples/flux/apps/source/podinfo/

k get canary

k get svc

k get deploy

# Talk through traffic split

k describe trafficsplit podinfo

# update color

micro ~/git_repos/buoyant/gitops_examples/flux/apps/source/podinfo/patch.yaml

kubectl apply -k ~/git_repos/buoyant/gitops_examples/flux/apps/source/podinfo/

watch linkerd viz stat ts

# Watch UI

# Talk through what happened, or didn't happen

# re inject traefik with ingress mode

k get deploy -n kube-system traefik -o yaml | linkerd inject --ingress - | k apply -f -

## Talk through annotation and linkerd docs
yat ~/git_repos/buoyant/gitops_examples/flux/apps/source/podinfo/ingress.yaml

## Show ingress docs

# Bump deployment color

micro ~/git_repos/buoyant/gitops_examples/flux/apps/source/podinfo/patch.yaml

# redeploy

k apply -k ~/git_repos/buoyant/gitops_examples/flux/apps/source/podinfo/

watch linkerd viz stat ts

# watch UI

# cleanup

civo kubernetes delete linkerd-ingress -y
# k ctx -d linkerd-ingress
rm $KUBECONFIG

# Update kustomization
micro ~/git_repos/buoyant/gitops_examples/flux/apps/source/podinfo/kustomization.yaml