package main

import rego.v1

# Policy-as-code checks run with conftest against rendered manifests.

deny contains msg if {
	input.kind == "Deployment"
	some c in input.spec.template.spec.containers
	not c.resources.limits
	msg := sprintf("Container '%s' must set resource limits", [c.name])
}

deny contains msg if {
	input.kind == "Deployment"
	some c in input.spec.template.spec.containers
	endswith(c.image, ":latest")
	msg := sprintf("Container '%s' must not use the ':latest' tag", [c.name])
}

deny contains msg if {
	input.kind == "Deployment"
	not input.spec.template.spec.securityContext.runAsNonRoot
	msg := "Pods must set securityContext.runAsNonRoot: true"
}

warn contains msg if {
	input.kind == "Deployment"
	some c in input.spec.template.spec.containers
	not c.readinessProbe
	msg := sprintf("Container '%s' should define a readinessProbe", [c.name])
}
