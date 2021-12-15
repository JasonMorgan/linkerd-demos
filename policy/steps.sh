#!/bin/bash

## Cluster setup
k3d cluster delete pol > /dev/null 2>&1 || true
k3d cluster create pol > /dev/null 2>&1

## Linkerd
linkerd install | k apply -f - && linkerd check
linkerd viz install | k apply -f - && linkerd viz check

## Load up emojivoto
curl -sL run.linkerd.io/emojivoto.yml | kubectl apply -f -

## Start the actual demo here

### Inject emojivoto, show that things still work
pe 'k get deploy -n emojivoto -o yaml | linkerd inject - | k apply -f -'
wait 
clear

### Configure a deny policy for emojivoto
pe 'k annotate ns emojivoto config.linkerd.io/default-inbound-policy=deny'
wait
clear

pe 'k get pods -n emojivoto'
wait
clear

#### Explain why nothing changed

pe 'k rollout restart deployment -n emojivoto'
wait
clear

pe 'watch k get pods -n emojivoto'
wait
clear

#### Explain why pods aren't starting and why the app works

pe 'k apply -f policy/manifests/emojivoto-allow-health.yaml'
wait
clear

pe 'watch k get pods -n emojivoto'
wait
clear

#### Explain why pods are starting and show broken app

pe 'k apply -f policy/manifests/emojivoto-allow-prom.yaml'
wait
clear

#### Show Linkerd dashboard and explain what happened with the prom metrics

pe 'k apply -f policy/manifests/emojivoto-policy.yaml'
wait
clear

#### Show how the app now works and explain why

# config.linkerd.io/default-inbound-policy=deny