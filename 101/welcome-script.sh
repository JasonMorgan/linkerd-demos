#!/bin/env bash
# shellcheck source=demo-magic.sh
source demo-magic.sh
clear
rm /home/jason/.linkerd2/bin/linkerd-stable-2.10.0 > /dev/null 2>&1

# curl -sL https://run.linkerd.io/emojivoto.yml | kubectl apply -f - > /dev/null 2>&1

pe "kubectl get pods -n emojivoto"
wait
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

pe "linkerd install | kubectl apply -f -"
wait
clear

pe "linkerd check"
wait
clear

pe "linkerd viz install | kubectl apply -f -"
wait
clear

pe "linkerd viz check"
wait
clear


pe "kubectl get -n emojivoto deploy -o yaml | linkerd inject - | kubectl apply -f -"
wait
clear

pe "linkerd -n emojivoto check --proxy"
wait
clear

pe "linkerd viz dashboard"
wait
clear

#  linkerd -n emojivoto stat deploy -o json

# linkerd tap deploy/web -n emojivoto --to deploy/voting -o json