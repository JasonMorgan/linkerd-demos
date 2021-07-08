. ../demo-magic.sh
clear

k3d cluster delete rollouts &>/dev/null
k3d cluster create rollouts -p "8000:80@loadbalancer" -s 3 &>/dev/null

pe "linkerd install | k apply -f - && linkerd check"
pe "linkerd viz install | k apply -f - && linkerd viz check"

#curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -

pe "kubectl get deploy -n kube-system traefik -o yaml | linkerd inject --skip-inbound-ports --ingress - | kubectl apply -f -"


pe "kubectl create namespace argo-rollouts"
pe "kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml"

pe "kubectl apply -f manifests/podinfo.yaml"
