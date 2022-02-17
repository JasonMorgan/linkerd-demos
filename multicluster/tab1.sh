#!/bin/bash

source ../demo-magic.sh
clear

pe "cd ~/tmp/ca"
wait
clear

pe "step certificate create root.linkerd.cluster.local root.crt root.key   --profile root-ca --no-password --insecure"
wait
clear

pe "step certificate create identity.linkerd.cluster.local issuer.lon.crt issuer.lon.key   --profile intermediate-ca --not-after 8760h --no-password --insecure   --ca root.crt --ca-key root.key"
wait
clear

pe "step certificate create identity.linkerd.cluster.local issuer.nyc.crt issuer.nyc.key   --profile intermediate-ca --not-after 8760h --no-password --insecure   --ca root.crt --ca-key root.key"
wait
clear

pe "civo kubernetes create NYC2 -n 1 -s g3.k3s.small -w -y"
wait
clear

pe "civo kubernetes config NYC2 > ~/.kube/configs/nyc2"
wait
clear

pe "export KUBECONFIG=~/.kube/configs/nyc2"
wait
clear


pe "civo kubernetes create LON2 -n 1 -s g3.k3s.small -w -y --region LON1"
wait
clear


pe "civo kubernetes config LON2 --region LON1 > ~/.kube/configs/lon2"
wait
clear


pe "linkerd install --identity-trust-anchors-file ~/tmp/ca/root.crt --identity-issuer-certificate-file ~/tmp/ca/issuer.nyc.crt --identity-issuer-key-file ~/tmp/ca/issuer.nyc.key | k apply --kubeconfig ~/.kube/configs/nyc2 -f - && linkerd check"
wait
clear




pe "linkerd multicluster install | k apply -f - && linkerd check"
wait
clear

pe "linkerd viz install | k apply -f - && linkerd check"
wait
clear

pe "linkerd multicluster link --kubeconfig ~/.kube/configs/lon2 --cluster-name lon | k apply --kubeconfig ~/.kube/configs/nyc2 -f -"
wait
clear

pe "k apply -f git_repos/jasonmorgan/linkerd-demos/multicluster/manifests/frontend.yaml"
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

# pe "k edit svc podinfo"
# wait
# clear

# Cleanup

civo kubernetes delete NYC2 -y

civo kubernetes delete LON2 --region LON1 -y

rm -rf ~/tmp/ca/*












