# Learning log

Ghi mỗi cuối tuần. Phần *Learned and can explain* và *Bugs I debugged myself* phải do chính mình viết — đó là bằng chứng học thật, không phải danh sách việc Claude đã làm.

Template:

```markdown
## Week N (dd/mm – dd/mm)

### Shipped
- ...

### Learned and can explain
- ...

### Bugs I debugged myself
- Symptom:
- Root cause:
- Fix:
- Prevention/test:

### Still unclear
- ...

### AI-dependency check (1 feature, không nhìn code)
- Request bắt đầu/kết thúc ở đâu:
- Class tham gia:
- Query xuống DB:
- Validation/authorization ở đâu:
- Test chứng minh:

### Next week's smallest goal
- ...
```

---

## Week 1 (14/09 – 20/09/2026)

### Shipped
- Plan v1.1 → v1.2 sau khi review theo trạng thái máy thật (`docs/plan.md`, §0 liệt kê thay đổi).
- `git init`, `.gitignore`/`.editorconfig` từ template `dotnet new`, `.gitattributes`.
- README, CLAUDE.md, backlog MVP (`docs/backlog.md`), decisions (`docs/decisions.md`), setup runbook (`docs/setup.md`).
- Cấu trúc `database/` với DB mẫu `JobTrackSample` và 6 file luyện T-SQL.
- `exercises/README.md` với bài tập tuần 1–6 và tiêu chí.
- Issue/PR template.
- .NET 10 SDK 10.0.401 + `global.json`, dotnet-ef 10.0.12, C# Dev Kit + MSSQL extension; console app `net10.0` chạy thử OK.
- (Tự làm tiếp) commit đầu tiên, GitHub remote + push, Issues từ backlog, `exercises/week1-hello`.

### Learned and can explain
- (Tự viết) SDK vs runtime; project vs solution; NuGet là gì.
- (Tự viết) Git working tree / staging / commit khác nhau thế nào.
- (Tự viết) Breakpoint, step over, step into.

### Bugs I debugged myself
- Symptom:
- Root cause:
- Fix:
- Prevention/test:

### Still unclear
- 

### Next week's smallest goal
- Chạy `sqlcmd -S localhost -E -i database/seed/practice-sample.sql` và viết 10 query SELECT đầu tiên vào `database/sql-practice/01-select-filter.sql`.
- Hoàn thành 3 bài console tuần 2 trong `exercises/`.
