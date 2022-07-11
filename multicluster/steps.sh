#!/bin/bash

cd ~/tmp/ca

step certificate create root.linkerd.cluster.local root.crt root.key   --profile root-ca --no-password --insecure

step certificate create identity.linkerd.cluster.local issuer.lon.crt issuer.lon.key   --profile intermediate-ca --not-after 8760h --no-password --insecure   --ca root.crt --ca-key root.key

step certificate create identity.linkerd.cluster.local issuer.nyc.crt issuer.nyc.key   --profile intermediate-ca --not-after 8760h --no-password --insecure   --ca root.crt --ca-key root.key

civo kubernetes create NYC -n 1 -s g4s.kube.small -w -y

civo kubernetes config NYC > ~/.kube/configs/nyc

export KUBECONFIG=~/.kube/configs/nyc

civo kubernetes create LON -n 1 -s g4s.kube.small -w -y --region LON1

civo kubernetes config LON --region LON1 > ~/.kube/configs/lon

export KUBECONFIG=~/.kube/configs/lon

linkerd install --identity-trust-anchors-file ~/tmp/ca/root.crt --identity-issuer-certificate-file ~/tmp/ca/issuer.nyc.crt --identity-issuer-key-file ~/tmp/ca/issuer.nyc.key | k apply -f - && linkerd check

linkerd install --identity-trust-anchors-file ~/tmp/ca/root.crt --identity-issuer-certificate-file ~/tmp/ca/issuer.lon.crt --identity-issuer-key-file ~/tmp/ca/issuer.lon.key | k apply -f - && linkerd check

linkerd multicluster install | k apply -f - && linkerd check

linkerd viz install | k apply -f - && linkerd check

linkerd multicluster link --cluster-name lon | k apply -f -

k apply -f ~/git_repos/jasonmorgan/linkerd-demos/multicluster/manifests/frontend.yaml

k apply -k ~/git_repos/jasonmorgan/linkerd-demos/101/podinfo

k ns podinfo

k get pods

k get svc

k get ingress

k edit svc podinfo

# Cleanup

civo kubernetes delete NYC2 -y

civo kubernetes delete LON2 --region LON1 -y

rm -rf ~/tmp/ca/*