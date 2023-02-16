This is a sample of how to run an HA registry in kuberenetes, backed by a ceph object store.

```
kubectl create secret tls registry-cert --cert images.local.crt --key images.local.key
kubectl apply -f registry-configmap.yaml
```
