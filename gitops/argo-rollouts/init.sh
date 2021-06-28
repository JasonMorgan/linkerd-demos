. ../demo-magic.sh
clear

k3d cluster delete rollouts &>/dev/null
k3d cluster create rollouts -p "8000:80@loadbalancer" -s 3 &>/dev/null

linkerd install | k apply -f - && linkerd check
linkerd viz install | k apply -f - && linkerd viz check
curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -
k create ns booksapp
curl -sL https://run.linkerd.io/booksapp.yml | linkerd inject - | k apply -n booksapp -f -
kustomize build ~/git_repos/jasonmorgan/linkerd-demos/101/podinfo | linkerd inject - | k apply -f -
k apply -f ~/git_repos/jasonmorgan/linkerd-demos/101/service_profiles/source/booksapp.yaml 

kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
