---
name: security
description: Prevent security vulnerabilities including OWASP Top 10, injection attacks, broken authentication, and insecure data handling. Use when writing code that handles user input, authentication, authorization, database queries, external API calls, file operations, or secret management. Make sure to use this skill whenever the user works on login/signup flows, processes form data, builds API endpoints, handles file uploads, manages secrets or credentials, or writes code that crosses trust boundaries — even for seemingly simple changes like adding a query parameter or a new form field.
---

## Related Skills

- Designing API contracts or database schemas? → Use **schema** to ensure minimal exposure and proper constraints
- Structuring authentication/authorization layers? → Use **clean-architecture** for proper boundary separation
- Writing tests for security-sensitive code? → Use **testing** to verify security behavior
- Handling domain rules around access control? → Use **domain-modeling** for authorization aggregates

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| User input handling | Code receives external input (forms, query params, headers, file uploads) | No external input processed |
| Authentication/authorization | Login, signup, session, token, or permission logic | No auth-related code |
| Data persistence with external input | Storing user-supplied data in database or file system | Internal-only data operations |
| Secret/credential management | API keys, passwords, tokens, encryption keys involved | No sensitive data handled |
| Cross-trust-boundary communication | Calling external APIs, rendering user content, executing commands | Communication within single trust boundary |
| File or process operations | File read/write, command execution, path construction with input | No file/process operations |

**Apply when**: Any condition passes

## Core Principles

### Trust Boundaries

> Never trust data that crosses a boundary. All external input is hostile until validated.

```
┌─────────────────────────────────┐
│         Your Application        │
│  ┌───────────────────────────┐  │
│  │    Business Logic         │  │
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
     │  (users, APIs,  │
     │   files, CLI)   │
     └────────────────┘
```

| Source | Examples | Action |
|--------|----------|--------|
| User input | Form fields, query params, headers, cookies | Validate type, length, format; reject on failure |
| File uploads | Images, documents, CSV | Validate MIME type, size limit, sanitize filename |
| External APIs | Third-party responses, webhooks | Validate schema, verify signatures |
| Database reads | Data previously stored from user input | Re-validate before use in sensitive contexts (e.g., rendering HTML) |
| Environment/config | ENV vars, config files | Validate at startup, fail fast on missing required values |

### Injection Prevention

| Attack | Vector | Defense |
|--------|--------|---------|
| SQL Injection | String concatenation in queries | Parameterized queries / prepared statements — never interpolate |
| XSS (Cross-Site Scripting) | Rendering unsanitized user content | Context-aware output encoding; use framework auto-escaping |
| Command Injection | User input in shell commands | Avoid shell execution; use array-based APIs (e.g., `subprocess.run([...])`) |
| Path Traversal | User input in file paths | Validate against allowlist; resolve and check canonical path |
| LDAP/XML/Template Injection | User input in structured queries or templates | Use safe APIs; never build queries by string interpolation |

### Injection Prevention Checklist

| Context | Safe | Unsafe |
|---------|------|--------|
| SQL | `WHERE id = ?` with param binding | `WHERE id = #{params[:id]}` |
| HTML | Framework auto-escaping enabled | `innerHTML = userInput` |
| Shell | `Process.spawn("cmd", arg1, arg2)` | `system("cmd #{user_input}")` |
| File path | `File.join(UPLOAD_DIR, SecureRandom.hex)` | `File.join(UPLOAD_DIR, params[:filename])` |
| URL | Allowlist of permitted hosts | Redirect to `params[:url]` without validation |
| Regex | Anchored patterns `\A...\z` | Unanchored `^...$` (allows multiline bypass) |

### Authentication & Session Security

| Concern | Requirement | Violation Sign |
|---------|-------------|----------------|
| Password storage | Use bcrypt/scrypt/argon2 with salt | Storing plaintext or using MD5/SHA1 |
| Session management | Secure, HttpOnly, SameSite cookies; regenerate ID on login | Session fixation, no expiry, missing flags |
| Token handling | Short-lived JWTs; refresh token rotation; server-side revocation | Long-lived tokens, no revocation mechanism |
| Rate limiting | Limit login attempts per account and IP | Unlimited authentication attempts |
| Multi-factor | Support MFA for sensitive operations | Single factor for high-value actions |

### Authorization

| Principle | Description | Violation Sign |
|-----------|-------------|----------------|
| Least privilege | Grant minimum permissions needed | Broad roles, admin-by-default |
| Server-side enforcement | Always check on server, never trust client | Client-only permission checks |
| Resource-level checks | Verify user owns/can access specific resource | Only checking "is logged in" |
| Deny by default | Explicitly grant access, deny everything else | Allowlisting missing, implicit allow |

### Secrets Management

| Rule | Do | Don't |
|------|------|-------|
| Storage | Environment variables or secret manager (Vault, AWS SM) | Hardcoded in source code or config files |
| Version control | `.gitignore` secrets; use `.env.example` for templates | Commit `.env`, API keys, or private keys |
| Rotation | Support key rotation without downtime | Single non-rotatable key |
| Logging | Redact secrets from logs and error messages | Log full request headers or credentials |
| Default credentials | Force change on first use | Ship with admin/admin |

### Secure Defaults

| Area | Secure Default | Insecure Default |
|------|----------------|-----------------|
| CORS | Restrictive origin allowlist | `Access-Control-Allow-Origin: *` |
| Content-Type | Explicit `Content-Type` with charset | Missing or `text/html` for API responses |
| HTTPS | Enforce TLS; HSTS header | Allow HTTP in production |
| Error responses | Generic error message to client | Stack traces or internal details exposed |
| File permissions | Restrictive (0600/0644) | World-readable/writable |
| Cookie flags | `Secure; HttpOnly; SameSite=Lax` | No flags set |
| CSP | Content-Security-Policy header | No CSP or `unsafe-inline` |

### Dependency Security

| Practice | Description |
|----------|-------------|
| Lock files | Always commit lock files (Gemfile.lock, package-lock.json, go.sum) |
| Audit regularly | Run `npm audit`, `bundle audit`, `govulncheck` in CI |
| Pin versions | Use exact versions or tight ranges for production dependencies |
| Minimal dependencies | Fewer deps = smaller attack surface |
| Update promptly | Patch known vulnerabilities within days, not months |

## Common Vulnerability Patterns

| Pattern | Risk | Detection | Fix |
|---------|------|-----------|-----|
| Mass assignment | Unauthorized field modification | Controller accepts all params | Allowlist permitted attributes explicitly |
| Insecure direct object reference (IDOR) | Access to other users' resources | ID from URL without ownership check | Scope queries to current user |
| Open redirect | Phishing via trusted domain | Redirect URL from user input | Allowlist redirect destinations |
| CSRF | Unauthorized state changes | No CSRF token on state-changing requests | Framework CSRF protection enabled |
| Sensitive data in URL | Credentials in logs/history | Tokens or secrets in query parameters | Use headers or POST body |
| Verbose errors | Information disclosure | Stack traces in production responses | Generic errors; detailed logging server-side only |
| Missing rate limiting | Brute force, DoS | No throttling on sensitive endpoints | Rate limit by IP and account |

## Completion Rubric

### Before

| Criterion | Pass | Fail |
|-----------|------|------|
| Trust boundaries identified | Know where external data enters | Unclear what input is external |
| Threat awareness | Understand which attacks apply to this change | No consideration of threats |
| Auth model understood | Know who can access what | Authorization requirements unclear |
| Secrets plan | Know how credentials will be stored and accessed | No plan for secret management |

### During

| Criterion | Pass | Fail |
|-----------|------|------|
| Input validated at boundary | All external input validated before use | Validation missing or done too late |
| Parameterized queries | No string interpolation in queries | Dynamic query construction with user input |
| Output encoded | User content encoded for output context | Raw user content rendered |
| Auth enforced server-side | Permission checks on every protected endpoint | Client-only or missing auth checks |
| Secrets not hardcoded | Credentials from env/secret manager | API keys or passwords in source code |
| Error messages safe | No internal details in client-facing errors | Stack traces or SQL errors exposed |
| Secure defaults applied | HTTPS, secure cookies, CSP, CORS restricted | Security headers missing or permissive |

### After

| Criterion | Pass | Fail |
|-----------|------|------|
| No secrets in code | `git log` and diff clean of credentials | Secrets committed at any point |
| Dependency audit clean | No known vulnerabilities in dependencies | Unpatched CVEs in dependency tree |
| Security tests exist | Tests verify auth, input rejection, boundary enforcement | No tests for security behavior |
| OWASP Top 10 reviewed | Changes checked against relevant OWASP categories | No security review performed |
