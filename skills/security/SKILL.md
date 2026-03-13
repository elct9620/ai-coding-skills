---
name: security
description: Prevent security vulnerabilities through threat modeling, trust boundary analysis, and defense in depth. Use when writing code that crosses trust boundaries, handles authentication or authorization, processes external input, manages secrets, or stores sensitive data. Make sure to use this skill whenever the user works on login flows, processes data from external sources, builds interfaces between systems, manages credentials, or writes code that moves data across trust zones — even for seemingly simple changes like accepting a new parameter or calling an external service.
---

## Related Skills

- Designing API contracts or database schemas? → Use **schema** to enforce minimal exposure and proper constraints
- Structuring layers around trust boundaries? → Use **clean-architecture** for proper boundary separation
- Writing tests for security-sensitive code? → Use **testing** to verify security behavior
- Handling domain rules around access control? → Use **domain-modeling** for authorization aggregates
- Applying least privilege or single responsibility to security design? → Use **principles** for SOLID guidance

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| Trust boundary crossing | Data moves between zones of different trust levels (including stored data re-entering logic) | All data stays within a single trust zone |
| Identity or access decision | Code decides who someone is or what they can do | No identity or permission logic |
| Secret or credential handling | API keys, passwords, tokens, encryption keys involved | No sensitive credentials handled |
| Sensitive data storage or transmission | PII, financial data, health data processed | No sensitive data involved |

**Apply when**: Any condition passes

## Core Principles

### Golden Rule

> **Every security decision is a trust decision.** Before writing any security-sensitive code, ask: "Who am I trusting, with what, and what happens if that trust is violated?"

### STRIDE Threat Thinking

> Systematically analyze threats before writing security-sensitive code. STRIDE is a thinking process, not a checklist.
> Reference: Microsoft Security Development Lifecycle (SDL).

```
┌──────────────────────────────┐
│ 1. IDENTIFY                  │
│    What components change?    │
│    (processes, data stores,   │
│     data flows, boundaries)   │
└─────────────┬────────────────┘
              ↓
┌──────────────────────────────┐
│ 2. QUESTION                  │
│    For each component, ask    │
│    the 6 STRIDE questions     │
└─────────────┬────────────────┘
              ↓
┌──────────────────────────────┐
│ 3. VERIFY                    │
│    Does a mitigation exist    │
│    in the code for each       │
│    applicable threat?         │
└─────────────┬────────────────┘
              ↓
┌──────────────────────────────┐
│ 4. IMPLEMENT                 │
│    Add missing mitigations    │
│    before proceeding          │
└──────────────────────────────┘
```

| Category | Threatened Property | Question to Ask |
|----------|-------------------|-----------------|
| **S**poofing | Authentication | Can an attacker pretend to be another user or system? |
| **T**ampering | Integrity | Can data be modified without detection? |
| **R**epudiation | Non-repudiation | Can a user deny performing an action with no audit trail? |
| **I**nformation Disclosure | Confidentiality | Can sensitive data leak through errors, logs, or side channels? |
| **D**enial of Service | Availability | Can an attacker exhaust resources or degrade service? |
| **E**levation of Privilege | Authorization | Can an unprivileged user gain higher access? |

### Trust Boundaries

> Never trust data that crosses a boundary. All external input is hostile until validated.

```
┌─────────────────────────────────┐
│         Your System             │
│  ┌───────────────────────────┐  │
│  │    Core Logic             │  │
│  │    (trusted zone)         │  │
│  └─────────┬─────────────────┘  │
│            │ validate here      │
│  ┌─────────▼─────────────────┐  │
│  │    Boundary Layer         │  │
│  │    (input/output gates)   │  │
│  └─────────┬─────────────────┘  │
└────────────┼────────────────────┘
             │ untrusted
     ┌───────▼────────┐
     │  External World │
     │  (users, other  │
     │   systems, I/O) │
     └────────────────┘
```

| Zone Transition | Validation Required |
|----------------|-------------------|
| External → Boundary | Validate type, format, length, range; reject on failure |
| Boundary → Core | Data is already validated; safe to process |
| Core → External | Encode or sanitize for the target context |
| System A → System B | Treat as external; re-validate at receiving boundary |
| Stored data → Output | Re-validate if data was originally from an untrusted source |

### Defense in Depth

> No single security control should be the sole line of defense. Layer protections so that a failure in one layer does not compromise the system.

| Layer | Purpose | Example |
|-------|---------|---------|
| Boundary validation | Reject malformed input early | Type checking, length limits, format validation |
| Business logic enforcement | Apply domain-level constraints | Authorization checks, ownership verification |
| Data layer protection | Prevent direct manipulation | Instruction/data separation, access control at storage level |
| Output encoding | Prevent data from being interpreted as instructions | Context-aware encoding on output |
| Monitoring & audit | Detect and respond to failures | Security event logging, anomaly detection |

### Core Security Principles

| # | Principle | Description | STRIDE Link |
|---|-----------|-------------|-------------|
| 1 | **Fail secure** | When a control fails, deny access rather than grant it | S, E |
| 2 | **Least privilege** | Grant minimum permissions needed; deny by default | E |
| 3 | **Separate instructions from data** | Never let external data be interpreted as executable instructions | T, E |
| 4 | **Don't roll your own crypto** | Use established, vetted implementations for authentication, encryption, and hashing | S, T, I |
| 5 | **Minimize exposure** | Collect, store, and transmit only what is necessary; strip everything else | I |
| 6 | **Verify, then trust** | Authenticate identity and authorize actions at the enforcement point, on every request | S, E |
| 7 | **Keep secrets secret** | Credentials never in source code, logs, or error messages; support rotation | I |

### Injection as Trust Violation

> Injection flaws dominate the CWE Top 25 (2024). They are all violations of Principle #3 — mixing instructions with data. The table below shows how this manifests across contexts.

| Context | Instruction | Data | Defense |
|---------|------------|------|---------|
| Query language | Query structure | Parameter values | Parameterized queries / prepared statements |
| Markup/template | Template structure | User-supplied content | Context-aware output encoding; use framework defaults |
| System command | Command and arguments | User-supplied values | Array-based APIs; avoid shell interpretation |
| File system | Base path | User-supplied path segment | Resolve canonical path; validate against allowlist |
| Serialization | Object structure | Serialized payload | Use safe formats; never deserialize untrusted input into executable objects |

## Security Decision Tables

### Authentication Strategy Selection

| Factor | Use platform/framework auth | Use managed identity service | Build custom |
|--------|---------------------------|----------------------------|-------------|
| Team has security expertise | Optional | Optional | Required |
| Compliance requirements | Standard | Strict | Specialized |
| Time to market | Fast | Medium | Slow |
| Maintenance burden | Low | Medium | High |
| Risk of getting it wrong | Low | Low | **Very high** |

**Default choice**: Use platform/framework auth. Only escalate when constraints demand it.

### Secret Storage Selection

| Secret Type | Environment variables | Secret manager service | Hardware security module |
|-------------|----------------------|----------------------|------------------------|
| Development credentials | Suitable | Overkill | Overkill |
| Production API keys | Acceptable | Recommended | Optional |
| Encryption keys | Insufficient | Recommended | Preferred |
| Signing keys (release/deploy) | Insufficient | Acceptable | Recommended |
| User credentials (passwords) | Never store directly | Hash with bcrypt/scrypt/argon2 | N/A |

### Sensitive Data Handling

| Decision | Collect | Store | Transmit | Log |
|----------|---------|-------|----------|-----|
| PII (names, emails) | Only if needed | Encrypt at rest | Encrypt in transit | Redact |
| Credentials | At auth boundary only | Hash, never plaintext | Encrypt in transit | Never |
| Financial data | Only if needed | Encrypt at rest | Encrypt in transit | Redact |
| Health data | Only with consent | Encrypt at rest | Encrypt in transit | Never |
| Internal system tokens | Auto-generated | Rotate regularly | Encrypt in transit | Redact |

## Security Code Review Process

> Apply this process when reviewing changes that touch security-sensitive code.

| Step | Action | Question to Ask |
|------|--------|----------------|
| 1. Identify trust boundaries | Map where external data enters through changed code | What data crosses a trust boundary in this change? |
| 2. Apply STRIDE | For each changed component, run the 6 STRIDE questions | Which threats apply to this component? |
| 3. Check instruction/data separation | Verify external data is never treated as instructions | Is any external input concatenated into queries, commands, templates, or paths? |
| 4. Verify access controls | Confirm identity and permission checks on every protected path | Can an unauthenticated or unauthorized caller reach this code? |
| 5. Trace sensitive data | Follow sensitive data from input to storage to output | Does any sensitive data leak into logs, errors, or unencrypted channels? |
| 6. Validate defense layers | Confirm no single control is the sole protection | If this one check fails, what stops the attacker? |
| 7. Check for regressions | Confirm no existing security controls were weakened | Were any validations removed, permissions relaxed, or controls bypassed? |

## Working with Unsecured Legacy Code

When facing code with known security gaps, prioritize systematically rather than attempting to fix everything at once.

### Security Triage

| Priority | Criteria | Action |
|----------|----------|--------|
| **Critical** | Actively exploitable; data exposure imminent | Fix immediately; consider taking the feature offline |
| **High** | Trust boundary violation with no mitigation | Fix before next release |
| **Medium** | Defense in depth gap (one layer missing) | Plan fix within current cycle |
| **Low** | Best practice gap with existing compensating controls | Track and address incrementally |

### Security Characterization

Before fixing legacy security issues, understand the current state — similar to characterization tests for refactoring.

1. **Map trust boundaries** — identify all points where external data enters the system
2. **Catalog existing controls** — document what validation, authentication, and authorization already exists
3. **Identify gaps** — compare existing controls against STRIDE analysis
4. **Prioritize by triage** — apply the triage table above to determine fix order
5. **Fix incrementally** — add one security control at a time, verify it works, then proceed

### Common Legacy Security Patterns

| Pattern | Risk | Incremental Fix |
|---------|------|-----------------|
| No input validation at boundary | Injection, data corruption | Add boundary validation layer; route all input through it |
| Hardcoded credentials | Credential exposure | Extract to environment/secret manager; rotate compromised credentials |
| Missing access controls | Unauthorized access | Add deny-by-default access layer; enable per-entry-point |
| Plaintext sensitive data | Data breach | Encrypt at rest; migrate existing data in batches |
| No audit trail | Repudiation, undetected breaches | Add security event logging at trust boundaries |

## Completion Rubric

### Before

| Criterion | Pass | Fail |
|-----------|------|------|
| Trust boundaries identified | Know where external data enters the system | Unclear what input is external |
| STRIDE threats considered | Systematically checked each category for the change | No threat analysis performed |
| Access model understood | Know who can access what and how identity is verified | Authorization requirements unclear |
| Secrets plan | Know how credentials will be stored, accessed, and rotated | No plan for secret management |

### During

| Criterion | Pass | Fail |
|-----------|------|------|
| Input validated at boundary | All external input validated before use | Validation missing or done too late |
| Instructions separated from data | No external data concatenated into executable contexts | External data mixed with instructions |
| Access enforced at enforcement point | Permission checks on every protected path | Client-only or missing access checks |
| Secrets not in source | Credentials from environment or secret manager | Credentials in source code, logs, or errors |
| Defense in depth applied | Multiple layers protect sensitive operations | Single point of failure in security controls |
| Fail-secure behavior | Errors deny access rather than grant it | Failures result in open access |

### After

| Criterion | Pass | Fail |
|-----------|------|------|
| No secrets in code or history | Repository clean of credentials | Secrets committed at any point |
| Security tests exist | Tests verify access control, input rejection, boundary enforcement | No tests for security behavior |
| STRIDE analysis complete | Threats identified and mitigations verified for each component | No record of threat consideration |
| Audit trail in place | Security-relevant events are logged without exposing sensitive data | No visibility into security events |
