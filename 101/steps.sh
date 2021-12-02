#!/bin/env bash
# shellcheck source=demo-magic.sh
source demo-magic.sh
k3d cluster delete 101 > /dev/null 2>&1 || true
k3d cluster create 101 > /dev/null 2>&1
curl -sL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -
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

pe "linkerd install"
wait
clear

pe "linkerd install | kubectl apply -f -"
wait
clear

# pe "watch kubectl get pods -n linkerd"
# wait
# clear

pe "linkerd check"
wait
clear

pe "kubectl get pods -n linkerd"
wait
clear

pe "linkerd viz install | kubectl apply -f -"
wait
clear

pe "linkerd viz check"
wait
clear

pe "kubectl get pods -n linkerd-viz"
wait
clear

pe "linkerd viz dashboard"
wait
clear

# pe "curl -sL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -"
# wait
# clear

# pe "kubectl -n emojivoto port-forward svc/web-svc 8080:80 &"
# wait
# clear

pe "kubectl get -n emojivoto deploy -o yaml | linkerd inject - | kubectl apply -f -"
wait
clear

pe "linkerd -n emojivoto check --proxy"
wait
clear

pe "watch linkerd viz -n emojivoto stat deploy"
wait
clear

pe "linkerd viz edges -n emojivoto deploy"
wait
clear

pe "linkerd viz -n emojivoto tap deploy/web"
wait
clear

# linkerd -n emojivoto stat deploy -o json

# linkerd tap deploy/web -n emojivoto --to deploy/voting -o json
