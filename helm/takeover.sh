#!/usr/bin/env bash

# linkerd install --identity-trust-anchors-file ~/tmp/ca/root.crt --identity-issuer-certificate-file ~/tmp/ca/issuer.crt --identity-issuer-key-file ~/tmp/ca/issuer.key | k apply -f - && linkerd check

#helm template --set-file identityTrustAnchorsPEM=../ca/root.crt   --set-file identity.issuer.tls.crtPEM=../ca/issuer.crt   --set-file identity.issuer.tls.keyPEM=../ca/issuer.key linkerd linkerd/linkerd2 | k apply -f -

kubectl annotate ns linkerd meta.helm.sh/release-name=linkerd --overwrite
kubectl annotate ns linkerd meta.helm.sh/managed-by=Helm --overwrite
kubectl annotate ns linkerd meta.helm.sh/release-namespace=default --overwrite
kubectl label ns linkerd app.kubernetes.io/managed-by=Helm --overwrite

# k get sa -n linkerd -o json | jq -r '[.items[] | select(.metadata.name | startswith("linkerd")) | {"Kind": .kind, "Name": .metadata.name}]'
for type in deploy sa service secret cm clusterrole clusterrolebinding role rolebinding cronjob MutatingWebhookConfiguration ValidatingWebhookConfiguration # servers.policy.linkerd.io serverauthorizations
do
  for i in $(kubectl get "${type}" -n linkerd -o json | jq  -c '.items[] | select(.metadata.name | startswith("linkerd")) | {"kind": .kind, "name": .metadata.name}')
  do 
    kind=$(echo $i | jq -r '.kind')
    name=$(echo $i | jq -r '.name')
    kubectl annotate -n linkerd "${kind}" "${name}" meta.helm.sh/release-name=linkerd --overwrite
    kubectl annotate -n linkerd "${kind}" "${name}" meta.helm.sh/managed-by=Helm --overwrite
    kubectl annotate -n linkerd "${kind}" "${name}" meta.helm.sh/release-namespace=default --overwrite
    kubectl label -n linkerd "${kind}" "${name}" app.kubernetes.io/managed-by=Helm --overwrite
  done
done

for crd in servers.policy.linkerd.io serverauthorizations.policy.linkerd.io serviceprofiles.linkerd.io trafficsplits.split.smi-spec.io
do
  kubectl annotate -n linkerd crd "${crd}" meta.helm.sh/release-name=linkerd --overwrite
  kubectl annotate -n linkerd crd "${crd}" meta.helm.sh/managed-by=Helm --overwrite
  kubectl annotate -n linkerd crd "${crd}" meta.helm.sh/release-namespace=default --overwrite
  kubectl label -n linkerd crd "${crd}" app.kubernetes.io/managed-by=Helm --overwrite
done
# helm install --set-file identityTrustAnchorsPEM=~/tmp/ca/root.crt   --set-file identity.issuer.tls.crtPEM=~/tmp/ca/issuer.crt   --set-file identity.issuer.tls.keyPEM=~/tmp/ca/issuer.key linkerd linkerd/linkerd2
