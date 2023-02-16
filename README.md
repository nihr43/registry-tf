This is a sample of how to run a bomb-proof registry in kuberenetes, backed by a ceph object store.

Other S3 compatibles should work as well.

Certificates and configmap are expected to exist before running the terraform module:

```
kubectl create secret tls registry-cert --cert images.local.crt --key images.local.key
kubectl apply -f configmap.yaml
```
