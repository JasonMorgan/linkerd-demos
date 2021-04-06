#!/bin/env bash
# shellcheck source=demo-magic.sh

civo kubernetes delete smc
civo kubernetes create smc -n 3 -s g3.k3s.small --region NYC1 -w
civo kubernetes config smc -sy
linkerd install | k apply -f -
linkerd check
linkerd viz install | k apply -f -
linkerd viz check
curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -
k create ns booksapp
curl -sL https://run.linkerd.io/booksapp.yml | linkerd inject - | k apply -n booksapp -f -
k apply -k git_repos/jasonmorgan/linkerd-demos/101/podinfo
