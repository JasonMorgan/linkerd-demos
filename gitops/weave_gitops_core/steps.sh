# k3d cluster create gitops -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"  --k3s-arg '--no-deploy=traefik@server:*;agents:*'
civo kubernetes create gitops -r Traefik -n 3 -s g3.k3s.small -w -y
civo kubernetes config gitops > ~/.kube/config
# k ctx gitops
k ns default

gitops install

gitops add app --url https://github.com/JasonMorgan/linkerd-demos.git --path ./gitops/flux/runtime/manifests/ --name platform

gh pr list

gh pr merge $NUM

k get host -A 

gitops add app --url https://github.com/JasonMorgan/linkerd-demos.git --path ./gitops/flux/apps/source/podinfo --name podinfo --app-config-url NONE

micro git_repos/jasonmorgan/linkerd-demos/gitops/flux/apps/source/podinfo/patch.yaml

cd git_repos/jasonmorgan/linkerd-demos/

git add .

git commit -m ''

git push

watch k get deploy

## TAB2

watch kubectl get pods -A

watch kubectl get pods -n podinfo 

## TAB3

watch kubectl get kustomization

watch linkerd viz stat ts