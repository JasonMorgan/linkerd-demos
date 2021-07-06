. ../demo-magic.sh
clear

k3d cluster delete rollouts &>/dev/null
k3d cluster create rollouts -p "8000:80@loadbalancer" -s 3 &>/dev/null

linkerd install | k apply -f - && linkerd check
linkerd viz install | k apply -f - && linkerd viz check
curl -sL https://run.linkerd.io/emojivoto.yml | linkerd inject - | kubectl apply -f -

k get deploy -n kube-system traefik -o yaml | linkerd inject --skip-inbound-ports --ingress - | k apply -f -


kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/smi/rollout.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/smi/services.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/smi/ingress.yaml
