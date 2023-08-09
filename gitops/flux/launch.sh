#!/usr/bin/env bash

k3d cluster create gitops -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-arg '--disable=traefik@server:0'
flux install

kubectl apply -f runtime/manifests/repo.yaml
kubectl apply -f runtime/manifests/cluster.yaml
kubectl ns default
