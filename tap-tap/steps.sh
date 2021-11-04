#!/bin/env bash
# shellcheck source=demo-magic.sh
. ../demo-magic.sh

k3d cluster delete tap &>/dev/null
k3d cluster create tap -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-server-arg '--no-deploy=traefik' > /dev/null 2>&1
kubectl ns default
curl -sL https://run.linkerd.io/install | sh
linkerd install | kubectl apply -f - && linkerd check
linkerd viz install | kubectl apply -f - && linkerd viz check
curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -
kubectl create ns booksapp
curl -sL https://run.linkerd.io/booksapp.yml | linkerd inject - | kubectl apply -n booksapp -f -
kubectl apply -f ~/git_repos/jasonmorgan/linkerd-demos/101/service_profiles/source/booksapp.yaml 

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