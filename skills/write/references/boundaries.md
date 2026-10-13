# Boundaries

Schema design, API conventions, STRIDE, OWASP, and the CWE Top 25 are known. This file holds the stances this project applies where data crosses a boundary.

## Schemas and contracts

- Store each fact once. Denormalize only with a stated reason.
- Describe non-obvious values at the boundary — status codes, control bytes, enum meaning — so no reader needs service code to interpret them.
- Expose only what consumers need.
- Keep the domain independent of storage and transport: no column or field names in the domain layer.
- Before adding an index, check that no primary key, unique constraint, or composite prefix already covers the query.
- Identify breaking changes and their downstream consumers before changing a contract.

## Trust

Every security decision is a trust decision: who is trusted, with what, and what happens if that trust fails.

| Stance | Means |
|---|---|
| Validate at the boundary | External input — including stored data that came from outside — is hostile until validated |
| Separate instructions from data | Parameterized queries, array-based commands, context-aware encoding |
| Fail secure | A failing control denies access |
| Verify, then trust | Check identity and permission at the enforcement point on every request |
| Framework auth by default | Escalate to a managed service or custom code only when a constraint demands it |
| Secrets stay secret | Never in source, logs, or error messages; rotation stays possible |
| No single control | If one check fails, another layer still stops the attacker |

Security behavior gets tests: rejected input, denied access, enforced boundaries.
