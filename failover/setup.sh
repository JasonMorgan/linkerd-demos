#!/bin/bash

civo kubernetes create east -n 1 -s g4s.kube.large -w -y --region PHX1
civo kubernetes create west -n 1 -s g4s.kube.large -w -y --region PHX1

civo kubernetes config east > ~/.kube/configs/east
civo kubernetes config west > ~/.kube/configs/west

kubectl apply -f https://run.linkerd.io/emojivoto.yml --kubeconfig ~/.kube/configs/east
kubectl apply -f https://run.linkerd.io/emojivoto.yml --kubeconfig ~/.kube/configs/west
