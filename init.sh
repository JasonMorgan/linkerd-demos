#!/usr/bin/env bash

k3d cluster create dev -s 3 --k3s-arg '--no-deploy=traefik@server:*;agents:*'

curl -sL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -
kubectl create ns booksapp
curl -sL https://run.linkerd.io/booksapp.yml | kubectl apply -n booksapp -f -
k apply -k 101/podinfo
k ns default
clear