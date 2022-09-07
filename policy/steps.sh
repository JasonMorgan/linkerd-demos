#!/bin/bash
source ../demo-magic.sh
clear

## Cluster setup
k3d cluster delete pol > /dev/null 2>&1 || true
k3d cluster create pol > /dev/null 2>&1

## Linkerd
linkerd install --crds | kubectl apply -f -
linkerd install | kubectl apply -f -
linkerd check
helm install grafana -n grafana --create-namespace grafana/grafana \
  -f https://raw.githubusercontent.com/linkerd/linkerd2/main/grafana/values.yaml \
  --wait
linkerd viz install --set grafana.url=grafana.grafana:3000 | kubectl apply -f -
linkerd check

## Load up Booksapp
# curl -sL run.linkerd.io/emojivoto.yml | kubectl apply -f -
kubectl create ns booksapp && \
  curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/booksapp.yml \
  | kubectl -n booksapp apply -f -

# Start the actual demo here
## Inject booksapp
pe "kubectl get deploy -n booksapp -o yaml | linkerd inject - | kubectl apply -f -"
wait 
clear

## Look around
#Things mostly work
pe "linkerd viz stat deploy -n booksapp"
wait 
clear


# No effective policies
pe "linkerd viz authz -n booksapp deployment"
wait 
clear
## Harden our ns
### Default deny
### Configure a deny policy for booksapp
pe 'kubectl annotate ns booksapp config.linkerd.io/default-inbound-policy=deny'
wait
clear

pe 'kubectl get pods -n booksapp'
wait
clear

pe "linkerd viz authz -n booksapp deployment"
wait 
clear

pe "linkerd viz stat deploy -n booksapp"
wait 
clear

# Traffic is still there
## Apps still restart thanks to default exemptions for health checks
pe 'kubectl rollout restart -n booksapp deploy'
wait
clear

# Now traffic is gone
## Alternately watch the traffic
pe "linkerd viz authz -n booksapp deployment"
wait 
clear

pe "linkerd viz stat deploy -n booksapp"
wait 
clear

### Allow admin traffic
pe "kubectl apply -f manifests/booksapp/admin_server.yaml"
wait 
clear

pe "kubectl apply -f manifests/booksapp/allow_viz.yaml"
wait 
clear

pe "yat manifests/booksapp/admin_server.yaml"
wait 
clear

pe "yat manifests/booksapp/allow_viz.yaml"
wait 
clear

### Allow app traffic
pe "kubectl apply -f manifests/booksapp/authors_server.yaml"
wait 
clear

pe "kubectl apply -f manifests/booksapp/books_server.yaml"
wait 
clear

pe "kubectl apply -f manifests/booksapp/webapp_server.yaml"
wait 
clear

pe "kubectl apply -f manifests/booksapp/allow_namespace.yaml"
wait 
clear

pe "yat manifests/booksapp/authors_server.yaml"
wait 
clear

pe "yat manifests/booksapp/allow_namespace.yaml "
wait 
clear

### No Traffic app? no ports!

# HTTPRoutes, Locking down who can do what with our books
## switch from watching traffic to watching pods
pe "kubectl apply -f manifests/booksapp/authors_get_route.yaml"
wait 
clear
## wait a minute for authors to become unready

## App should become unready

pe 'kubectl apply -f manifests/booksapp/authors_get_policy.yaml'
wait
clear

## Lets fix our busted health checks, no more default routes

pe 'kubectl apply -f manifests/booksapp/authors_probe.yaml'
wait
clear
## wait a minute for authors to become ready
### Check readiness

## Check app

### Looks good
### Can't update books

pe 'kubectl apply -f manifests/booksapp/authors_modify_route.yaml'
wait
clear

pe 'kubectl apply -f manifests/booksapp/authors_modify_policy.yaml'
wait
clear
