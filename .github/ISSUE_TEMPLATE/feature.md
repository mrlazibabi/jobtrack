---
name: Feature
about: One small vertical slice (UI → controller → domain → database → test)
title: ""
labels: feature
assignees: ""
---

## Goal

One sentence: as a <user>, I want <thing> so that <benefit>.

## Acceptance criteria

- [ ] 
- [ ] 
- [ ] Belongs to / visible to the current user only (ownership checked server-side)
- [ ] Invalid input shows validation messages; no 500s

## Out of scope

- 

## Notes / design sketch

Flow: request → route → controller → feature/service → domain rule → DbContext → response.
Queries involved:
Tests to write:

## Definition of Done

- [ ] Acceptance criteria met
- [ ] Authorization and validation verified (including a cross-user attempt)
- [ ] No secrets or stray files in Git
- [ ] `dotnet build` clean, `dotnet test` green
- [ ] Manual test: happy path + at least one invalid path
- [ ] UI has loading/empty/error state where relevant
- [ ] Docs/OpenAPI updated if the contract changed
- [ ] I reviewed the full `git diff` and can explain every change
