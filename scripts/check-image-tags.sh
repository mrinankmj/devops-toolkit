#!/usr/bin/env bash
# Lists running containers that use ':latest' or untagged images (bad practice in prod).
set -euo pipefail

kubectl get pods --all-namespaces \
  -o jsonpath='{range .items[*]}{.metadata.namespace}{"/"}{.metadata.name}{" "}{range .spec.containers[*]}{.image}{" "}{end}{"\n"}{end}' |
awk '{
  for (i = 2; i <= NF; i++) {
    img = $i
    n = split(img, parts, "/")
    last = parts[n]
    if (img ~ /:latest$/ || last !~ /:/) print "⚠️  " $1 " uses " img
  }
}'
