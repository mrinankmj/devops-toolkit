# devops-toolkit

Reusable building blocks I use for Kubernetes platform work, each tested in CI.

| Path | What it is |
|---|---|
| `charts/web-app` | Secure-by-default Helm chart: non-root, dropped capabilities, probes, optional HPA, PDB, Ingress |
| `terraform-modules/k8s-namespace` | Tenant-ready namespace with quota, default limits and default-deny ingress |
| `scripts/k8s-cleanup.sh` | Deletes failed pods and finished jobs (supports `--dry-run`) |
| `scripts/check-image-tags.sh` | Flags containers running `:latest` or untagged images |
| `k8s/cronjobs/postgres-backup.yaml` | Nightly Postgres backup with 7-day retention |
| `policies/` | OPA/Rego policies enforced with conftest: resource limits, no `:latest`, non-root, no host namespaces |

## CI
Every push runs **shellcheck**, **helm lint**, renders the chart and checks it against the **Rego policies** with conftest, then runs **terraform fmt/validate** on the modules.

## Quick use
```bash
helm install my-api charts/web-app --set image.repository=myrepo/api --set image.tag=1.2.0
./scripts/k8s-cleanup.sh default --dry-run
```
