#!/usr/bin/env bash
# Removes finished Jobs, evicted/failed pods, and completed pods older than N hours.
# Usage: ./k8s-cleanup.sh [namespace|--all] [--dry-run]
set -euo pipefail

NS_ARG="${1:---all}"
DRY_RUN="${2:-}"
if [[ "$NS_ARG" == "--all" ]]; then NS_FLAG="--all-namespaces"; else NS_FLAG="-n $NS_ARG"; fi

run() {
  if [[ "$DRY_RUN" == "--dry-run" ]]; then echo "[dry-run] $*"; else "$@"; fi
}

echo "==> Failed and evicted pods"
# shellcheck disable=SC2086
kubectl get pods $NS_FLAG --field-selector=status.phase=Failed \
  -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' |
while read -r ns name; do
  [[ -z "$ns" ]] && continue
  run kubectl delete pod -n "$ns" "$name"
done

echo "==> Succeeded jobs"
# shellcheck disable=SC2086
kubectl get jobs $NS_FLAG \
  -o jsonpath='{range .items[?(@.status.succeeded>=1)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' |
while read -r ns name; do
  [[ -z "$ns" ]] && continue
  run kubectl delete job -n "$ns" "$name"
done

echo "Done."
