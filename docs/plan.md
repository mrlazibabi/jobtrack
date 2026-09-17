# Kế hoạch học và xây dựng dự án cá nhân .NET Backend để xin việc

> Phiên bản: **1.2** — review theo trạng thái máy thực tế + góc nhìn senior mentor
> Ngày lập: 14/09/2026 (v1.1) · Cập nhật: 14/09/2026 (v1.2)
> Thời lượng đề xuất: 24 tuần, khoảng 12–15 giờ/tuần
> Đối tượng: Sinh viên mới tốt nghiệp, nền tảng C#/.NET còn yếu, định hướng Junior .NET Backend
> Bản gốc v1.1 được lưu ở `docs/archive/plan-v1.1.md` để đối chiếu.

---

## 0. Thay đổi so với v1.1 (đọc trước)

Bản v1.1 đã tốt về phạm vi, thứ tự học và tinh thần "học thật, không để AI làm thay". Những thay đổi dưới đây không mở rộng phạm vi; chúng sửa các điểm **sai với thực tế máy**, **mâu thuẫn thứ tự**, và **gotcha phiên bản** mà một Junior dễ mất nhiều ngày vì chúng.

### Must change (đã áp dụng)

| # | Thay đổi | Lý do |
|---|---|---|
| M1 | Thêm bảng **"Trạng thái máy tại 14/09/2026"** (§3.1) và checklist cài đặt cụ thể | Máy đang có .NET SDK **9.0.310**, chưa có .NET 10; `dotnet-ef` **7.0.13** quá cũ; chưa có C# Dev Kit, MSSQL extension, Docker. Plan cũ giả định đã sẵn sàng. |
| M2 | Bỏ "deploy staging" ở tuần 12; thay bằng stretch task tùy chọn | Docker/VPS chỉ học ở tuần 19–21 → mâu thuẫn thứ tự. Deploy khi chưa có Docker sẽ làm đúng lúc MVP đang nặng nhất. |
| M3 | OpenAPI trên .NET 10: dùng `Microsoft.AspNetCore.OpenApi` (có sẵn) + Scalar hoặc Swagger UI | Từ .NET 9 template không còn Swashbuckle. Tutorial cũ sẽ hướng dẫn sai package. |
| M4 | Thêm 2 gotcha khi **API và MVC dùng chung cookie auth** (tuần 8 và 10): trả `401/403` thay vì redirect cho `/api/*`; antiforgery khi gọi API từ JavaScript | Đây là lỗi thực tế gần như ai cũng gặp khi đi con đường "MVC + API song song". |
| M5 | Chốt **chiến lược database cho test** (tuần 15, 20): local dùng DB `JobTrack_Test` trên SQL Server sẵn có qua biến môi trường; CI dùng SQL Server *service container* trên GitHub Actions | Plan cũ chỉ nói "container hoặc database riêng". Chỗ này thường là nơi CI bị kẹt lâu nhất. |

### Should change (đã áp dụng)

| # | Thay đổi | Lý do / trade-off |
|---|---|---|
| S1 | Tuần 7 **bắt đầu với 1 project Web + 2 project test** (có folder rõ), tách `Domain`/`Infrastructure` ở tuần 13 khi đã có code thật; `Application` chỉ tách nếu có nhu cầu | Đúng với nguyên tắc của chính plan: "chỉ thêm abstraction khi đã xuất hiện nhu cầu thật". Tách sớm khi nền tảng yếu → mất thời gian vào wiring thay vì học. Trade-off: repo tuần 7–12 trông "ít layer" hơn; bù lại tuần 13 có bài refactor có ý nghĩa để kể khi phỏng vấn. Kiến trúc đích **không đổi**. |
| S2 | Tuần 6 tập trung **EF Core + migration đầu tiên**; phần SQL sâu để track T-SQL song song gánh | Tuần 6 cũ gộp toàn bộ SQL lẫn EF Core là quá tải. |
| S3 | Chuyển 2–3 giờ **HTML/CSS/form căn bản vào tuần 5**; tuần 17–18 thành *polish + accessibility + tuần đệm* | Học "HTML căn bản" ở tuần 17 sau khi đã viết Razor view suốt 6 tuần là sai thứ tự. |
| S4 | Tailwind: dùng **standalone CLI** (không cần Node) hoặc giữ Bootstrap có sẵn của template | Máy không có Node; không nên cài cả toolchain Node chỉ để build CSS cho dự án backend. |
| S5 | Chốt cách **migration production**: chạy `Database.Migrate()` khi container khởi động (có log rõ) cho dự án một người; ghi lại trade-off so với `ef migrations bundle` | "Có quy trình rõ" chưa đủ cụ thể để làm. |
| S6 | Chốt **cách lưu enum** trong DB: chuỗi qua `HasConversion<string>()` + `CHECK` hoặc `int`; ghi vào `docs/decisions.md` | Quyết định nhỏ nhưng ảnh hưởng tới query T-SQL và report. |
| S7 | Gợi ý VPS cụ thể (Hetzner/Contabo x86-64 4 GB, ~€4–8/tháng); giải thích vì sao **phải x86-64** (image SQL Server chỉ có amd64) | Plan cũ nói x86-64 nhưng không nói lý do, dễ mua nhầm VPS ARM rẻ. |
| S8 | Bổ sung **tuần đệm** rõ ràng: tuần 12 (stretch tùy chọn) và tuần 18 | Phase 3 sáu tuần với auth + 4 feature + filter/dashboard là chặt; cần chỗ hấp thụ trễ mà không cắt scope lõi. |
| S9 | Thêm câu hỏi phỏng vấn thường gặp ở thị trường VN: 4 tính chất OOP, SOLID căn bản, value/reference type, LINQ deferred execution, SQL injection/parameterized query, CSRF/antiforgery | Bộ câu hỏi cũ thiên về dự án, thiếu phần "lý thuyết căn bản" mà vòng 1 hay hỏi. |

### Optional (ghi nhận, chưa bắt buộc)

| # | Gợi ý | Ghi chú |
|---|---|---|
| O1 | Windows 10 đã hết hỗ trợ chính thức từ 14/10/2025 (ESU tiêu dùng đến 13/10/2026). Máy i7-11800H đủ điều kiện Windows 11. | Không chặn kế hoạch. Cân nhắc nâng cấp trước khi cài Docker Desktop để tránh mất thời gian với build cũ. |
| O2 | Azure SQL Database có gói free (giới hạn vCore-giây/tháng) có thể thay SQL Server container trên VPS để tiết kiệm RAM | Chỉ cân nhắc ở tuần 21 nếu VPS 4 GB khó khăn; thêm một dịch vụ cloud = thêm thứ phải giải thích. |
| O3 | `Directory.Build.props` để bật `Nullable`, `ImplicitUsings`, `TreatWarningsAsErrors` cho mọi project | Làm ở tuần 7, rất rẻ. |
| O4 | `Testcontainers.MsSql` cho integration test | Chỉ sau khi có Docker Desktop (tuần 19). Trước đó dùng DB local là đủ. |

---

## 1. Mục tiêu cuối cùng

Sau kế hoạch này, tôi cần đạt được **hai kết quả song song**:

1. Có kiến thức đủ chắc để tự giải thích và sửa code C#/.NET Backend, không chỉ biết ghép code do AI tạo ra.
2. Có một sản phẩm thật đang chạy trên domain riêng để đưa vào CV và trình bày khi phỏng vấn.

### Sản phẩm cuối phải có

- Source code công khai trên GitHub, lịch sử commit rõ ràng.
- Website chạy được trên domain riêng qua HTTPS.
- Backend ASP.NET Core, database quan hệ và Entity Framework Core.
- Đăng ký, đăng nhập, phân quyền và bảo vệ dữ liệu theo từng tài khoản.
- CRUD, tìm kiếm, lọc, sắp xếp, phân trang và validation.
- REST API có tài liệu OpenAPI.
- Unit test và integration test cho các luồng quan trọng.
- Dockerfile, Docker Compose và quy trình deploy lên Linux VPS.
- GitHub Actions tự build và chạy test.
- README tốt, ảnh chụp, ERD, sơ đồ kiến trúc, tài khoản demo và hướng dẫn chạy local.
- Có thể tự demo 5–7 phút và trả lời được các quyết định kỹ thuật chính.

### Không lấy những thứ sau làm thước đo chính

- Số lượng package hoặc công nghệ được nhét vào dự án.
- Code dài, nhiều layer hoặc tên kiến trúc nghe "xịn".
- Phần trăm test coverage thật cao nhưng test không có ý nghĩa.
- Một giao diện quá cầu kỳ trong khi backend chưa ổn định.
- Dự án chạy được nhưng bản thân không giải thích được code.

---

## 2. Đề tài dự án: JobTrack

**JobTrack** là hệ thống giúp người dùng quản lý quá trình tìm việc: công ty, vị trí đã ứng tuyển, trạng thái hồ sơ, lịch phỏng vấn, ghi chú, tài liệu và lời nhắc.

Đề tài này phù hợp vì:

- Liên quan trực tiếp đến hoàn cảnh đang tìm việc nên dễ hiểu nghiệp vụ và có thể tự dùng hằng ngày.
- Không phải một trang Todo List quá đơn giản.
- Đủ nhỏ để một người hoàn thành, nhưng có nhiều đường mở rộng cho kiến thức backend.
- Có thể trình bày rõ giá trị sản phẩm với nhà tuyển dụng.
- Có dữ liệu quan hệ, xác thực, phân quyền, báo cáo, tác vụ nền, file và triển khai thực tế.

### 2.1. Người dùng mục tiêu

- `User`: quản lý dữ liệu xin việc của chính mình.
- `Admin`: chỉ thêm ở giai đoạn nâng cao để quản lý tài khoản và xem tình trạng hệ thống.

Mỗi người dùng chỉ được đọc và thay đổi dữ liệu thuộc tài khoản của họ. Đây là yêu cầu bảo mật cốt lõi, không phải tính năng phụ.

### 2.2. Các chức năng MVP

MVP là phiên bản nhỏ nhất đủ dùng và đủ để deploy lần đầu. Backlog chi tiết với acceptance criteria nằm ở `docs/backlog.md`.

- Đăng ký, đăng nhập, đăng xuất.
- Xem và cập nhật hồ sơ cá nhân.
- Quản lý công ty.
- Quản lý đơn ứng tuyển.
- Thay đổi trạng thái: `Saved`, `Applied`, `Interviewing`, `Offer`, `Rejected`, `Withdrawn`.
- Quản lý lịch phỏng vấn.
- Ghi chú cho từng đơn ứng tuyển.
- Tìm kiếm, lọc theo trạng thái/công ty/thời gian, sắp xếp và phân trang.
- Dashboard: tổng số đơn, số cuộc phỏng vấn, số offer và tỷ lệ theo trạng thái.
- Giao diện responsive cơ bản.

### 2.3. Chức năng nâng cao sau MVP

- Lưu lịch sử thay đổi trạng thái ứng tuyển.
- Nhắc lịch phỏng vấn bằng email với background service.
- Tải lên CV/cover letter và kiểm soát loại/kích thước file.
- Xuất dữ liệu CSV.
- Audit log cho những thay đổi quan trọng.
- Optimistic concurrency để tránh ghi đè dữ liệu cũ.
- Caching cho dashboard hoặc dữ liệu đọc nhiều.
- Rate limiting cho API.
- Health check cho web và database.
- JWT/refresh token chỉ khi làm thêm client tách rời hoặc mobile app.
- Admin dashboard cơ bản.

### 2.4. Phạm vi không làm trong phiên bản đầu

- Mạng xã hội, chat realtime, AI chấm CV.
- Microservices, Kubernetes, message broker và event sourcing.
- Thanh toán.
- Mobile app.
- Nhiều frontend framework cùng lúc.
- Tự viết hệ thống mã hóa mật khẩu hoặc authentication từ đầu.

Những phần này dễ làm dự án bị vỡ phạm vi và không giúp một Junior chứng minh nền tảng tốt hơn.

---

## 3. Công nghệ sử dụng

| Phần | Lựa chọn | Lý do |
|---|---|---|
| Runtime | .NET 10 LTS | Bản LTS hiện hành, hỗ trợ đến 14/11/2028. .NET 8 và 9 hết hỗ trợ tháng 11/2026 nên **không** bắt đầu dự án mới bằng .NET 9 dù máy đang có sẵn |
| Backend | ASP.NET Core MVC + REST API Controllers | Có web hoàn chỉnh nhưng vẫn học HTTP và API |
| ORM | Entity Framework Core 10 | Công nghệ dữ liệu phổ biến trong hệ sinh thái .NET |
| Database | SQL Server 2022 Developer (local, **đã có sẵn**) → SQL Server Express hoặc 2022/2025 container khi public demo | Máy đã cài SQL Server 2022 Developer + SSMS 20; dự án không cần tính năng riêng của 2025 |
| Authentication | ASP.NET Core Identity + cookie | An toàn và phù hợp với web cùng domain; chưa dùng JWT khi chưa cần |
| Frontend | Razor Views, HTML, CSS, JavaScript; Tailwind CSS **standalone CLI** (hoặc Bootstrap có sẵn của template nếu muốn giảm ma sát) | Giữ trọng tâm backend; không cài Node chỉ để build CSS |
| API docs | `Microsoft.AspNetCore.OpenApi` (có sẵn trong .NET 10) + Scalar UI hoặc `Swashbuckle.AspNetCore.SwaggerUI` | Đúng với template .NET 9/10; Swashbuckle full không còn là mặc định |
| Testing | xUnit + `WebApplicationFactory` | Học unit test và test request thật |
| Logging | `ILogger` trước, structured logging sau | Học nền tảng trước khi thêm package |
| Container | Docker + Docker Compose | Chạy web, database và reverse proxy nhất quán |
| CI | GitHub Actions | Tự động restore, build và test; SQL Server service container cho integration test |
| Production | Ubuntu VPS **x86-64** (từ 4 GB RAM) + Caddy + domain + HTTPS | Image SQL Server chỉ có bản amd64; container cần tối thiểu 2 GB RAM |

### 3.1. Trạng thái máy tại 14/09/2026 (kiểm tra thực tế)

| Hạng mục | Trạng thái | Việc cần làm |
|---|---|---|
| .NET SDK | 8.0.131, 9.0.200, 9.0.310 → **đã cài 10.0.401** (14/09), `global.json` ghim 10.x | Xong |
| `dotnet-ef` global tool | 7.0.13 → **đã cập nhật 10.0.12** (14/09) | Xong |
| SQL Server | **2022 Developer (16.0.1200.5)**, instance mặc định `localhost`, Windows Authentication OK; còn instance `LETUANANH` | Dùng `localhost`. Không cài thêm. Tạo login riêng cho app ở tuần 15 |
| SSMS | SSMS 20 ✅ | — |
| `sqlcmd` | 16.0 (ODBC 17) ✅ | Dùng để chạy file `.sql`: `sqlcmd -S localhost -E -i file.sql` |
| VS Code | 1.135 ✅; **đã cài** C# 2.140, C# Dev Kit 3.20, MSSQL 1.45 (14/09) | Xong. Extension `humao.rest-client` đã có → dùng file `.http` |
| Git | 2.51.1 ✅, user `LeTuanAnh` | `git init` đã làm; cần tạo remote GitHub |
| GitHub CLI (`gh`) | Chưa có | Tùy chọn; có thể tạo repo/issue bằng web |
| Docker Desktop | **Chưa cài**; WSL2 bật nhưng chưa có distro; hypervisor OK; 16 GB RAM | Cài ở tuần 19 (hoặc stretch tuần 12). Docker Desktop tự cài distro WSL riêng |
| Node.js | Không có | Không cần; Tailwind dùng standalone CLI |
| Hệ điều hành | Windows 10 Home 22H2 (19045) — hết hỗ trợ chính thức | Không chặn; cân nhắc Windows 11 (xem O1) |

Chi tiết lệnh cài và kiểm tra: `docs/setup.md`.

### Quyết định về SQL Server và MySQL

- **Database chính của JobTrack là SQL Server.** EF Core dùng provider chính thức `Microsoft.EntityFrameworkCore.SqlServer`.
- Máy đã có SQL Server 2022 và SSMS → dùng luôn; dự án không cần tính năng riêng của SQL Server 2025.
- Local/học tập: Developer Edition (đã có). Developer miễn phí nhưng chỉ dành cho development và testing.
- Public demo: dùng SQL Server Express (container `mcr.microsoft.com/mssql/server` với `MSSQL_PID=Express`) hoặc edition có license phù hợp; không dùng Developer Edition cho production. Express có giới hạn RAM/dung lượng — kiểm tra docs của edition đang dùng trước khi deploy.
- SQL Server Linux container chính thức cần tối thiểu 2 GB RAM và **chỉ có image amd64**. Vì vậy VPS phải là x86-64, khoảng 4 GB RAM trở lên.
- MySQL vẫn là phương án thay thế nếu chi phí VPS là ưu tiên cao hơn. Nếu chọn MySQL, phải chọn ngay từ đầu; không đổi database vội vàng ở lúc deploy.
- Không hỗ trợ đồng thời SQL Server và MySQL trong phiên bản đầu.

### Lưu ý về công cụ trên máy hiện tại

- Visual Studio 2022 không hỗ trợ chính thức target `net10.0`. Dùng **VS Code + C# Dev Kit + .NET 10 SDK + Claude Code**.
- Có thể cài Visual Studio 2026 Community nếu muốn, không bắt buộc.
- SSMS 20 hoặc extension MSSQL trong VS Code để chạy và xem T-SQL.
- Git Bash, PowerShell hoặc terminal của VS Code; không cần WSL ngay trong tuần đầu.
- Chỉ học WSL/Linux command khi chuẩn bị Docker và deploy.

---

## 4. Kiến trúc dự kiến

Không bắt đầu bằng microservices. Dùng **modular monolith có phân lớp rõ**, một ứng dụng deploy duy nhất.

### 4.1. Hình dạng tuần 7 (bắt đầu) — thay đổi S1

```text
JobTrack/
├─ src/
│  └─ JobTrack.Web/
│     ├─ Domain/          # entity, enum, business rule thuần C#
│     ├─ Features/        # mỗi feature một folder: Companies/, Applications/, Interviews/, Notes/, Dashboard/
│     ├─ Data/            # DbContext, configuration, migrations
│     ├─ Controllers/     # MVC + API controllers (mỏng)
│     ├─ Views/
│     └─ wwwroot/
├─ tests/
│  ├─ JobTrack.UnitTests/
│  └─ JobTrack.IntegrationTests/
├─ database/              # T-SQL practice, schema tham chiếu, seed
├─ docs/
├─ Directory.Build.props  # Nullable, ImplicitUsings, warnings chung
├─ global.json            # ghim SDK 10.x
├─ docker-compose.yml     # tuần 19
├─ README.md
└─ JobTrack.sln
```

### 4.2. Hình dạng đích sau tuần 13 (refactor có mục đích)

```text
src/
├─ JobTrack.Domain/          # entity, enum, business rule; không phụ thuộc EF Core hay web
├─ JobTrack.Infrastructure/  # EF Core, Identity, email, file storage
├─ JobTrack.Application/     # CHỈ tách nếu số use case/service đủ nhiều; nếu không, giữ trong Web và ghi lý do vào docs/decisions.md
└─ JobTrack.Web/             # controller, view, API, middleware, DI
```

Khi tách, tự trả lời: *"Project mới này ngăn được lỗi gì hoặc giúp test gì dễ hơn?"* Nếu không trả lời được thì chưa tách.

### Trách nhiệm từng phần

- `Domain`: entity, enum, business rule thuần C#; không phụ thuộc EF Core hay web.
- `Application` (nếu có): use case/service, DTO, interface và validation nghiệp vụ.
- `Infrastructure`: EF Core, database, Identity, email, file storage và triển khai interface.
- `Web`: controller, Razor View, API endpoint, middleware, dependency injection và cấu hình.
- `UnitTests`: kiểm tra business rule nhanh, không dùng database thật.
- `IntegrationTests`: chạy request qua test server và kiểm tra tích hợp web/database.

### Nguyên tắc kiến trúc

- Không tạo repository generic chỉ để bọc lại toàn bộ `DbSet`/`DbContext`.
- Controller mỏng: nhận request, gọi use case/service, trả response.
- Business rule không nằm rải rác trong View hoặc JavaScript.
- Entity database không được trả thẳng tùy tiện qua API; dùng request/response model khi cần.
- Chỉ thêm abstraction khi đã xuất hiện nhu cầu thật và có thể giải thích lợi ích.
- Mỗi thay đổi database phải đi qua migration có tên rõ ràng.

---

## 5. Mô hình dữ liệu ban đầu

| Bảng | Dữ liệu chính | Quan hệ/ghi chú |
|---|---|---|
| `Users` | Id, Email, DisplayName, CreatedAt | Dùng ASP.NET Core Identity |
| `Companies` | Id, UserId, Name, Website, Location | Thuộc một User |
| `JobApplications` | Id, UserId, CompanyId, Position, Status, AppliedAt, JobUrl, SalaryRange | Bảng trung tâm |
| `Interviews` | Id, JobApplicationId, ScheduledAt, Type, LocationOrLink, Result | Một đơn có nhiều vòng |
| `Notes` | Id, JobApplicationId, Content, CreatedAt, UpdatedAt | Ghi chú theo đơn |
| `ApplicationStatusHistories` | Id, JobApplicationId, FromStatus, ToStatus, ChangedAt | Thêm sau MVP |
| `Reminders` | Id, InterviewId, RemindAt, SentAt, Status | Thêm sau MVP |
| `Attachments` | Id, JobApplicationId, OriginalName, StoredName, ContentType, Size | Thêm sau MVP |

Quy tắc quan trọng:

- Mọi truy vấn `Company` và `JobApplication` phải giới hạn bằng `UserId` hiện tại.
- Không tin `UserId` do browser gửi lên; lấy user từ authentication context.
- Thời gian lưu trong database bằng UTC (`datetime2`), chỉ đổi múi giờ khi hiển thị.
- Trạng thái phải được kiểm tra chuyển đổi hợp lệ trong backend.
- Xóa công ty đang có đơn ứng tuyển phải có quy tắc rõ: chặn xóa hoặc soft delete, không để hành vi ngẫu nhiên.
- **Enum `Status` lưu dạng chuỗi** (`nvarchar(20)` + `CHECK`) qua `HasConversion<string>()` để T-SQL/report đọc được ngay; đổi sang `int` chỉ khi có lý do hiệu năng đo được. (S6, ghi ở `docs/decisions.md`)
- Sau MVP: cột `RowVersion` (`rowversion`) trên `JobApplications` cho optimistic concurrency.

---

## 6. Cách chia thời gian mỗi tuần

Mức chuẩn: **12–15 giờ/tuần**.

| Hoạt động | Tỷ lệ | Ví dụ với 14 giờ |
|---|---:|---:|
| Xây chức năng dự án | 55% | 7.5 giờ |
| Học có bài tập ngoài dự án | 25% | 3.5 giờ |
| Test, debug và refactor | 10% | 1.5 giờ |
| Viết note, README, commit và ôn phỏng vấn | 10% | 1.5 giờ |

Lịch mẫu:

- Thứ 2: học khái niệm + làm bài tập nhỏ.
- Thứ 3: thiết kế một phần nhỏ của feature.
- Thứ 4–5: code feature.
- Thứ 6: test, debug, refactor.
- Thứ 7: hoàn thiện UI, tài liệu và push GitHub.
- Chủ nhật: nghỉ hoặc ôn lại 60 phút, không chạy theo feature mới.

Nếu chỉ có 8 giờ/tuần, giữ nguyên thứ tự và kéo kế hoạch thành khoảng 32 tuần. Không cắt testing, Git hoặc deploy.

### Tuần đệm (S8)

- **Tuần 12**: phần "stretch" là tùy chọn. Nếu MVP trễ, dùng trọn tuần 12 để hoàn thành MVP.
- **Tuần 18**: chỉ có polish UI; nếu tuần 13–17 trễ, tuần 18 là tuần bù.
- Trễ ≤ 1 tuần: dùng tuần đệm, không cắt scope. Trễ > 1 tuần: cắt tính năng nâng cao (§7 giai đoạn 7) trước, không cắt auth/ownership/test lõi/deploy/README.

### Lộ trình ôn SQL/T-SQL song song

Dành khoảng **2–3 giờ mỗi tuần từ tuần 2 đến tuần 16** cho SQL thuần. Mục đích là hiểu database trước khi để EF Core viết SQL thay mình.

Folder trong repository (đã tạo):

```text
database/
├─ schema/          # DDL tham chiếu do chính mình viết (tuần 4–7)
├─ seed/            # practice-sample.sql: DB mẫu JobTrackSample cho tuần 2–3
└─ sql-practice/
   ├─ 01-select-filter.sql
   ├─ 02-ddl-dml.sql
   ├─ 03-joins.sql
   ├─ 04-grouping-subqueries.sql
   ├─ 05-transactions.sql
   └─ 06-indexes-performance.sql
```

| Tuần | Chủ đề T-SQL | Bài thực hành bắt buộc |
|---|---|---|
| 2 | `SELECT`, alias, `DISTINCT`, `TOP` | 10 query đọc dữ liệu từ `JobTrackSample` |
| 3 | `WHERE`, `LIKE`, `IN`, `BETWEEN`, `IS NULL`, `ORDER BY` | 10 query lọc/sắp xếp, có ít nhất 3 trường hợp `NULL` |
| 4 | `CREATE TABLE`, data type, `INSERT`, `UPDATE`, `DELETE` | Tự tạo database `JobTrackPractice`, không dùng EF Core, không copy từ `JobTrackSample` |
| 5 | PK, FK, `UNIQUE`, `CHECK`, `DEFAULT`; `INNER/LEFT JOIN` | Thiết kế 4 bảng và viết 10 query join |
| 6 | Hàm tổng hợp, `GROUP BY`, `HAVING`, subquery và CTE | Viết báo cáo số đơn theo công ty/trạng thái/tháng |
| 7 | Chuẩn hóa 1NF–3NF và ERD | Tìm dữ liệu lặp trong schema nháp rồi sửa schema |
| 8 | ACID, transaction, commit/rollback | Mô phỏng một transaction thành công và một transaction rollback |
| 9 | Mapping EF Core và migration | Đối chiếu entity/configuration với table, key, constraint và index |
| 10 | LINQ → SQL, `IQueryable`, projection | Với 5 LINQ query, xem SQL sinh ra và viết T-SQL tương đương |
| 11 | Clustered/nonclustered index, execution plan, SARGability | So sánh execution plan trước/sau một index có lý do |
| 12 | View và stored procedure căn bản | Tạo 1 view báo cáo; stored procedure chỉ dùng khi có lý do rõ |
| 13 | Isolation level, blocking, deadlock, optimistic concurrency | Giải thích lost update và thử cập nhật cạnh tranh |
| 14 | Pagination và query performance | So sánh query dùng `OFFSET/FETCH`; không load toàn bảng |
| 15 | Security và vận hành | Tạo login/user cho app với quyền tối thiểu; không dùng `sa` trong connection string của app |
| 16 | Backup/restore và tổng ôn | Backup database, restore sang tên khác và làm bộ 20 query tổng hợp |

Quy tắc luyện SQL:

- Viết T-SQL trong file `.sql` và commit theo tuần; không chỉ bấm query rồi bỏ mất.
- Tự làm ít nhất 20 phút trước khi hỏi Claude.
- Sau mỗi LINQ query quan trọng, xem SQL do EF Core sinh ra và dự đoán dữ liệu/index nó cần.
- Không dùng `SELECT *` trong query ứng dụng nếu chỉ cần vài cột.
- Không thêm index theo cảm tính: ghi rõ query nào cần index và kiểm tra execution plan.
- Đến cuối tuần 16 cần có ít nhất **60 query tự viết**, một schema hoàn chỉnh và một lần backup/restore thành công.

---

## 7. Lộ trình 24 tuần

## Giai đoạn 0 — Khảo sát và chuẩn bị (Tuần 1)

### Học

- SDK, runtime, project, solution, NuGet là gì.
- Terminal căn bản: `cd`, `dir`/`ls`, tạo folder, chạy lệnh.
- Git: working tree, staging, commit, branch, merge và `.gitignore`.
- Cách dùng debugger: breakpoint, step over, step into và xem biến.

### Làm

- [x] `git init`, `.gitignore`, `.editorconfig`, `.gitattributes` (14/09).
- [x] Cấu trúc folder `docs/`, `database/`, `exercises/`, `.github/` (14/09).
- [x] `README.md`, `CLAUDE.md`, `LEARNING_LOG.md`, `docs/backlog.md`, `docs/decisions.md`, `docs/setup.md` (14/09).
- [x] Cài .NET 10 SDK 10.0.401; `dotnet-ef` 10.0.12; C# Dev Kit + MSSQL extension; `global.json` ghim SDK 10 (14/09).
- [x] Kiểm tra: `dotnet --version` ra `10.0.401`, `dotnet ef --version` ra `10.0.12`; console app `net10.0` chạy được (14/09).
- [ ] `git add -A && git commit` lần đầu (tự làm — bài tập Git tuần 1).
- [ ] Tạo GitHub repository `jobtrack` public, `git remote add origin`, push lần đầu.
- [ ] `dotnet dev-certs https --trust` (cần trước tuần 5).
- [ ] Tạo GitHub Project/Kanban gồm `Backlog`, `Ready`, `In progress`, `Review`, `Done`; đưa story từ `docs/backlog.md` vào Issues (dùng template có sẵn).
- [ ] **Tự làm**: tạo, chạy và debug một Console App (`exercises/week1-hello`) — không nhờ AI.
- [ ] Ghi entry tuần 1 vào `LEARNING_LOG.md`.

### Hoàn thành khi

- Tạo, chạy và debug được một Console App không cần AI làm hộ.
- Biết commit một thay đổi nhỏ và xem `git diff`.
- Có backlog chỉ gồm các story của MVP trên GitHub.

---

## Giai đoạn 1 — C# nền tảng (Tuần 2–4)

Bài tập cụ thể và tiêu chí hoàn thành ở `exercises/README.md`.

### Tuần 2: Cú pháp và tư duy chương trình

Học:

- Biến, kiểu dữ liệu, toán tử, `if`, `switch`, vòng lặp, method.
- Input/output, parse dữ liệu và xử lý trường hợp nhập sai.
- Debugger và đọc stack trace.

Bài tập ngoài dự án:

- Máy tính console.
- Kiểm tra số nguyên tố.
- Thống kê số đơn ứng tuyển theo trạng thái từ một mảng dữ liệu mẫu.

### Tuần 3: OOP và mô hình nghiệp vụ

Học:

- Class, object, constructor, property, access modifier.
- Encapsulation, interface, inheritance và composition.
- `enum`, exception và nullable reference types.
- Phân biệt entity, value, service và DTO ở mức căn bản.
- Value type vs reference type; `record` vs `class` (S9).

Bài tập:

- Tạo `JobApplication`, `Company`, `Interview` bằng console.
- Viết rule không cho lịch phỏng vấn nằm trước ngày ứng tuyển.
- Viết rule chuyển trạng thái đơn hợp lệ.

### Tuần 4: Collections, LINQ và async

Học:

- Array, `List<T>`, `Dictionary<TKey,TValue>` và khi nào dùng loại nào.
- LINQ: `Where`, `Select`, `OrderBy`, `GroupBy`, `Any`, `FirstOrDefault`; **deferred execution** (S9).
- `async`/`await`, `Task`, I/O-bound và `CancellationToken`.
- Đọc/ghi JSON cơ bản.

Bài tập:

- Lọc đơn theo trạng thái.
- Nhóm và đếm đơn theo công ty.
- Đọc danh sách đơn từ JSON bất đồng bộ rồi xuất báo cáo.

### Hoàn thành giai đoạn khi

- Tự tạo được model và method nghiệp vụ nhỏ.
- Viết được LINQ mà không phải copy nguyên khối từ AI.
- Giải thích được vì sao async phù hợp với gọi database/network.
- Có tối thiểu 10 bài tập nhỏ đã commit.

---

## Giai đoạn 2 — Nền tảng Web, HTTP và SQL (Tuần 5–6)

### Tuần 5: Web, HTTP, REST API và HTML/form căn bản

Học:

- Client/server, DNS, domain, HTTP và HTTPS ở mức căn bản.
- Request/response, header, JSON và status code.
- `GET`, `POST`, `PUT`, `PATCH`, `DELETE`.
- Routing, controller, model binding, dependency injection và middleware.
- REST resource, validation và error response.
- **(S3) 2–3 giờ HTML semantic, `<form>`, `<input>`, `<label>`, `<table>`, CSS box model/flexbox căn bản** — đủ để viết Razor view ở tuần 7 mà không "mò".

Làm:

- Tạo một API thử nghiệm in-memory cho `JobApplications` (`exercises/week5-api`).
- Gọi API bằng file `.http` (extension REST Client đã có) hoặc Scalar UI.
- Trả đúng `200`, `201`, `204`, `400`, `404`.

### Tuần 6: EF Core và migration đầu tiên (S2)

Phần SQL sâu (JOIN, GROUP BY, index, transaction) do track T-SQL gánh ở tuần 5–8; tuần này tập trung để EF Core **không còn là hộp đen**:

- `DbContext`, `DbSet`, entity mapping; `IEntityTypeConfiguration<T>`.
- Provider `Microsoft.EntityFrameworkCore.SqlServer` và `UseSqlServer`.
- Migration: tạo, xem file migration sinh ra, đọc SQL của nó (`dotnet ef migrations script`).
- Change tracking, `AsNoTracking`, loading quan hệ, projection, query bất đồng bộ.
- Chọn data type đúng: `nvarchar(n)`, `decimal`, `datetime2`, `bit`; không dùng `nvarchar(max)` cho mọi chuỗi.
- N+1 query là gì và cách nhận ra trong log.

Làm:

- Vẽ ERD phiên bản 1 (`docs/erd.md` bằng Mermaid).
- Chuyển API thử nghiệm từ in-memory sang SQL Server (database `JobTrackPlayground`, connection string qua **user-secrets**, không commit).
- Tự viết T-SQL tương đương cho ít nhất 5 LINQ query.

### Hoàn thành giai đoạn khi

- Có API CRUD chạy với SQL Server local.
- Tự giải thích được request đi từ route đến database rồi trở về như thế nào.
- Biết xem SQL do EF Core sinh ra (logging hoặc `ToQueryString()`).
- Không lưu connection string thật vào Git.

---

## Giai đoạn 3 — Xây MVP theo vertical slice (Tuần 7–12)

Mỗi tuần hoàn thành một lát cắt từ giao diện → controller/use case → database → validation → test cơ bản, thay vì tạo hết entity rồi để đó.

### Tuần 7: Khởi tạo solution chính (S1, M3, O3)

- `global.json` ghim SDK 10.x; `Directory.Build.props` bật `Nullable`, `ImplicitUsings`.
- Tạo `JobTrack.sln`, `src/JobTrack.Web` (MVC), `tests/JobTrack.UnitTests`, `tests/JobTrack.IntegrationTests`. Chưa tách Domain/Infrastructure.
- Folder `Domain/`, `Features/`, `Data/` trong Web; dependency đi một chiều `Controllers → Features → Domain`.
- Cấu hình SQL Server, EF Core và migration đầu tiên (`InitialCreate`).
- Layout, navigation và CSS: Tailwind standalone CLI (script build trong README) **hoặc** Bootstrap của template — chọn một, ghi lý do vào `docs/decisions.md`.
- OpenAPI: `AddOpenApi()` + `MapOpenApi()` (có sẵn) + Scalar hoặc Swagger UI chỉ bật ở Development.
- Health endpoint đơn giản `/health`.

### Tuần 8: Authentication (M4)

- Tích hợp ASP.NET Core Identity (có thể scaffold từ `--auth Individual`; template mặc định dùng SQLite → đổi sang SQL Server ngay).
- Register, login, logout và validation.
- Cookie an toàn (`HttpOnly`, `Secure`, `SameSite=Lax`), authorization và bảo vệ route bằng `[Authorize]` mặc định (fallback policy).
- **Gotcha**: với path `/api/*`, cấu hình cookie event để trả `401`/`403` thay vì redirect sang trang login.
- Tạo user seed cho môi trường development.
- Test: user chưa đăng nhập không truy cập được trang riêng; API trả 401.

Không tự hash password, không log password/token và không commit secret.

### Tuần 9: Company feature

- Tạo, xem, sửa, xóa công ty.
- Server-side validation.
- Kiểm tra ownership ở mọi thao tác (query luôn có `Where(c => c.UserId == currentUserId)`).
- Giao diện form và danh sách responsive.
- Unit test business rule và integration test endpoint quan trọng.

### Tuần 10: Job Application feature (M4, S6)

- CRUD đơn ứng tuyển và liên kết công ty (chỉ được chọn công ty của chính mình).
- Status enum lưu dạng chuỗi, ngày ứng tuyển, URL tuyển dụng và khoảng lương.
- Chống overposting bằng request model.
- Xử lý `404`, validation error và duplicate hợp lý.
- Thêm API endpoint song song với UI cho resource chính.
- **Gotcha**: API dùng cookie auth thì request từ JavaScript phải gửi antiforgery token (hoặc API chỉ dùng cho Scalar/test, ghi rõ). Quyết định và ghi vào `docs/decisions.md`.

### Tuần 11: Interview và Notes

- Một đơn có nhiều vòng phỏng vấn.
- Rule ngày giờ phỏng vấn (không trước ngày ứng tuyển; UTC).
- CRUD ghi chú.
- Dùng JavaScript nhỏ cho modal hoặc confirm; không thêm framework frontend.
- Test quan hệ và quyền truy cập chéo giữa hai user.

### Tuần 12: Search, filter, pagination và dashboard (M2, S8)

- Search theo vị trí/công ty.
- Filter trạng thái và khoảng thời gian.
- Sorting và server-side pagination (`OFFSET/FETCH` qua `Skip/Take`).
- Dashboard query bằng projection/grouping, không load toàn bộ bảng vào memory.
- Responsive UI cho desktop và mobile.
- Seed/demo data cho tài khoản demo.
- **Stretch (tùy chọn, chỉ khi MVP đã xong)**: cài Docker Desktop và chạy thử SQL Server trong container để làm quen; **không** deploy.

### Hoàn thành MVP khi

- Một user mới có thể đăng ký và hoàn thành toàn bộ luồng sử dụng chính.
- User A tuyệt đối không xem/sửa dữ liệu User B bằng cách đổi URL hoặc request.
- Không có lỗi nghiêm trọng trong console/log.
- Có seed/demo data.
- Có ít nhất một test cho mỗi business rule chính và các luồng authorization quan trọng.
- README có hướng dẫn chạy local.

**Từ tuần 12 bắt đầu đưa dự án vào CV và ứng tuyển; không cần đợi đủ 24 tuần.** Ghi rõ là dự án đang tiếp tục phát triển nếu chưa hoàn tất giai đoạn nâng cao.

---

## Giai đoạn 4 — Chất lượng backend và testing (Tuần 13–16)

### Tuần 13: Refactor có mục đích (S1)

- Xem lại controller quá dài và logic bị lặp.
- **Tách `JobTrack.Domain` và `JobTrack.Infrastructure` thành project riêng** — lúc này đã có code thật để thấy lợi ích (Domain test không cần EF; Infrastructure không "rò" vào view). `Application` chỉ tách nếu service/use case đủ nhiều.
- Dùng DTO/request/response model rõ ràng.
- Chuẩn hóa error handling bằng `IExceptionHandler` + Problem Details.
- Thêm `CancellationToken` cho tác vụ I/O phù hợp.
- Xử lý warning thay vì tắt warning; cân nhắc `TreatWarningsAsErrors`.

### Tuần 14: Unit test

- Arrange–Act–Assert.
- Test happy path, boundary và invalid case.
- Mock chỉ dependency thật sự cần cô lập.
- Không test getter/setter hoặc framework.
- Ưu tiên rule chuyển status, lịch phỏng vấn và xử lý ownership.

### Tuần 15: Integration test (M5)

- `WebApplicationFactory` và test HTTP request hoàn chỉnh.
- Database test: **local** dùng DB `JobTrack_Test` trên SQL Server 2022 sẵn có, connection string qua biến môi trường `ConnectionStrings__JobTrackTest`; **CI** dùng SQL Server service container (tuần 20). Không dùng EF Core InMemory để kết luận hành vi quan hệ.
- Reset dữ liệu giữa các test (transaction rollback hoặc xóa bảng theo thứ tự FK); ghi rõ cách chọn.
- Test register/login, authorization, CRUD và validation.
- Kiểm tra status code và response body.
- Test tối thiểu một trường hợp user A truy cập resource của user B.

### Tuần 16: Logging, cấu hình và hiệu năng query

- `ILogger`, log level và structured message.
- `appsettings` theo environment và environment variables.
- Không log dữ liệu nhạy cảm.
- Phát hiện N+1, dùng projection và `AsNoTracking` cho read-only query.
- Thêm index dựa trên query thật, ví dụ `(UserId, Status)` và ngày ứng tuyển.
- Đo query trước/sau; không tuyên bố "tối ưu" nếu chưa đo.

### Hoàn thành giai đoạn khi

- `dotnet build` không lỗi và không còn warning do code của dự án.
- `dotnet test` chạy ổn định trên máy local.
- Luồng lỗi trả response nhất quán.
- Có thể giải thích unit test khác integration test ở đâu.

---

## Giai đoạn 5 — Polish giao diện và tuần đệm (Tuần 17–18) (S3, S8)

### Học ngoài dự án (phần chưa học ở tuần 5)

- Accessibility căn bản: label, focus, contrast, keyboard.
- CSS grid và responsive breakpoint.
- JavaScript: DOM, event, `fetch`, async/await — áp dụng cho 1–2 tương tác nhỏ.

### Áp dụng

- Chuẩn hóa màu, spacing, typography và component form/button/card.
- Loading, empty, validation, success và error states.
- Mobile navigation và bảng/danh sách dùng được trên màn hình nhỏ.
- Filter không gây rối, giữ query string khi chuyển trang.

### Hoàn thành khi

- Giao diện nhất quán và dùng tốt trên màn hình điện thoại.
- Không copy một template lớn mà không hiểu.
- Có thể tự giải thích DOM event và một request `fetch`.
- Lighthouse/accessibility không có lỗi nghiêm trọng dễ sửa.
- Nếu trễ từ giai đoạn trước: tuần 18 dùng để bù, UI chỉ cần "sạch và dùng được".

---

## Giai đoạn 6 — Docker, CI/CD và deploy thật (Tuần 19–21)

### Tuần 19: Docker local

Học:

- Image, container, volume, network và port.
- Dockerfile multi-stage.
- Docker Compose và environment variable.
- Sự khác nhau giữa build-time và runtime configuration.

Làm:

- Cài Docker Desktop (WSL2 backend; máy đủ điều kiện).
- Viết Dockerfile multi-stage cho web (build Tailwind CSS trong stage build nếu dùng Tailwind).
- Compose gồm `web` + `sqlserver` bằng image `mcr.microsoft.com/mssql/server:2022-latest` (`MSSQL_PID=Express` cho demo public).
- Named volume cho database.
- App kết nối bằng database user có quyền tối thiểu, không dùng `sa`.
- Health check và startup dependency (`depends_on` + `healthcheck`).
- **Migration (S5)**: app gọi `Database.Migrate()` khi khởi động, log rõ migration nào đã chạy. Ghi trade-off vs `dotnet ef migrations bundle` vào `docs/decisions.md`.
- Chạy được `docker compose up --build` từ máy mới theo README.

### Tuần 20: CI với GitHub Actions (M5)

- Trigger trên pull request và push vào `main`.
- Restore, build ở Release mode, unit test.
- Integration test với **SQL Server service container** (`services: sqlserver: image: mcr.microsoft.com/mssql/server:2022-latest`, health check bằng `sqlcmd`), connection string qua `env`.
- Không đưa secret vào workflow/file repo (SA password của container test không phải secret thật nhưng vẫn để trong `env` của job).
- Thêm branch protection nếu tài khoản hỗ trợ.
- Thêm CI badge vào README sau khi pipeline ổn định.

### Tuần 21: VPS, domain và HTTPS (S7)

Chỉ mua VPS khi ứng dụng đã chạy ổn bằng Docker local. Gợi ý: Hetzner hoặc Contabo, **x86-64**, 2 vCPU, 4 GB RAM, ~€4–8/tháng. Không mua gói ARM dù rẻ hơn vì image SQL Server không có bản ARM.

- Tạo user deploy riêng; không làm việc hằng ngày bằng root.
- SSH key, tắt password login nếu đã kiểm tra key hoạt động.
- Firewall chỉ mở SSH, HTTP và HTTPS.
- Trỏ DNS domain/subdomain về IP VPS.
- Caddy làm reverse proxy và cấp HTTPS tự động.
- Chạy app bằng Docker Compose production (`compose.prod.yml`).
- Secret nằm trong file `.env` trên server (chmod 600), không nằm trong Git.
- Migration production theo cách đã chốt ở tuần 19.
- Backup SQL Server ra file `.bak`, chép backup ra ngoài container và thử restore ít nhất một lần.
- Ghi lại runbook `docs/runbook.md`: deploy, xem log, restart, rollback và restore.

### Hoàn thành giai đoạn khi

- Truy cập được website bằng `https://<domain>`.
- Reboot VPS xong container tự chạy lại (`restart: unless-stopped`).
- Database không public port `1433` ra Internet.
- GitHub Actions build/test thành công.
- Biết xem log và rollback về image/version trước.
- Có backup thật và đã thử restore, không chỉ có câu lệnh chưa chạy.

---

## Giai đoạn 7 — Một số kỹ năng backend nâng cao (Tuần 22–23)

Chỉ chọn **hai hoặc ba** mục có giá trị nhất. Không cần làm tất cả.

### Ưu tiên 1: Background reminder

- `BackgroundService` kiểm tra lịch cần nhắc theo chu kỳ.
- Gửi email qua provider hoặc SMTP test (Mailpit trong compose khi dev).
- Idempotency: chạy lại không gửi trùng.
- Retry có giới hạn và log lỗi.
- Lưu `SentAt`/status để quan sát được.

### Ưu tiên 2: File upload an toàn

- Giới hạn dung lượng và allowlist loại file.
- Tên file lưu trữ do server tạo.
- Không dùng tên/path người dùng gửi để truy cập filesystem.
- Kiểm tra ownership khi tải xuống/xóa.
- Không commit file người dùng lên Git.

### Ưu tiên 3: Reliability và observability

- Health checks cho app/database (`AddHealthChecks().AddDbContextCheck`).
- Rate limiting cho endpoint nhạy cảm (login, register) bằng middleware có sẵn.
- Correlation/request ID trong log.
- Audit log cho thay đổi trạng thái.
- Optimistic concurrency với `rowversion` cho cập nhật đơn ứng tuyển.

### Các mục chỉ làm nếu còn thời gian

- Redis cache cho dashboard và chiến lược invalidation.
- JWT + refresh token cho API client tách rời.
- Playwright end-to-end test cho 1–2 luồng quan trọng.

### Hoàn thành khi

- Tính năng nâng cao giải quyết một vấn đề cụ thể.
- Có test hoặc cách kiểm chứng rõ.
- Có log/metric đủ để biết nó hoạt động hay thất bại.
- README giải thích trade-off và phần chưa làm.

---

## Giai đoạn 8 — Đóng gói portfolio và luyện phỏng vấn (Tuần 24)

### README phải có

1. JobTrack giải quyết vấn đề gì.
2. Link live demo và tài khoản demo không có quyền nguy hiểm.
3. Ảnh chụp/GIF ngắn của luồng chính.
4. Danh sách tính năng.
5. Stack và lý do chọn.
6. Sơ đồ kiến trúc và ERD.
7. Cách chạy local bằng Docker Compose.
8. Cách chạy test.
9. Biến môi trường cần thiết nhưng không chứa giá trị secret.
10. Các quyết định kỹ thuật/trade-off (link `docs/decisions.md`).
11. Giới hạn hiện tại và roadmap.

### Chuẩn bị demo 5–7 phút

- 30 giây: vấn đề và người dùng.
- 2 phút: register/login và luồng thêm đơn ứng tuyển.
- 1 phút: search/filter/dashboard.
- 1 phút: OpenAPI UI và một API request.
- 1 phút: test + GitHub Actions.
- 1 phút: Docker, domain/HTTPS và kiến trúc.
- 30 giây: khó khăn lớn nhất, cách debug và điều sẽ cải tiến.

### Câu hỏi phải tự trả lời được

Về dự án và .NET:

- Dependency injection là gì? Tại sao dùng? Scoped/Transient/Singleton khác nhau ở đâu?
- Middleware chạy ở đâu trong request pipeline?
- `async/await` giúp gì và khi nào không giúp?
- EF Core tracking và `AsNoTracking` khác nhau thế nào?
- Migration dùng để làm gì?
- `IEnumerable` và `IQueryable` khác nhau ở điểm nào quan trọng? LINQ deferred execution là gì?
- Authentication và authorization khác nhau thế nào?
- Cookie và JWT khác nhau ra sao? Vì sao dự án chọn cookie trước?
- CSRF là gì và antiforgery token của ASP.NET Core chống nó thế nào?
- Làm sao ngăn User A xem dữ liệu User B?
- Unit test và integration test khác nhau thế nào?
- Docker image khác container thế nào?
- Reverse proxy và HTTPS hoạt động ra sao ở mức tổng quan?
- Nếu production lỗi sau deploy, xem gì trước và rollback thế nào?
- Một bug khó đã gặp, cách tìm nguyên nhân và cách sửa.

Về C# và lý thuyết căn bản (S9):

- 4 tính chất OOP với ví dụ từ JobTrack.
- SOLID ở mức căn bản; chỉ ra một chỗ trong dự án áp dụng S hoặc D.
- Value type vs reference type; `struct` vs `class`; `record` dùng khi nào.
- `string` immutable nghĩa là gì; `StringBuilder` khi nào.
- `IDisposable`/`using` và vì sao `DbContext` cần dispose.
- Exception: khi nào throw, khi nào trả kết quả lỗi.

Về SQL:

- `INNER JOIN` và `LEFT JOIN` khác nhau thế nào?
- Primary key, foreign key, `UNIQUE` và index giải quyết những vấn đề gì?
- Clustered index và nonclustered index khác nhau ở mức căn bản ra sao?
- Transaction và ACID là gì? Khi nào cần rollback?
- Vì sao một query có thể chậm và execution plan giúp kiểm tra điều gì?
- SQL injection là gì; parameterized query/EF Core chống nó thế nào?
- Vì sao không nên dùng tài khoản `sa` trong connection string của ứng dụng?

---

## 8. Chương trình học ngoài dự án (miễn phí)

Không cần học hết mọi khóa rồi mới code. Mỗi chủ đề học vừa đủ, làm bài nhỏ, sau đó áp dụng ngay vào JobTrack.

### C# và .NET

- [Microsoft Learn – Get started with C#, Part 1](https://learn.microsoft.com/en-us/training/paths/get-started-c-sharp-part-1/)
- [Microsoft Learn – Build web apps with ASP.NET Core for beginners](https://learn.microsoft.com/en-us/training/paths/aspnet-core-web-app/)
- [Microsoft Learn – Create a Web API with ASP.NET Core controllers](https://learn.microsoft.com/en-us/training/modules/build-web-api-aspnet-core/)
- [C# documentation](https://learn.microsoft.com/en-us/dotnet/csharp/)
- [ASP.NET Core fundamentals](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/)
- [OpenAPI trong ASP.NET Core (Microsoft.AspNetCore.OpenApi)](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/openapi/aspnetcore-openapi?view=aspnetcore-10.0)
- [Scalar for .NET](https://guides.scalar.com/scalar/scalar-api-references/integrations/net-aspnetcore)

### Database và EF Core

- [EF Core – Getting Started](https://learn.microsoft.com/en-us/ef/core/get-started/overview/first-app)
- [Microsoft Learn – Query and modify data with Transact-SQL](https://learn.microsoft.com/en-us/training/paths/get-started-querying-with-transact-sql/)
- [EF Core provider chính thức cho SQL Server](https://learn.microsoft.com/en-us/ef/core/providers/sql-server/)
- [Chạy SQL Server Linux container bằng Docker](https://learn.microsoft.com/en-us/sql/linux/install-upgrade/quickstart-install-docker)
- [SQLBolt – bài tập SQL tương tác](https://sqlbolt.com/)
- [MSSQL extension cho VS Code](https://learn.microsoft.com/en-us/sql/tools/visual-studio-code-extensions/mssql/mssql-extension-visual-studio-code)

### Testing

- [Testing in .NET](https://learn.microsoft.com/en-us/dotnet/core/testing/)
- [Integration tests in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-10.0)
- [xUnit documentation](https://xunit.net/)
- [GitHub Actions – service containers](https://docs.github.com/en/actions/use-cases-and-examples/using-containerized-services/about-service-containers)

### Frontend

- [MDN – Learn web development](https://developer.mozilla.org/en-US/docs/Learn_web_development)
- [MDN – JavaScript core learning](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting)
- [Tailwind CSS – Standalone CLI](https://tailwindcss.com/blog/standalone-cli)

### Git, Docker và CI/CD

- [GitHub Skills](https://skills.github.com/)
- [Docker Get Started](https://docs.docker.com/get-started/)
- [Docker Desktop on Windows – requirements](https://docs.docker.com/desktop/setup/install/windows-install/)
- [Docker Compose quickstart](https://docs.docker.com/compose/gettingstarted/)
- [GitHub Actions – Build and test .NET](https://docs.github.com/en/actions/tutorials/build-and-test-code/net)
- [Caddy reverse proxy quick-start](https://caddyserver.com/docs/quick-starts/reverse-proxy)

### Security

- [ASP.NET Core Security](https://learn.microsoft.com/en-us/aspnet/core/security/)
- [Prevent CSRF in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/anti-request-forgery)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

### Quy tắc dùng tài liệu

- Ưu tiên tài liệu chính thức cho phiên bản đang dùng.
- Video chỉ là nguồn giải thích phụ; luôn đối chiếu với documentation.
- Không xem tutorial dài liên tục. Sau 30–45 phút phải có code/bài tập hoặc note của chính mình.
- Nếu tutorial dùng .NET cũ (đặc biệt Swashbuckle, `Startup.cs`, .NET 6/7), học khái niệm nhưng kiểm tra API/cấu hình trong docs .NET 10.

---

## 9. Cách sử dụng Claude Code mà vẫn thật sự tiến bộ

Claude Code là pair programmer/reviewer, không phải người làm đồ án thay tôi. Working agreement nằm ở `CLAUDE.md` tại root repo (Claude đọc file này mỗi phiên).

### Quy trình cho mỗi issue

1. Tự viết acceptance criteria và phác thảo luồng xử lý.
2. Tự thử tối thiểu 20–30 phút đối với phần phù hợp trình độ.
3. Nếu mắc, đưa lỗi, đoạn code liên quan và điều đã thử cho Claude.
4. Yêu cầu Claude giải thích nguyên nhân hoặc đưa gợi ý nhỏ trước.
5. Khi Claude sửa code, xem toàn bộ diff; không bấm chấp nhận mù quáng.
6. Chạy build/test và tự test luồng bằng browser/API client.
7. Tự giải thích lại code bằng lời hoặc ghi vào `LEARNING_LOG.md`.
8. Chỉ commit khi hiểu thay đổi và có thể mô tả commit trong một câu.

### Prompt tốt

```text
Tôi đang học ASP.NET Core và muốn tự làm phần này.
Đây là acceptance criteria: ...
Đây là code hiện tại: ...
Đây là lỗi: ...
Tôi đã thử: ...

Trước tiên hãy giải thích nguyên nhân và cho tôi 2–3 gợi ý theo thứ tự.
Chưa viết toàn bộ lời giải. Sau khi tôi thử lại, hãy review diff của tôi.
```

### Prompt không tốt

```text
Hãy làm toàn bộ website JobTrack production-ready cho tôi.
```

### Việc Claude được làm thay vs. việc tôi phải tự làm

| Claude làm thay được | Tôi phải tự làm |
|---|---|
| Scaffold file cấu hình, template, tài liệu khung | Viết business rule, controller, query đầu tiên của mỗi feature |
| Giải thích lỗi, gợi ý hướng sửa | Debug bằng breakpoint trước khi hỏi |
| Review diff, chỉ ra thiếu test/validation | Viết test cho rule mình vừa viết |
| Sinh dữ liệu mẫu, seed | Viết 60 query T-SQL của track SQL |
| Viết bản nháp README/runbook để tôi sửa | Trả lời checklist chống lệ thuộc AI cuối tuần |

### Kiểm tra chống lệ thuộc AI cuối mỗi tuần

Chọn ngẫu nhiên một feature đã làm và trả lời không nhìn code:

- Request bắt đầu và kết thúc ở đâu?
- Những class nào tham gia và vì sao?
- Query nào chạy xuống database?
- Validation và authorization nằm ở đâu?
- Nếu bỏ một dependency thì điều gì hỏng?
- Test nào chứng minh feature hoạt động?

Nếu không trả lời được, tuần tiếp theo chưa thêm công nghệ mới; quay lại đọc và viết lại phần chưa hiểu.

---

## 10. Git và quản lý công việc

### Issue nhỏ, rõ

Template issue có sẵn ở `.github/ISSUE_TEMPLATE/feature.md`. Ví dụ một issue tốt:

```text
Title: Create a job application

Acceptance criteria:
- Authenticated user can open the create form.
- Position and company are required.
- Applied date cannot be in the future.
- New application belongs to the current user.
- Success redirects to detail page.
- Invalid input shows validation messages.
- Another user cannot select my company.
```

### Branch và commit

- Branch: `feature/create-job-application`.
- Commit nhỏ: `feat: add job application validation`.
- Không dùng commit message `update`, `fix code`, `done`.
- Trước merge: xem diff, build, test, cập nhật docs nếu cần.
- Tự tạo pull request kể cả làm một mình để tập mô tả thay đổi và self-review (template ở `.github/pull_request_template.md`).

### Definition of Done cho mọi feature

- [ ] Acceptance criteria đạt.
- [ ] Authorization và validation đã kiểm tra.
- [ ] Không có secret hoặc file thừa trong Git.
- [ ] Build không lỗi.
- [ ] Test liên quan pass.
- [ ] Đã test manual happy path và ít nhất một invalid path.
- [ ] UI có loading/empty/error state nếu cần.
- [ ] Docs/OpenAPI cập nhật nếu contract đổi.
- [ ] Đã xem `git diff` và hiểu toàn bộ thay đổi.

---

## 11. Cách đánh giá tiến độ thật

Mỗi cuối tuần ghi vào `LEARNING_LOG.md` theo template có sẵn trong file.

### Các cổng kiểm tra

| Mốc | Cần chứng minh |
|---|---|
| Cuối tuần 1 | Toolchain .NET 10 chạy; repo trên GitHub; tự tạo/debug console app |
| Cuối tuần 4 | Viết và giải thích được model/rule bằng C# |
| Cuối tuần 6 | API CRUD + SQL Server chạy được; hiểu HTTP và T-SQL căn bản |
| Cuối tuần 12 | MVP có auth, ownership, CRUD, filter, dashboard; bắt đầu ứng tuyển |
| Cuối tuần 16 | Có 60 query T-SQL, biết đọc execution plan cơ bản, đã backup/restore; test chạy ổn |
| Cuối tuần 21 | Domain HTTPS, Docker, CI, SQL Server backup/restore và runbook hoạt động |
| Cuối tuần 24 | README hoàn chỉnh, demo 5–7 phút, trả lời được bộ câu hỏi §7 |

Nếu trễ tiến độ, cắt tính năng nâng cao trước. Không cắt authentication, ownership, testing cốt lõi, Docker/deploy hoặc README.

---

## 12. Kế hoạch ứng tuyển song song

Không chờ "giỏi rồi mới ứng tuyển".

### Tuần 1–6

- Làm CV một trang.
- Dọn GitHub profile và pin repository.
- Mỗi tuần đọc 10 tin tuyển Junior/Intern .NET, thống kê kỹ năng lặp lại (ghi vào `docs/job-market-notes.md`).
- Ôn C#, OOP, SQL và HTTP theo câu hỏi phỏng vấn căn bản (§7 giai đoạn 8).

### Tuần 7–12

- Bắt đầu ứng tuyển có chọn lọc ngay khi MVP đủ demo.
- Ghi link repo và mô tả "actively developed" nếu chưa deploy production.
- Mỗi tuần mock interview một lần, tự quay màn hình/giọng nói 10 phút.

### Tuần 13–24

- Thêm live URL, CI, test và Docker vào CV khi thật sự hoàn thành.
- Điều chỉnh backlog theo kỹ năng xuất hiện nhiều trong các job description mục tiêu.
- Không thêm công nghệ vào CV nếu chỉ cài package nhưng không giải thích được.

### Mẫu mô tả dự án trên CV sau khi hoàn thành

```text
JobTrack – Personal Job Application Management Platform
- Built and deployed a multi-user ASP.NET Core 10 application with SQL Server,
  EF Core, Identity, Razor/Tailwind, and documented REST APIs.
- Implemented ownership-based authorization, application/interview workflows,
  filtering, pagination, dashboard reporting, and automated reminders.
- Added unit/integration tests and GitHub Actions CI; containerized the application
  with Docker Compose and deployed it behind HTTPS on a Linux VPS.
```

Chỉ giữ những gạch đầu dòng đúng với bản đã làm. Sau này có số đo thật như số test, thời gian phản hồi hoặc uptime thì mới bổ sung; không tự bịa metric.

---

## 13. Rủi ro và cách xử lý

| Rủi ro | Dấu hiệu | Cách xử lý |
|---|---|---|
| AI làm thay | Không giải thích được code vừa merge | Dừng feature mới, review lại diff và viết learning note |
| Học lan man | Nhiều khóa đang xem nhưng ít commit | Chỉ giữ một nguồn chính/chủ đề, áp dụng ngay vào issue |
| Overengineering | Thêm CQRS, microservice, Redis, 4 project trước khi có code thật | Đưa vào backlog nâng cao, quay lại vertical slice |
| Sa đà frontend | Mất nhiều ngày chọn màu/animation | Dùng design system nhỏ; ưu tiên luồng và backend |
| Sợ deploy | App chỉ chạy trên máy cá nhân | Docker local từ tuần 19 (stretch tuần 12), deploy ngay tuần 21 |
| Secret bị lộ | Key/connection string nằm trong repo | Rotate secret ngay, xóa khỏi history đúng cách, dùng user-secrets/env var |
| Bỏ cuộc vì trễ | Backlog tăng liên tục | Cắt scope nâng cao, dùng tuần đệm, giữ MVP và nhịp tuần |
| Tutorial cũ | Code/API không khớp phiên bản | Đối chiếu docs .NET 10 chính thức; đặc biệt OpenAPI và Identity |
| Toolchain lệch | `dotnet` chạy SDK 9 thay vì 10 | `global.json` ghim 10.x; kiểm tra `dotnet --version` trong repo |

---

## 14. Việc cần làm ngay trong 7 ngày đầu (cập nhật 14/09/2026)

- [x] Chốt tên `JobTrack`.
- [x] `git init`, `.gitignore`, `.editorconfig`, cấu trúc folder.
- [x] README 1 trang với problem, users, MVP và non-goals.
- [x] Backlog cho 6 feature MVP (`docs/backlog.md`); chưa thêm feature nâng cao.
- [x] `CLAUDE.md` từ mẫu, đã chỉnh theo máy thật.
- [x] `LEARNING_LOG.md` với entry tuần 1 (phần Shipped đã điền; phần Learned tự viết).
- [x] Cài .NET 10 SDK, cập nhật `dotnet-ef`, cài C# Dev Kit + MSSQL extension (`docs/setup.md`).
- [ ] Commit đầu tiên (tự làm), tạo GitHub repository public và push.
- [ ] Đưa backlog vào GitHub Issues/Project.
- [ ] Hoàn thành phần đầu của Microsoft Learn C#.
- [ ] Làm 3 console exercises (`exercises/README.md`) và tự giải thích code.
- [ ] Chỉ sau các bước trên mới scaffold solution web chính (tuần 7).

---

## 15. Prompt review hằng tuần với Claude

Dùng cuối mỗi tuần thay cho prompt review kế hoạch cũ:

```text
Đây là LEARNING_LOG.md tuần N và diff của tuần này (git log --oneline + git diff main~k).
Hãy review như một senior .NET mentor:
1. Chỉ ra chỗ tôi có thể đang lệ thuộc AI (code tôi khó giải thích).
2. Kiểm tra Definition of Done của từng issue đã đóng.
3. Hỏi tôi 3 câu về code tuần này mà tôi phải trả lời không nhìn code.
4. Đề xuất mục tiêu nhỏ nhất cho tuần sau, khớp với docs/plan.md.
Không viết code mới trong lần review này.
```

---

## 16. Nguồn kiểm tra phiên bản tại thời điểm lập plan

- [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core): .NET 10 là LTS, phát hành 11/11/2025 và được hỗ trợ đến 14/11/2028; .NET 8 và .NET 9 hết hỗ trợ trong tháng 11/2026.
- [.NET SDK, MSBuild, and Visual Studio versioning](https://learn.microsoft.com/en-us/dotnet/core/porting/versioning-sdk-msbuild-vs): target `net10.0` được hỗ trợ chính thức từ Visual Studio 2026 (18.0); VS Code + .NET CLI vẫn là lựa chọn phù hợp.
- [ASP.NET Core integration testing](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-10.0).
- [SQL Server downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads): Developer miễn phí cho development/testing; Express miễn phí cho ứng dụng nhỏ.
- [SQL Server editions](https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2025): Developer không được cấp phép làm production.
- [SQL Server Linux containers](https://learn.microsoft.com/en-us/sql/linux/install-upgrade/quickstart-install-docker): yêu cầu tối thiểu 2 GB RAM, image amd64, cần volume/backup để giữ dữ liệu.
- [Windows 10 end of support](https://www.microsoft.com/en-us/windows/end-of-support): hết hỗ trợ 14/10/2025.
- Trạng thái máy ở §3.1 được kiểm tra bằng `dotnet --info`, `sqlcmd`, `code --list-extensions`, `winget search` ngày 14/09/2026.

Phiên bản và dịch vụ cloud thay đổi theo thời gian. Trước khi bắt đầu deploy, kiểm tra lại tài liệu chính thức thay vì phụ thuộc hoàn toàn vào câu lệnh trong một video cũ.
