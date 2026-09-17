# JobTrack

> A personal job-application tracker built with ASP.NET Core 10, EF Core and SQL Server.
> Learning-first portfolio project — actively developed. See [docs/plan.md](docs/plan.md) for the 24-week roadmap.

## Problem

Job seekers juggle dozens of applications across spreadsheets, emails and calendar invites. It is easy to lose track of which company is at which stage, when the next interview is, and what was discussed last time.

JobTrack keeps everything about one job search in one place: companies, applications, their status, interview rounds and notes — private to each user.

## Users

- **User** — manages their own job search data. Every user sees only their own data; this is a core security requirement, not a feature.
- **Admin** (post-MVP) — manages accounts and views system health.

## MVP scope

- Register, log in, log out; view and edit profile.
- Manage companies.
- Manage job applications with status workflow: `Saved → Applied → Interviewing → Offer / Rejected / Withdrawn`.
- Manage interview rounds per application.
- Notes per application.
- Search, filter (status / company / date range), sort and server-side pagination.
- Dashboard: totals, interviews, offers and status breakdown.
- Basic responsive UI.

Detailed stories with acceptance criteria: [docs/backlog.md](docs/backlog.md).

## Non-goals (v1)

- Social features, real-time chat, AI résumé scoring.
- Microservices, Kubernetes, message brokers, event sourcing.
- Payments, mobile app, multiple frontend frameworks.
- Hand-rolled authentication or password hashing.

## Tech stack

| Area | Choice |
|---|---|
| Runtime | .NET 10 (LTS) |
| Web | ASP.NET Core MVC + REST API controllers |
| Data | Entity Framework Core 10 + SQL Server |
| Auth | ASP.NET Core Identity (cookie) |
| UI | Razor Views, Tailwind CSS (standalone CLI) |
| API docs | Microsoft.AspNetCore.OpenApi + Scalar UI |
| Tests | xUnit, `WebApplicationFactory` |
| Ops | Docker Compose, GitHub Actions, Caddy on a Linux VPS |

Why these choices: [docs/decisions.md](docs/decisions.md).

## Repository layout

```text
src/        application code (from week 7)
tests/      unit and integration tests
database/   T-SQL practice, reference schema and seed scripts
docs/       plan, backlog, decisions, setup, ERD
exercises/  standalone C# exercises (weeks 1–6)
```

## Running locally

> Coming with the first web slice (week 7). Until then see [docs/setup.md](docs/setup.md) for machine setup.

## Status

- [x] Week 1 — repository, plan, backlog, tooling checklist
- [ ] Weeks 2–4 — C# fundamentals
- [ ] Weeks 5–6 — HTTP, REST, EF Core
- [ ] Weeks 7–12 — MVP
- [ ] Weeks 13–16 — quality & testing
- [ ] Weeks 17–18 — UI polish
- [ ] Weeks 19–21 — Docker, CI, deploy
- [ ] Weeks 22–24 — advanced features, portfolio

## License

MIT
