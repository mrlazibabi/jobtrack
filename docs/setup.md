# Thiết lập máy phát triển (Windows 10, kiểm tra ngày 14/09/2026)

Tài liệu này là runbook cài đặt cho máy hiện tại. Mỗi bước có lệnh kiểm tra để biết đã xong hay chưa.

## 1. Trạng thái xuất phát

| Hạng mục | Có sẵn | Cần làm |
|---|---|---|
| .NET SDK | 8.0.131, 9.0.200, 9.0.310 | ✅ Đã cài 10.0.401 (14/09); `global.json` ghim 10.x |
| `dotnet-ef` | 7.0.13 | ✅ Đã cập nhật 10.0.12 (14/09) |
| SQL Server | 2022 Developer, instance `localhost` (Windows auth) | Không cần cài; `JobTrackSample` đã tạo |
| SSMS 20, `sqlcmd` 16 | ✅ | — |
| VS Code 1.135 | ✅ | ✅ Đã cài C#, C# Dev Kit, MSSQL (14/09) |
| Git 2.51 | ✅ | Tạo remote GitHub |
| Docker Desktop | ✗ | Tuần 19 (hoặc stretch tuần 12) |
| WSL2 | Bật, chưa có distro | Docker Desktop sẽ tự lo |
| Node.js | ✗ | Không cần |

## 2. Cài .NET 10 SDK

Mở PowerShell hoặc Git Bash (sẽ có hộp thoại UAC):

```powershell
winget install --id Microsoft.DotNet.SDK.10 --exact --source winget --accept-package-agreements --accept-source-agreements
```

Kiểm tra (mở terminal **mới** sau khi cài):

```bash
dotnet --list-sdks          # phải thấy dòng 10.0.x
dotnet --version            # ở thư mục E:\JobTrack: 10.0.x (do global.json ghim)
```

Nếu `dotnet --version` vẫn ra 9.x ngoài repo thì bình thường: SDK mới nhất chỉ được ưu tiên khi không có `global.json`, còn trong repo `global.json` sẽ ghim 10.x.

## 3. Cập nhật `dotnet-ef`

```bash
dotnet tool update --global dotnet-ef
dotnet ef --version         # 10.0.x
```

## 4. VS Code extensions

```bash
code --install-extension ms-dotnettools.csharp
code --install-extension ms-dotnettools.csdevkit
code --install-extension ms-mssql.mssql
```

Extension đã có và hữu ích cho dự án: `humao.rest-client` (file `.http`), `eamodio.gitlens`, `github.vscode-pull-request-github`, `ms-azuretools.vscode-docker`, `editorconfig.editorconfig`.

Extension Node/JS hiện tại không cản trở; có thể tắt theo workspace nếu thấy rối (Extensions → chuột phải → *Disable (Workspace)*).

## 5. Kết nối SQL Server

Instance mặc định `localhost`, Windows Authentication:

```bash
sqlcmd -S localhost -E -Q "SELECT @@VERSION"
sqlcmd -S localhost -E -i database/seed/practice-sample.sql     # tạo DB mẫu JobTrackSample
sqlcmd -S localhost -E -d JobTrackSample -Q "SELECT COUNT(*) FROM dbo.JobApplications"
```

Trong VS Code (MSSQL extension): *Add Connection* → Server `localhost` → Authentication *Integrated*.

Connection string cho ứng dụng (local dev, **không commit**; đặt bằng `dotnet user-secrets` ở tuần 6–7):

```text
Server=localhost;Database=JobTrack;Integrated Security=true;TrustServerCertificate=true
```

Ở tuần 15 sẽ tạo login SQL riêng cho app với quyền tối thiểu thay cho Windows auth/`sa`.

## 6. HTTPS dev certificate

```bash
dotnet dev-certs https --trust
```

## 7. GitHub

Không có `gh` CLI (tùy chọn cài: `winget install GitHub.cli`). Tạo repo bằng web:

1. github.com → New repository → `jobtrack`, Public, **không** tick "Add README" (repo local đã có).
2. Trong `E:\JobTrack`:

```bash
git remote add origin https://github.com/<username>/jobtrack.git
git push -u origin main
```

3. Tạo Project (Kanban) với cột `Backlog`, `Ready`, `In progress`, `Review`, `Done`.
4. Tạo Issues từ `docs/backlog.md` bằng template *Feature*.

## 8. Docker Desktop (tuần 19)

Yêu cầu: Windows 10 22H2 build 19045 trở lên + WSL2 — máy đáp ứng.

```powershell
winget install --id Docker.DockerDesktop --exact --source winget --accept-package-agreements --accept-source-agreements
```

Sau khi cài và đăng nhập lại Windows:

```bash
docker version
docker run --rm hello-world
```

## 9. Kiểm tra tổng hợp

```bash
dotnet --version && dotnet ef --version && git --version && sqlcmd -S localhost -E -Q "SELECT 1" && code --list-extensions | grep -i "csdevkit\|mssql"
```

Tất cả in ra phiên bản hợp lệ → xong tuần 1 phần công cụ.
