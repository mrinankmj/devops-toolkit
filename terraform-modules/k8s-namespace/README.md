# k8s-namespace module

```hcl
module "team_a" {
  source       = "github.com/mrinankmj/devops-toolkit//terraform-modules/k8s-namespace"
  name         = "team-a"
  cpu_quota    = "2"
  memory_quota = "4Gi"
}
```
Creates the namespace plus a ResourceQuota, a LimitRange with default requests and limits, and a default-deny ingress NetworkPolicy.
