#!/usr/bin/env bash

k3d cluster create gitops -s 3 -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-arg '--no-deploy=traefik@server:*;agents:*'
flux install

kubectl apply -f runtime/manifests/repo.yaml
kubectl apply -f runtime/manifests/cluster.yaml
kubectl ns default
