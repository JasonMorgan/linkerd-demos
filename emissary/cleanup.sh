#!/bin/bash

# Cleanup
kubectl get deploy -n emojivoto -o yaml | linkerd uninject - | kubectl apply -f -
kubectl get deploy -n emissary -o yaml | linkerd uninject - | kubectl apply -f - 
sleep 15
kubectl delete -f https://app.getambassador.io/yaml/emissary/2.2.2/emissary-crds.yaml
kubectl delete secret wildcard
linkerd viz uninstall | kubectl delete -f -
linkerd uninstall | kubectl delete -f -
helm delete  -n emissary emissary-ingress