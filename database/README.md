# database/

T-SQL practice track (weeks 2–16 of `docs/plan.md`) and reference SQL for the project.

```text
database/
├─ schema/          your hand-written DDL for JobTrackPractice (weeks 4–7); reference only — the app uses EF Core migrations
├─ seed/
│  └─ practice-sample.sql   creates JobTrackSample with sample data for weeks 2–3 (safe to re-run)
└─ sql-practice/    one file per topic; write your queries under each numbered prompt and commit weekly
```

## Run scripts

From the repository root, with relative paths (`sqlcmd -i` inside Git Bash mangles `E:/...` absolute paths):

```bash
sqlcmd -S localhost -E -i database/seed/practice-sample.sql
sqlcmd -S localhost -E -d JobTrackSample -i database/sql-practice/01-select-filter.sql
```

Or open the file in SSMS 20 / VS Code MSSQL extension (connection: `localhost`, Integrated auth) and run selections with `F5`.

Vietnamese text is stored correctly (`nvarchar` + `N'...'` literals). `sqlcmd` inside Git Bash may print `?` for accented characters — that is console encoding, not the data; SSMS shows it correctly.

## Rules

- Write at least 20 minutes on your own before asking Claude.
- Before running a query, write a one-line comment with the expected result.
- No `SELECT *` in submitted queries.
- Commit each week's file; the target is ≥ 60 self-written queries by week 16.
- Never commit passwords (F09) or `.bak` files (already gitignored).
