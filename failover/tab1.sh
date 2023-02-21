#!/bin/bash

source ../demo-magic.sh
clear

rm ~/tmp/ca/*

pe "step certificate create root.linkerd.cluster.local ~/tmp/ca/root.crt ~/tmp/ca/root.key --profile root-ca --no-password --insecure"
wait
clear

pe "step certificate create identity.linkerd.cluster.local ~/tmp/ca/issuer.west.crt ~/tmp/ca/issuer.west.key   --profile intermediate-ca --not-after 8760h --no-password --insecure   --ca root.crt --ca-key root.key"
wait
clear

pe "step certificate create identity.linkerd.cluster.local issuer.east.crt issuer.east.key   --profile intermediate-ca --not-after 8760h --no-password --insecure   --ca root.crt --ca-key root.key"
wait
clear

pe "export KUBECONFIG=~/.kube/configs/east"
wait
clear

pe "linkerd install --crds | kubectl apply -f -"
wait
clear

pe "linkerd install --identity-trust-anchors-file ~/tmp/ca/root.crt --identity-issuer-certificate-file ~/tmp/ca/issuer.east.crt --identity-issuer-key-file ~/tmp/ca/issuer.east.key | kubectl apply --kubeconfig ~/.kube/configs/east -f - && linkerd check"
wait
clear

pe "linkerd smi install | kubectl apply -f - && linkerd check"
wait
clear

pe "linkerd multicluster install | kubectl apply -f - && linkerd check"
wait
clear

pe "linkerd viz install | kubectl apply -f - && linkerd check"
wait
clear

pe "linkerd multicluster link --kubeconfig ~/.kube/configs/west --cluster-name west | kubectl apply --kubeconfig ~/.kube/configs/east -f -"
wait
clear

pe "kubectl apply -f manifests/"
wait
clear

pe "bat -lyaml web-ts.yaml"
wait
clear

pe "kubectl scale deploy web --replicas 0 -n emojivoto"
wait
clear

pe "linkerd viz stat deploy -n emojivoto"
wait
clear

pe "kubectl scale deploy web --replicas 1 -n emojivoto"
wait
clear

# Cleanup

civo kubernetes delete east -y

civo kubernetes delete west -y

rm -rf ~/tmp/ca/*












