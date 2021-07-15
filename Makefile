
DEFS=fhir-definitions

summary.txt: ${DEFS}/profiles-resources.json
	bin/summarize $< > $@

${DEFS}/profiles-resources.json-force:
	curl -o ${DEFS}/definitions.json.zip http://build.fhir.org/definitions.json.zip && (cd ${DEFS} && unzip definitions.json.zip)

