
DEFS=fhir-definitions

summary.yaml: ${DEFS}/profiles-resources.json bin/summarize Makefile
	bin/summarize $< | \
	sed '/^[a-zA-Z]/i \\n' | \
	tee $@

${DEFS}/profiles-resources.json-force:
	curl -o ${DEFS}/definitions.json.zip http://build.fhir.org/definitions.json.zip && (cd ${DEFS} && unzip definitions.json.zip)

