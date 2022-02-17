#!/bin/bash

source ../demo-magic.sh
clear

pe "cd ~/tmp/ca"
wait
clear

pe "export KUBECONFIG=~/.kube/configs/lon2"
wait
clear

pe "linkerd install --identity-trust-anchors-file ~/tmp/ca/root.crt --identity-issuer-certificate-file ~/tmp/ca/issuer.lon.crt --identity-issuer-key-file ~/tmp/ca/issuer.lon.key | k apply --kubeconfig ~/.kube/configs/lon2 -f - && linkerd check"
wait
clear

pe "linkerd multicluster install | k apply -f - && linkerd check"
wait
clear

pe "linkerd viz install | k apply -f - && linkerd check"
wait
clear

pe "k apply -k git_repos/jasonmorgan/linkerd-demos/101/podinfo"
wait
clear

pe "k ns podinfo"
wait
clear

pe "k get pods"
wait
clear

pe "k get svc"
wait
clear

pe "k get ingress"
wait
clear

pe "k label svc podinfo mirror.linkerd.io/exported=true"
wait
clear
