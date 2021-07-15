# test coverage of w5 mappints

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

Works but not really vetted.

Parses mappings from property definitions (`<bundle>.entry[*].resource.differential.element[*]`), e.g.
``` json
              "mapping": [
                {
                  "identity": "w5",
                  "map": "FiveWs.status"
                },
                {
                  "identity": "rim",
                  "map": ".statusCode"
                }
              ]
```

