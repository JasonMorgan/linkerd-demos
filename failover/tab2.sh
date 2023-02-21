#!/bin/bash

source ../demo-magic.sh
clear

pe "cd ~/tmp/ca"
wait
clear

pe "civo kubernetes config west > ~/.kube/configs/west"
wait
clear

pe "export KUBECONFIG=~/.kube/configs/west"
wait
clear

pe "linkerd install --crds | kubectl apply -f -"
wait
clear

pe "linkerd install --identity-trust-anchors-file ~/tmp/ca/root.crt --identity-issuer-certificate-file ~/tmp/ca/issuer.west.crt --identity-issuer-key-file ~/tmp/ca/issuer.west.key | kubectl apply --kubeconfig ~/.kube/configs/west -f - && linkerd check"
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

pe "kubectl label svc web-svc -n emojivoto mirror.linkerd.io/exported=true"
wait
clear



pe "kubectl -n emojivoto get ts web-svc"
wait
clear

pe ""
wait
clear

pe ""
wait
clear


