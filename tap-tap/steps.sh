#!/bin/env bash
# shellcheck source=demo-magic.sh
. ../demo-magic.sh
clear
# civo kubernetes delete smc
# civo kubernetes create smc -n 3 -s g3.k3s.small --region NYC1 -w
# civo kubernetes config smc -sy
# linkerd install | k apply -f - && linkerd check
# linkerd viz install | k apply -f - && linkerd viz check
# curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -
# k create ns booksapp
# curl -sL https://run.linkerd.io/booksapp.yml | linkerd inject - | k apply -n booksapp -f -
# kustomize build ~/git_repos/jasonmorgan/linkerd-demos/101/podinfo | linkerd inject - | k apply -f -
# k apply -f ~/git_repos/jasonmorgan/linkerd-demos/101/service_profiles/source/booksapp.yaml 
# linkerd viz dashboard
kubectl delete sp -n emojivoto --all
kubectl apply -f ~/git_repos/jasonmorgan/linkerd-demos/101/service_profiles/source/booksapp.yaml 
clear

pe "kubectl get nodes"
wait
clear

pe "linkerd check"
wait
clear

pe "linkerd viz stat namespace"
wait
clear

pe "linkerd viz stat deployment -n emojivoto"
wait
clear

pe "linkerd viz top -n emojivoto deploy/web"
wait
clear

pe "linkerd viz top -n emojivoto deploy/voting"
wait
clear

pe "linkerd viz tap deployment/web -n emojivoto --to deployment/voting --path / | less"
wait
clear

pe "linkerd viz tap deployment/web -n emojivoto --to deployment/voting --path /emojivoto.v1.VotingService/VoteDoughnut | less"
wait
clear

pe "linkerd viz tap deployment/web -n emojivoto --to deployment/voting --path /emojivoto.v1.VotingService/VoteDoughnut -o json | less"
wait
clear

pe "linkerd profile --proto ~/git_repos/buoyant/emojivoto/proto/Emoji.proto emoji-svc -n emojivoto"
wait
clear

pe "linkerd profile --proto ~/git_repos/buoyant/emojivoto/proto/Emoji.proto emoji-svc -n emojivoto | kubectl apply -f -"
wait
clear

pe "linkerd profile --proto ~/git_repos/buoyant/emojivoto/proto/Voting.proto voting-svc -n emojivoto | kubectl apply -f -"
wait
clear

pe "linkerd viz profile -n emojivoto web-svc --tap deploy/web --tap-duration 10s | kubectl apply -f -"
wait
clear

p "Let's go checkout to the dashboard!"
wait
clear

# pe "linkerd viz tap -n booksapp deploy/webapp -o wide | grep req"
# wait
# clear

pe "linkerd viz -n booksapp routes svc/webapp"
# wait
# clear
pe "linkerd viz -n booksapp routes deploy/webapp --to svc/authors"

pe "linkerd viz -n booksapp routes deploy/webapp --to svc/books"
# wait
# clear

pe "linkerd viz -n booksapp routes deploy/books --to svc/authors"
wait
clear

pe "kubectl -n booksapp edit sp/authors.booksapp.svc.cluster.local"
wait
clear

pe "watch linkerd viz -n booksapp routes deploy/books --to svc/authors -o wide"
wait
clear

pe "watch linkerd viz -n booksapp routes deploy/webapp --to svc/books"
wait
clear