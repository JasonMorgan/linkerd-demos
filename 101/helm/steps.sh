#!/bin/env bash

source ../demo-magic.sh

export ORG_DOMAIN="${ORG_DOMAIN:-k3d.example.com}"
CA_DIR=$(mktemp --tmpdir="${TMPDIR:-/tmp}" -d k3d-ca.XXXXX)

# Generate the trust roots. These never touch the cluster. In the real world
# we'd squirrel these away in a vault.
step certificate create \
    "identity.linkerd.${ORG_DOMAIN}" \
    "$CA_DIR/ca.crt" "$CA_DIR/ca.key" \
    --profile root-ca \
    --no-password  --insecure --force > /dev/null 2>&1 

crt="${CA_DIR}/cluster-issuer.crt"
key="${CA_DIR}/cluster-issuer.key"
domain="cluster.${ORG_DOMAIN}"
step certificate create "identity.linkerd.${domain}" \
    "$crt" "$key" \
    --ca="$CA_DIR/ca.crt" \
    --ca-key="$CA_DIR/ca.key" \
    --profile=intermediate-ca \
    --not-after 8760h --no-password --insecure > /dev/null 2>&1

k3d cluster delete helm > /dev/null 2>&1 || true
k3d cluster create helm -p "8081:80@loadbalancer" > /dev/null 2>&1
helm repo update > /dev/null 2>&1
clear

pe "helm repo add linkerd https://helm.linkerd.io/stable"
wait
clear

pe "helm repo update"
wait
clear

exp=$(date -d '+8760 hour' +"%Y-%m-%dT%H:%M:%SZ")

pe "helm install linkerd2 \
  --set-file identityTrustAnchorsPEM=\$CA_DIR/ca.crt \
  --set-file identity.issuer.tls.crtPEM=\$CA_DIR/cluster-issuer.crt \
  --set-file identity.issuer.tls.keyPEM=\$CA_DIR/cluster-issuer.key \
  --set identity.issuer.crtExpiry=$(date -d '+8760 hour' +"%Y-%m-%dT%H:%M:%SZ") \
  linkerd/linkerd2"
wait
clear

pe "linkerd check"
wait
clear

pe "helm install viz linkerd/linkerd-viz"
wait
clear

pe "linkerd viz check"
wait
clear

pe "kubectl apply -k https://github.com/JasonMorgan/linkerd-demos/101/podinfo?ref=main"
wait
clear

pe "curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -"
wait
clear
