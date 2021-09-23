# test coverage by definition


**~/checkouts/ericprud/fhir-w5$** [./bin/summarizeDefinitions](bin/summarizeDefinitions) fhir-definitions/profiles-resources.json<br/>
starting with 218 Resources<br/>
trimmed to 149 Resources<br/>
[Properties](properties.yaml):  1444
* [reusedProperties](reusedProperties.yaml):  484
* [singletonProperties](singletonProperties.yaml):  960

[conflictingDefns](conflictingDefns.yaml):  36


# test coverage of w5 mappings

This was an old strategy that I've (ericP) somewhat abandoned in favor of analyzing definitions.

## summarize

1. read `profiles-resources.json`
2. emits four groups into [`summary.yaml`](summary.yaml)


### All mapped
Every instance of the name had a w5 mapping, e.g.
``` yaml
  enterer:
    FiveWs.actor:
      - ChargeItem
    FiveWs.author:
      - Claim
      - CoverageEligibilityRequest
      - ExplanationOfBenefit
      - MessageHeader
```
Five resources use the property name `enterer`, four are mapped to `FiveWs.author`, one to `FiveWs.actor`.

**evaluation**: Consider whether different w5 bindings are consistent enough to have a single RDF predicate description.


### None mapped
No instances of the name had a w5 mapping, e.g.
``` yaml
  adjudication:
    - ClaimResponse.item
    - ClaimResponse.item.detail
    - ClaimResponse.item.detail.subDetail
    - ClaimResponse.addItem
    - ClaimResponse.addItem.detail
    - ClaimResponse.addItem.detail.subDetail
    - ClaimResponse
    - ExplanationOfBenefit.item
    - ... <elided>
    - ExplanationOfBenefit
```
`ClaimResponse` uses the property `adjudication` many places, at different levels of indentation.

**evaluation**: Consider whether the meaning in the different resources is consistent enough to have a single RDF predicate description.


### Some Mapped
Some instances of the name had a w5 mapping, others did not, e.g.
``` yaml
  basedOn:
    w5:
      FiveWs.why[x]:
        - AuditEvent
        - Provenance
      FiveWs.cause:
        - ImagingStudy
    bare:
      - Appointment
      - CarePlan
      - ... <20 elided>
      - Task
```
There are multiple uses of `basedOn`, some mapped to different w5 names, some not mapped at all.


### Single mappings or use
There is no ambiguity about the use of the name, either because all uses share the same `w5` binding or because there's only one use without a w5 binding.
``` yaml
  active:
    w5:
      FiveWs.status:
        - BodyStructure
        - ... <10 elided>
        - Schedule
    bare: []
```

## status

Runs, but not really vetted.

## [`summarize`](bin/summarize) process

1. Read a `profiles-resources.json`, which is a Bundle with FHIR opperation and structure defintions in the `entry` array.
2. Filter for structure defintions
3. remove meta structures:
   - `CapabilityStatement` `StructureDefintion` and anything with that `resourceType`
   - `CompartmentDefinition` `StructureDefintion` and anything with that `resourceType`
   - `Bundle`
   - `StructureDefintion`
   - `Resource`
   - `DomainResource`
   (The contents of last two are included in every remaining Resource).
5. For each bundle entry (Resource StructureDefinition) `r`
   1. For each field `f` in `r.differential.element`
      1. extract w5 mappings, if any, from `f.mapping` , e.g.
         ``` json
         "mapping": [
           { "identity": "w5", "map": "FiveWs.what[x]" },
           { "identity": "v2", "map": "OBX-3" }
         ]
         ```
      2. index field hierarchy by property name and any w5 mappings
