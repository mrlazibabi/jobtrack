# Technical decisions

Short ADR-style log. One entry per decision that has a real trade-off. Newest at the bottom. Status: `Accepted`, `Proposed`, `Superseded`.

Format:

```markdown
## D-XXXX — Title (dd/mm/yyyy) — Status
**Context**: why a decision was needed.
**Decision**: what was chosen.
**Alternatives**: what else was considered and why not.
**Consequences**: what this makes easier/harder; when to revisit.
```

---

## D-0001 — Target .NET 10 LTS, not the .NET 9 SDK already installed (14/09/2026) — Accepted

**Context**: The machine has .NET SDK 9.0.310. .NET 9 (STS) and .NET 8 (LTS) both leave support in November 2026; .NET 10 is LTS until November 2028.
**Decision**: Install .NET 10 SDK and pin it with `global.json`. All projects target `net10.0`.
**Alternatives**: Start on .NET 9 and upgrade later — rejected because the upgrade would land mid-MVP and tutorials/gotchas differ (OpenAPI, Identity templates).
**Consequences**: Visual Studio 2022 cannot be used; VS Code + C# Dev Kit is the IDE. Some tutorials will show older APIs; verify against .NET 10 docs.

## D-0002 — SQL Server as the only database (14/09/2026) — Accepted

**Context**: The plan considered MySQL for cheaper hosting. The machine already has SQL Server 2022 Developer + SSMS, and the owner wants to learn T-SQL properly.
**Decision**: SQL Server everywhere: local (Developer), tests (`JobTrack_Test` locally, container in CI), production (Express in a container on an x86-64 VPS).
**Alternatives**: MySQL/MariaDB (cheaper 2 GB VPS) — rejected to avoid provider-specific surprises and to keep one dialect to learn. Supporting both — rejected as pure cost.
**Consequences**: VPS must be x86-64 with ≥4 GB RAM (SQL Server image is amd64-only, needs ≥2 GB). Revisit only if hosting cost becomes the blocker, and then switch before week 7, never at deploy time.

## D-0003 — Cookie authentication with ASP.NET Core Identity; no JWT in v1 (14/09/2026) — Accepted

**Context**: Server-rendered MVC app with a same-origin REST API for the main resources.
**Decision**: Identity + cookie auth. API endpoints under `/api/*` share the cookie but return `401/403` instead of redirecting to the login page.
**Alternatives**: JWT bearer tokens — rejected for v1: no separate client exists, and JWT adds token storage/refresh problems that do not teach anything the job needs yet.
**Consequences**: Requests from JavaScript to `/api/*` must send the antiforgery token (or the API stays for OpenAPI/testing only). Decide and record in D-0006 during week 10. Revisit if a mobile/SPA client is added.

## D-0004 — Store `Status` enums as strings (14/09/2026) — Accepted

**Context**: `JobApplication.Status`, `Interview.Type`, `Interview.Result` are enums. The owner will write T-SQL reports against the tables directly during the SQL track.
**Decision**: Map with `HasConversion<string>()` to `nvarchar(20)` plus a `CHECK` constraint listing allowed values.
**Alternatives**: `int` — smaller and faster to compare, but reports need a lookup to be readable and reordering the enum silently corrupts meaning.
**Consequences**: Slightly larger rows and index keys; acceptable at this scale. Adding a value requires a migration that updates the `CHECK`.

## D-0005 — Start with one web project; extract layers at week 13 (14/09/2026) — Accepted

**Context**: The original plan created Domain/Application/Infrastructure/Web projects in week 7, before any real feature code existed.
**Decision**: Week 7 starts with `JobTrack.Web` (folders `Domain/`, `Features/`, `Data/`) plus two test projects. In week 13, extract `JobTrack.Domain` and `JobTrack.Infrastructure`; extract `JobTrack.Application` only if the number of use cases justifies it.
**Alternatives**: Four projects from day one — rejected: for a beginner it front-loads wiring and project references without a felt reason, contradicting the "add abstraction when needed" rule.
**Consequences**: The week-13 refactor becomes a concrete story for interviews ("why I split it, what it fixed"). Dependencies must still flow one way inside the single project (`Controllers → Features → Domain`) so extraction is mechanical.

## D-0006 — Antiforgery strategy for cookie-authenticated API (week 10) — Proposed

**Context**: To be decided when the first API endpoint is called from browser JavaScript.
**Options**: (a) API is for OpenAPI UI/tests only; UI uses MVC forms with antiforgery. (b) JS sends `RequestVerificationToken` header obtained from a hidden field/cookie. (c) Separate JWT for API (rejected in D-0003 for v1).

## D-0007 — CSS toolchain: Tailwind standalone CLI vs Bootstrap (week 7) — Proposed

**Context**: No Node.js on the machine; the project is backend-focused.
**Options**: (a) Tailwind standalone CLI binary in `tools/` (gitignored), build step documented and run in Dockerfile. (b) Bootstrap 5 shipped by the MVC template — zero build step, less modern look. Pick one in week 7 and record here.

## D-0008 — Applying migrations in production (week 19) — Proposed

**Context**: Single-instance deployment on one VPS.
**Options**: (a) `Database.Migrate()` at startup with clear logging — simplest, fine for a single instance. (b) `dotnet ef migrations bundle` executed as a separate step before the app starts — safer for multi-instance, one more moving part. Default leaning: (a), documented in the runbook with the caveat.
