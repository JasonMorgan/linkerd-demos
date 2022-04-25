#!/bin/env bash
source ../../demo-magic.sh
clear

k3d cluster delete linkerd > /dev/null 2>&1 || true
k3d cluster create linkerd --k3s-arg '--no-deploy=traefik@server:*;agents:*'
curl -sL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -
k create ns booksapp
curl -sL https://run.linkerd.io/booksapp.yml | kubectl apply -n booksapp -f -
cd ~/tmp/ca
wait 
clear

pe "helm install linkerd linkerd/linkerd2 --set-file identityTrustAnchorsPEM=root.crt --set-file identity.issuer.tls.crtPEM=issuer.nyc.crt --set-file identity.issuer.tls.keyPEM=issuer.nyc.key --version 2.11.1"
wait
clear

pe "linkerd check"
wait
clear

pe "helm install linkerd-dashboard linkerd/linkerd-viz --version 2.11.1"
wait
clear

pe "linkerd check"
wait
clear

pe "linkerd viz dashboard"
wait
clear

pe "k get deploy -n emojivoto -o yaml | linkerd inject - | k apply -f -"
wait
clear

pe "helm upgrade linkerd linkerd/linkerd2 --version 2.11.2 -n default"
wait
clear

pe "helm upgrade linkerd-dashboard linkerd/linkerd-viz --version 2.11.2 -n default"
wait
clear

pe "kubectl rollout restart deployment -n emojivoto"
wait
clear

pe "linkerd viz dashboard"
wait
clear
