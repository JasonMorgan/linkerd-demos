#!/bin/env bash

source ../demo-magic.sh
clear

pe "kubectl create ns booksapp"
wait
clear

pe "curl -sL https://run.linkerd.io/booksapp.yml | kubectl -n booksapp apply -f -"
wait
clear

pe "kubectl -n booksapp port-forward svc/webapp 7000"
wait
clear

pe "kubectl get deploy -n booksapp -o yaml | linkerd inject - | kubectl apply -f -"
wait
clear

pe "curl -sL https://run.linkerd.io/booksapp/webapp.swagger | linkerd -n booksapp profile --open-api - webapp"
wait
clear

pe "curl -sL https://run.linkerd.io/booksapp/webapp.swagger | linkerd -n booksapp profile --open-api - webapp | kubectl -n booksapp apply -f -"
wait
clear

pe "curl -sL https://run.linkerd.io/booksapp/authors.swagger | linkerd -n booksapp profile --open-api - authors | kubectl -n booksapp apply -f -"
wait
clear

pe "curl -sL https://run.linkerd.io/booksapp/books.swagger | linkerd -n booksapp profile --open-api - books | kubectl -n booksapp apply -f -"
wait
clear

# pe "linkerd viz tap -n booksapp deploy/webapp -o wide | grep req"
# wait
# clear

pe "linkerd viz -n booksapp routes svc/webapp"
# wait
# clear

pe "linkerd viz -n booksapp routes deploy/webapp --to svc/books"
# wait
# clear

pe "linkerd viz -n booksapp routes deploy/books --to svc/authors"
wait
clear

pe "kubectl -n booksapp edit sp/authors.booksapp.svc.cluster.local"
wait
clear

pe "linkerd viz -n booksapp routes deploy/books --to svc/authors -o wide"
wait
clear

pe "linkerd viz -n booksapp routes deploy/webapp --to svc/books"
wait
clear

pe "kubectl -n booksapp edit sp/books.booksapp.svc.cluster.local"
wait
clear

pe "linkerd viz -n booksapp routes deploy/webapp --to svc/books -o wide"
wait
clear

# pe ""
# wait
# clear