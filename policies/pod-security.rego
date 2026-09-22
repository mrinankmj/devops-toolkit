package main

import rego.v1

# Host namespaces let a container see (or interfere with) the node itself;
# they should never be needed by a stateless web workload.

deny contains msg if {
	input.kind == "Deployment"
	input.spec.template.spec.hostNetwork == true
	msg := "Pods must not use hostNetwork"
}

deny contains msg if {
	input.kind == "Deployment"
	input.spec.template.spec.hostPID == true
	msg := "Pods must not use hostPID"
}

deny contains msg if {
	input.kind == "Deployment"
	input.spec.template.spec.hostIPC == true
	msg := "Pods must not use hostIPC"
}
