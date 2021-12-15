k3d cluster create pol
linkerd install | k apply -f - && linkerd check
linkerd viz install | k apply -f - && linkerd viz check
curl -sL run.linkerd.io/emojivoto.yml | kubectl apply -f -
k get deploy -n emojivoto -o yaml | linkerd inject - | k apply -f -
k annotate ns emojivoto config.linkerd.io/default-inbound-policy=deny
k rollout restart deployment
k apply -f policy/manifests/emojivoto-allow-health.yaml 
# config.linkerd.io/default-inbound-policy=deny