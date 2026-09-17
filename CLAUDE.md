# Working agreement

## Project goal

JobTrack is a learning-first portfolio project for a junior .NET backend developer. The owner is learning C#/.NET while building it; the roadmap is `docs/plan.md` (Vietnamese). The goal is that the owner can explain and modify every line — not that the project is finished fast.

## Environment (verified 2026-09-14)

- Windows 10, Git Bash. Target .NET 10 (`global.json` pins the SDK once installed).
- SQL Server 2022 Developer on `localhost` (default instance, Windows auth). Run scripts with `sqlcmd -S localhost -E -i <file.sql>`.
- No Node.js: Tailwind uses the standalone CLI. No Docker until week 19.
- Local dev connection strings live in `dotnet user-secrets`, never in files.

## How to help

- Explain the relevant concept before making a non-trivial change.
- Work on one GitHub issue or one small vertical slice at a time.
- Prefer small, reviewable diffs. Do not replace an entire file when a focused edit is enough.
- Ask before adding a new package, service, architectural layer, project, or major pattern.
- Do not implement unrelated improvements.
- After changes, list files changed, commands run, test results, and remaining risks.
- When there are multiple valid approaches, explain the simplest option and its trade-off.
- Mark generated assumptions clearly. If requirements are ambiguous, ask before coding.

## What Claude may do vs. what the owner does

Claude may: scaffold config/templates/docs, explain errors, suggest fixes in order of likelihood, review diffs, generate sample/seed data, draft README/runbook text.

The owner does: the first implementation of each business rule, controller and query; debugging with breakpoints before asking; writing tests for rules they wrote; the T-SQL practice queries in `database/sql-practice/`; the weekly `LEARNING_LOG.md` entry.

When asked to "just do" a learning task (e.g. the week 2–4 exercises, the first version of a feature), offer hints and a small starting point instead, and say why.

## Code rules

- Target .NET 10, nullable reference types enabled, implicit usings enabled.
- Use async APIs for database/network I/O and accept `CancellationToken` where appropriate.
- Keep controllers thin; business rules live in Domain/Features, not in views, JavaScript or controllers.
- Never expose or log passwords, tokens, connection strings, or personal data.
- Never trust a `UserId` sent by the client; derive identity from the authenticated user, and scope every Company/JobApplication query by that user.
- Store times in UTC (`datetime2`); convert only for display.
- Use EF Core migrations for every schema change, with a descriptive name.
- Use request/response models at API boundaries; do not return entities directly.
- No generic repository over `DbContext`. Add abstractions only for a demonstrated need.
- OpenAPI via `Microsoft.AspNetCore.OpenApi` (built-in), not Swashbuckle generators.
- Add or update meaningful tests for changed behavior. Do not hide warnings or weaken tests to make the pipeline green.

## Conventions

- Branches: `feature/<short-name>`, `fix/<short-name>`. Commits: Conventional Commits (`feat:`, `fix:`, `test:`, `docs:`, `chore:`, `refactor:`).
- Every feature follows the Definition of Done in `docs/plan.md` §10 and `.github/pull_request_template.md`.
- Decisions with trade-offs go in `docs/decisions.md`.
