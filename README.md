This is a sample of how to run a bomb-proof registry in kubernetes, backed by a ceph object store.

Other S3 compatibles should work as well.

Read more on motivation and design [here](https://signal.nih.earth/posts/image_registry/).

Certificates and configmap are expected to exist before running the terraform module:

```
kubectl create secret tls registry-cert --cert images.local.crt --key images.local.key
kubectl apply -f configmap.yaml
```

The module can be brought into a project as follows:

```
git -C modules git@github.com:nihr43/registry-tf.git
git submodule update --recursive --remote
```

Create your own configuration:

```
module "registry" {
  source = "./modules/registry-tf"
  port = 30500
  image = "registry:2.8"
  replicas = 2
}
```

init and apply:

```
terraform init
terraform apply
```
