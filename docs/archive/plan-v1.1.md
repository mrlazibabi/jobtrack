# Kế hoạch học và xây dựng dự án cá nhân .NET Backend để xin việc

> Phiên bản: 1.1 — SQL Server + lộ trình ôn T-SQL  
> Ngày lập: 14/09/2026  
> Thời lượng đề xuất: 24 tuần, khoảng 12–15 giờ/tuần  
> Đối tượng: Sinh viên mới tốt nghiệp, nền tảng C#/.NET còn yếu, định hướng Junior .NET Backend

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
- REST API có tài liệu OpenAPI/Swagger.
- Unit test và integration test cho các luồng quan trọng.
- Dockerfile, Docker Compose và quy trình deploy lên Linux VPS.
- GitHub Actions tự build và chạy test.
- README tốt, ảnh chụp, ERD, sơ đồ kiến trúc, tài khoản demo và hướng dẫn chạy local.
- Có thể tự demo 5–7 phút và trả lời được các quyết định kỹ thuật chính.

### Không lấy những thứ sau làm thước đo chính

- Số lượng package hoặc công nghệ được nhét vào dự án.
- Code dài, nhiều layer hoặc tên kiến trúc nghe “xịn”.
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

MVP là phiên bản nhỏ nhất đủ dùng và đủ để deploy lần đầu.

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
| Runtime | .NET 10 LTS | Bản LTS hiện hành, được hỗ trợ đến 14/11/2028 |
| Backend | ASP.NET Core MVC + REST API Controllers | Có web hoàn chỉnh nhưng vẫn học HTTP và API |
| ORM | Entity Framework Core 10 | Công nghệ dữ liệu phổ biến trong hệ sinh thái .NET |
| Database | SQL Server 2025 | Đúng với nền tảng đang học và phổ biến trong hệ sinh thái .NET; dùng Developer cho local/test và Express hoặc license phù hợp khi public demo |
| Authentication | ASP.NET Core Identity + cookie | An toàn và phù hợp với web cùng domain; chưa dùng JWT khi chưa cần |
| Frontend | Razor Views, HTML, CSS, JavaScript, Tailwind CSS | Giữ trọng tâm backend nhưng vẫn học đủ frontend căn bản |
| API docs | OpenAPI + Swagger UI | Dễ kiểm tra và giới thiệu API |
| Testing | xUnit + ASP.NET Core integration testing | Học unit test và test request thật |
| Logging | `ILogger` trước, structured logging sau | Học nền tảng trước khi thêm package |
| Container | Docker + Docker Compose | Chạy web, database và reverse proxy nhất quán |
| CI | GitHub Actions | Tự động restore, build và test |
| Production | Ubuntu VPS x86-64 (khuyến nghị từ 4 GB RAM) + Caddy + domain + HTTPS | Đủ tài nguyên thực tế hơn cho web và SQL Server container |

### Quyết định về SQL Server và MySQL

- **Database chính của JobTrack là SQL Server.** EF Core dùng provider chính thức `Microsoft.EntityFrameworkCore.SqlServer`.
- Nếu máy đã có SQL Server 2022 và SSMS thì có thể tiếp tục dùng; dự án không cần tính năng riêng của SQL Server 2025.
- Local/học tập: dùng SQL Server Developer hoặc Express. Developer miễn phí nhưng chỉ dành cho development và testing.
- Public demo: dùng SQL Server Express hoặc một edition có license production phù hợp; không dùng Developer Edition cho production.
- SQL Server Linux container chính thức cần tối thiểu 2 GB RAM. Khi chạy cả hệ điều hành, web, database và reverse proxy, nên dự trù VPS x86-64 khoảng 4 GB RAM trở lên.
- MySQL vẫn là phương án thay thế nếu chi phí VPS là ưu tiên cao hơn. Nếu chọn MySQL, phải chọn ngay từ đầu và dùng nó ở local, test lẫn production; không đổi database vội vàng chỉ ở lúc deploy.
- Không cố hỗ trợ đồng thời SQL Server và MySQL trong phiên bản đầu vì sẽ tăng code, test và lỗi provider-specific mà không làm portfolio mạnh hơn đáng kể.

### Lưu ý về công cụ trên máy hiện tại

- Visual Studio 2022 không hỗ trợ chính thức target `net10.0`.
- Dùng **VS Code + C# Dev Kit + .NET 10 SDK + Claude Code** là đường ít cản trở nhất trên Windows 10.
- Có thể cài Visual Studio 2026 Community nếu máy và hệ điều hành đáp ứng yêu cầu, nhưng không bắt buộc.
- Dùng SQL Server Management Studio (SSMS) hoặc extension MSSQL trong VS Code để chạy và xem T-SQL.
- Dùng Git Bash, PowerShell hoặc terminal của VS Code; không cần WSL ngay trong tuần đầu.
- Chỉ học WSL/Linux command khi chuẩn bị Docker và deploy.

---

## 4. Kiến trúc dự kiến

Không bắt đầu bằng microservices. Dùng **modular monolith có phân lớp rõ**, một ứng dụng deploy duy nhất.

```text
JobTrack/
├─ src/
│  ├─ JobTrack.Domain/
│  ├─ JobTrack.Application/
│  ├─ JobTrack.Infrastructure/
│  └─ JobTrack.Web/
├─ tests/
│  ├─ JobTrack.UnitTests/
│  └─ JobTrack.IntegrationTests/
├─ docs/
├─ docker-compose.yml
├─ README.md
└─ JobTrack.sln
```

### Trách nhiệm từng project

- `Domain`: entity, enum, business rule thuần C#; không phụ thuộc EF Core hay web.
- `Application`: use case/service, DTO, interface và validation nghiệp vụ.
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
- Thời gian lưu trong database bằng UTC, chỉ đổi múi giờ khi hiển thị.
- Trạng thái phải được kiểm tra chuyển đổi hợp lệ trong backend.
- Xóa công ty đang có đơn ứng tuyển phải có quy tắc rõ: chặn xóa hoặc soft delete, không để hành vi ngẫu nhiên.

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

### Lộ trình ôn SQL/T-SQL song song

Dành khoảng **2–3 giờ mỗi tuần từ tuần 2 đến tuần 16** cho SQL thuần. Mục đích là hiểu database trước khi để EF Core viết SQL thay mình.

Tạo folder sau trong repository:

```text
database/
├─ schema/
├─ seed/
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
| 2 | `SELECT`, alias, `DISTINCT`, `TOP` | 10 query đọc dữ liệu mẫu |
| 3 | `WHERE`, `LIKE`, `IN`, `BETWEEN`, `IS NULL`, `ORDER BY` | 10 query lọc/sắp xếp, có ít nhất 3 trường hợp `NULL` |
| 4 | `CREATE TABLE`, data type, `INSERT`, `UPDATE`, `DELETE` | Tự tạo database `JobTrackPractice`, không dùng EF Core |
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

- Cài .NET 10 SDK, VS Code, C# Dev Kit, Git, SQL Server Developer/Express, SSMS (hoặc MSSQL extension) và Docker Desktop.
- Kiểm tra: `dotnet --info`, `git --version`, `docker version`.
- Tạo GitHub repository `jobtrack` ở chế độ public.
- Tạo `README.md` ban đầu: vấn đề, người dùng, chức năng MVP và stack.
- Tạo GitHub Project/Kanban gồm `Backlog`, `Ready`, `In progress`, `Review`, `Done`.
- Tạo `LEARNING_LOG.md` để ghi điều đã học và lỗi đã tự sửa.

### Hoàn thành khi

- Tạo, chạy và debug được một Console App không cần AI làm hộ.
- Biết commit một thay đổi nhỏ và xem `git diff`.
- Có backlog chỉ gồm các story của MVP.

---

## Giai đoạn 1 — C# nền tảng (Tuần 2–4)

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

Bài tập:

- Tạo `JobApplication`, `Company`, `Interview` bằng console.
- Viết rule không cho lịch phỏng vấn nằm trước ngày ứng tuyển.
- Viết rule chuyển trạng thái đơn hợp lệ.

### Tuần 4: Collections, LINQ và async

Học:

- Array, `List<T>`, `Dictionary<TKey,TValue>` và khi nào dùng loại nào.
- LINQ: `Where`, `Select`, `OrderBy`, `GroupBy`, `Any`, `FirstOrDefault`.
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

### Tuần 5: Web và REST API

Học:

- Client/server, DNS, domain, HTTP và HTTPS ở mức căn bản.
- Request/response, header, JSON và status code.
- `GET`, `POST`, `PUT`, `PATCH`, `DELETE`.
- Routing, controller, model binding, dependency injection và middleware.
- REST resource, validation và error response.

Làm:

- Tạo một API thử nghiệm in-memory cho `JobApplications`.
- Gọi API bằng Swagger hoặc file `.http`.
- Trả đúng `200`, `201`, `204`, `400`, `404`.

### Tuần 6: SQL và EF Core

Học SQL trước khi dựa vào ORM:

- Ôn `CREATE TABLE`, `INSERT`, `SELECT`, `UPDATE`, `DELETE` bằng T-SQL.
- Chọn data type đúng: `nvarchar`, `decimal`, `date`/`datetime2`, `bit`; không dùng `nvarchar(max)` cho mọi chuỗi.
- Primary key, foreign key, `UNIQUE`, `CHECK`, `DEFAULT` và nullability.
- `JOIN`, `GROUP BY`, `HAVING`, subquery/CTE, index và transaction.
- Normalization căn bản, execution plan và N+1 query là gì.

Học EF Core:

- `DbContext`, `DbSet`, entity mapping.
- Provider `Microsoft.EntityFrameworkCore.SqlServer` và `UseSqlServer`.
- Migration, change tracking, `AsNoTracking`.
- Loading quan hệ, projection và query bất đồng bộ.

Làm:

- Vẽ ERD phiên bản 1.
- Tạo schema và seed data bằng T-SQL trước.
- Chuyển API thử nghiệm từ in-memory sang SQL Server.
- Tự viết T-SQL tương đương cho ít nhất 5 LINQ query ở tuần này và 10 query trước cuối tuần 12.

### Hoàn thành giai đoạn khi

- Có API CRUD chạy với SQL Server local.
- Tự giải thích được request đi từ route đến database rồi trở về như thế nào.
- Biết xem SQL do EF Core sinh ra.
- Không lưu connection string thật vào Git.

---

## Giai đoạn 3 — Xây MVP theo vertical slice (Tuần 7–12)

Mỗi tuần hoàn thành một lát cắt từ giao diện → controller/use case → database → validation → test cơ bản, thay vì tạo hết entity rồi để đó.

### Tuần 7: Khởi tạo solution chính

- Tạo cấu trúc `Domain`, `Application`, `Infrastructure`, `Web`, `UnitTests`, `IntegrationTests`.
- Cấu hình dependency đúng chiều.
- Cấu hình SQL Server, EF Core và migration đầu tiên.
- Tạo layout, navigation và Tailwind CSS.
- Thêm OpenAPI/Swagger và health endpoint đơn giản.

### Tuần 8: Authentication

- Tích hợp ASP.NET Core Identity.
- Register, login, logout và validation.
- Cookie an toàn, authorization và bảo vệ route.
- Tạo user seed cho môi trường development.
- Test: user chưa đăng nhập không truy cập được trang riêng.

Không tự hash password, không log password/token và không commit secret.

### Tuần 9: Company feature

- Tạo, xem, sửa, xóa công ty.
- Server-side validation.
- Kiểm tra ownership ở mọi thao tác.
- Giao diện form và danh sách responsive.
- Unit test business rule và integration test endpoint quan trọng.

### Tuần 10: Job Application feature

- CRUD đơn ứng tuyển và liên kết công ty.
- Status enum, ngày ứng tuyển, URL tuyển dụng và khoảng lương.
- Chống overposting bằng request model.
- Xử lý `404`, validation error và duplicate hợp lý.
- Thêm API endpoint song song với UI cho resource chính.

### Tuần 11: Interview và Notes

- Một đơn có nhiều vòng phỏng vấn.
- Rule ngày giờ phỏng vấn.
- CRUD ghi chú.
- Dùng JavaScript nhỏ cho modal hoặc confirm; không thêm framework frontend.
- Test quan hệ và quyền truy cập chéo giữa hai user.

### Tuần 12: Search, filter, pagination và dashboard

- Search theo vị trí/công ty.
- Filter trạng thái và khoảng thời gian.
- Sorting và server-side pagination.
- Dashboard query bằng projection/grouping, không load toàn bộ bảng vào memory.
- Responsive UI cho desktop và mobile.
- Deploy bản staging đầu tiên nếu có thể.

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

### Tuần 13: Refactor có mục đích

- Xem lại controller quá dài và logic bị lặp.
- Tách use case/service phù hợp.
- Dùng DTO/request/response model rõ ràng.
- Chuẩn hóa error handling bằng middleware/Problem Details.
- Thêm `CancellationToken` cho tác vụ I/O phù hợp.
- Bật nullable và xử lý warning thay vì tắt warning.

### Tuần 14: Unit test

- Arrange–Act–Assert.
- Test happy path, boundary và invalid case.
- Mock chỉ dependency thật sự cần cô lập.
- Không test getter/setter hoặc framework.
- Ưu tiên rule chuyển status, lịch phỏng vấn và xử lý ownership.

### Tuần 15: Integration test

- `WebApplicationFactory` và test HTTP request hoàn chỉnh.
- SQL Server test database tách biệt bằng container hoặc database riêng; không dùng EF Core InMemory để kết luận các hành vi quan hệ hoạt động đúng.
- Test register/login, authorization, CRUD và validation.
- Kiểm tra status code và response body.
- Test tối thiểu một trường hợp user A truy cập resource của user B.

### Tuần 16: Logging, cấu hình và hiệu năng query

- `ILogger`, log level và structured message.
- `appsettings` theo environment và environment variables.
- Không log dữ liệu nhạy cảm.
- Phát hiện N+1, dùng projection và `AsNoTracking` cho read-only query.
- Thêm index dựa trên query thật, ví dụ `(UserId, Status)` và ngày ứng tuyển.
- Đo query trước/sau; không tuyên bố “tối ưu” nếu chưa đo.

### Hoàn thành giai đoạn khi

- `dotnet build` không lỗi và không còn warning do code của dự án.
- `dotnet test` chạy ổn định trên máy local.
- Luồng lỗi trả response nhất quán.
- Có thể giải thích unit test khác integration test ở đâu.

---

## Giai đoạn 5 — Frontend căn bản và trải nghiệm sử dụng (Tuần 17–18)

### Học ngoài dự án

- HTML semantic, form và accessibility căn bản.
- CSS box model, flexbox, grid và responsive design.
- JavaScript: variable, function, array/object, DOM, event, `fetch`, async/await.
- Tailwind: utility class, responsive breakpoint, state và component reuse.

### Áp dụng

- Chuẩn hóa màu, spacing, typography và component form/button/card.
- Loading, empty, validation, success và error states.
- Mobile navigation và bảng/danh sách dùng được trên màn hình nhỏ.
- Filter không gây rối, giữ query string khi chuyển trang.
- Kiểm tra bàn phím, label, contrast cơ bản.

### Hoàn thành khi

- Giao diện nhất quán và dùng tốt trên màn hình điện thoại.
- Không copy một template lớn mà không hiểu.
- Có thể tự giải thích DOM event và một request `fetch`.
- Lighthouse/accessibility không có lỗi nghiêm trọng dễ sửa.

---

## Giai đoạn 6 — Docker, CI/CD và deploy thật (Tuần 19–21)

### Tuần 19: Docker local

Học:

- Image, container, volume, network và port.
- Dockerfile multi-stage.
- Docker Compose và environment variable.
- Sự khác nhau giữa build-time và runtime configuration.

Làm:

- Viết Dockerfile cho web.
- Compose gồm `web` + `sqlserver` bằng image SQL Server Linux chính thức.
- Dùng named volume cho database.
- Local/test có thể dùng Developer Edition; public demo dùng Express hoặc license phù hợp.
- App kết nối bằng database user có quyền tối thiểu, không dùng `sa` làm tài khoản chạy ứng dụng.
- Health check và startup dependency hợp lý.
- Chạy được `docker compose up --build` từ máy mới theo README.

### Tuần 20: CI với GitHub Actions

- Trigger trên pull request và push vào `main`.
- Restore, build ở Release mode và test.
- Không đưa secret vào workflow/file repo.
- Thêm branch protection nếu tài khoản hỗ trợ.
- Thêm CI badge vào README sau khi pipeline ổn định.

### Tuần 21: VPS, domain và HTTPS

Ưu tiên Ubuntu VPS x86-64 khoảng 4 GB RAM trở lên vì SQL Server container cần tối thiểu 2 GB RAM và web/OS cũng cần phần tài nguyên riêng. Chỉ mua VPS khi ứng dụng đã chạy ổn bằng Docker local.

- Tạo user deploy riêng; không làm việc hằng ngày bằng root.
- SSH key, tắt password login nếu đã kiểm tra key hoạt động.
- Firewall chỉ mở SSH, HTTP và HTTPS.
- Trỏ DNS domain/subdomain về IP VPS.
- Caddy làm reverse proxy và cấp HTTPS tự động.
- Chạy app bằng Docker Compose production.
- Secret nằm trong environment/server, không nằm trong Git.
- Migration production có quy trình rõ, không chạy tùy tiện.
- Backup SQL Server ra file `.bak`, chép backup ra ngoài container và thử restore ít nhất một lần.
- Ghi lại runbook: deploy, xem log, restart, rollback và restore.

### Hoàn thành giai đoạn khi

- Truy cập được website bằng `https://<domain>`.
- Reboot VPS xong container tự chạy lại.
- Database không public port `1433` ra Internet.
- GitHub Actions build/test thành công.
- Biết xem log và rollback về image/version trước.
- Có backup thật và đã thử restore, không chỉ có câu lệnh chưa chạy.

---

## Giai đoạn 7 — Một số kỹ năng backend nâng cao (Tuần 22–23)

Chỉ chọn **hai hoặc ba** mục có giá trị nhất. Không cần làm tất cả.

### Ưu tiên 1: Background reminder

- Background service kiểm tra lịch cần nhắc.
- Gửi email qua provider hoặc SMTP test.
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

- Health checks cho app/database.
- Rate limiting cho endpoint nhạy cảm.
- Correlation/request ID trong log.
- Audit log cho thay đổi trạng thái.
- Optimistic concurrency cho cập nhật đơn ứng tuyển.

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
10. Các quyết định kỹ thuật/trade-off.
11. Giới hạn hiện tại và roadmap.

### Chuẩn bị demo 5–7 phút

- 30 giây: vấn đề và người dùng.
- 2 phút: register/login và luồng thêm đơn ứng tuyển.
- 1 phút: search/filter/dashboard.
- 1 phút: Swagger và một API request.
- 1 phút: test + GitHub Actions.
- 1 phút: Docker, domain/HTTPS và kiến trúc.
- 30 giây: khó khăn lớn nhất, cách debug và điều sẽ cải tiến.

### Câu hỏi phải tự trả lời được

- Dependency injection là gì? Tại sao dùng?
- Middleware chạy ở đâu trong request pipeline?
- `async/await` giúp gì và khi nào không giúp?
- EF Core tracking và `AsNoTracking` khác nhau thế nào?
- Migration dùng để làm gì?
- `IEnumerable` và `IQueryable` khác nhau ở điểm nào quan trọng?
- `INNER JOIN` và `LEFT JOIN` khác nhau thế nào?
- Primary key, foreign key, `UNIQUE` và index giải quyết những vấn đề gì?
- Clustered index và nonclustered index khác nhau ở mức căn bản ra sao?
- Transaction và ACID là gì? Khi nào cần rollback?
- Vì sao một query có thể chậm và execution plan giúp kiểm tra điều gì?
- Vì sao không nên dùng tài khoản `sa` trong connection string của ứng dụng?
- Authentication và authorization khác nhau thế nào?
- Cookie và JWT khác nhau ra sao? Vì sao dự án chọn cookie trước?
- Làm sao ngăn User A xem dữ liệu User B?
- Unit test và integration test khác nhau thế nào?
- Docker image khác container thế nào?
- Reverse proxy và HTTPS hoạt động ra sao ở mức tổng quan?
- Nếu production lỗi sau deploy, xem gì trước và rollback thế nào?
- Một bug khó đã gặp, cách tìm nguyên nhân và cách sửa.

---

## 8. Chương trình học ngoài dự án (miễn phí)

Không cần học hết mọi khóa rồi mới code. Mỗi chủ đề học vừa đủ, làm bài nhỏ, sau đó áp dụng ngay vào JobTrack.

### C# và .NET

- [Microsoft Learn – Get started with C#, Part 1](https://learn.microsoft.com/en-us/training/paths/get-started-c-sharp-part-1/)
- [Microsoft Learn – Build web apps with ASP.NET Core for beginners](https://learn.microsoft.com/en-us/training/paths/aspnet-core-web-app/)
- [Microsoft Learn – Create a Web API with ASP.NET Core controllers](https://learn.microsoft.com/en-us/training/modules/build-web-api-aspnet-core/)
- [C# documentation](https://learn.microsoft.com/en-us/dotnet/csharp/)
- [ASP.NET Core fundamentals](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/)

### Database và EF Core

- [EF Core – Getting Started](https://learn.microsoft.com/en-us/ef/core/get-started/overview/first-app)
- [Microsoft Learn – Query and modify data with Transact-SQL](https://learn.microsoft.com/en-us/training/paths/get-started-querying-with-transact-sql/)
- [EF Core provider chính thức cho SQL Server](https://learn.microsoft.com/en-us/ef/core/providers/sql-server/)
- [Microsoft SQL Server samples và AdventureWorks](https://learn.microsoft.com/en-us/sql/samples/sql-samples-where-are)
- [Chạy SQL Server Linux container bằng Docker](https://learn.microsoft.com/en-us/sql/linux/install-upgrade/quickstart-install-docker?view=sql-server-ver17)
- [SQLBolt – bài tập SQL tương tác](https://sqlbolt.com/)

### Testing

- [Testing in .NET](https://learn.microsoft.com/en-us/dotnet/core/testing/)
- [Integration tests in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-10.0)
- [xUnit documentation](https://xunit.net/)

### Frontend

- [MDN – Learn web development](https://developer.mozilla.org/en-US/docs/Learn_web_development)
- [MDN – JavaScript core learning](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting)
- [Tailwind CSS documentation](https://tailwindcss.com/docs/installation/tailwind-cli)

### Git, Docker và CI/CD

- [GitHub Skills](https://skills.github.com/)
- [Docker Get Started](https://docs.docker.com/get-started/)
- [Docker Compose quickstart](https://docs.docker.com/compose/gettingstarted/)
- [GitHub Actions – Build and test .NET](https://docs.github.com/en/actions/tutorials/build-and-test-code/net)
- [Caddy reverse proxy quick-start](https://caddyserver.com/docs/quick-starts/reverse-proxy)

### Security

- [ASP.NET Core Security](https://learn.microsoft.com/en-us/aspnet/core/security/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

### Quy tắc dùng tài liệu

- Ưu tiên tài liệu chính thức cho phiên bản đang dùng.
- Video chỉ là nguồn giải thích phụ; luôn đối chiếu với documentation.
- Không xem tutorial dài liên tục. Sau 30–45 phút phải có code/bài tập hoặc note của chính mình.
- Nếu tutorial dùng .NET cũ, học khái niệm nhưng kiểm tra API/cấu hình trong docs .NET 10.

---

## 9. Cách sử dụng Claude Code mà vẫn thật sự tiến bộ

Claude Code là pair programmer/reviewer, không phải người làm đồ án thay tôi.

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

### Mẫu `CLAUDE.md` đặt ở root dự án

```markdown
# Working agreement

## Project goal
JobTrack is a learning-first portfolio project for a junior .NET backend developer.

## How to help
- Explain the relevant concept before making a non-trivial change.
- Work on one GitHub issue or one small vertical slice at a time.
- Prefer small, reviewable diffs.
- Ask before adding a new package, service, architectural layer, or major pattern.
- Do not implement unrelated improvements.
- After changes, list files changed, commands run, test results, and remaining risks.

## Code rules
- Target .NET 10 and enable nullable reference types.
- Use async APIs for database/network I/O and accept CancellationToken where appropriate.
- Keep controllers thin and business rules outside views/controllers.
- Never expose or log passwords, tokens, connection strings, or personal data.
- Never trust a UserId sent by the client; derive identity from the authenticated user.
- Use EF Core migrations for schema changes.
- Add or update meaningful tests for changed behavior.
- Do not hide warnings or weaken tests just to make the pipeline green.

## Learning rules
- When there are multiple valid approaches, explain the simplest option and its trade-off.
- Do not replace an entire file when a focused edit is enough.
- Mark generated assumptions clearly.
- If requirements are ambiguous, ask before coding.
```

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

Ví dụ một issue tốt:

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
- Tự tạo pull request kể cả làm một mình để tập mô tả thay đổi và self-review.

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

Mỗi cuối tuần ghi vào `LEARNING_LOG.md`:

```markdown
## Week N

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

### Next week's smallest goal
- ...
```

### Bốn cổng kiểm tra

| Mốc | Cần chứng minh |
|---|---|
| Cuối tuần 4 | Viết và giải thích được model/rule bằng C# |
| Cuối tuần 6 | API CRUD + SQL Server chạy được; hiểu HTTP và T-SQL căn bản |
| Cuối tuần 12 | MVP có auth, ownership, CRUD, filter, dashboard và deploy thử |
| Cuối tuần 16 | Có 60 query T-SQL, biết đọc execution plan cơ bản và đã backup/restore |
| Cuối tuần 21 | Domain HTTPS, Docker, CI, SQL Server backup/restore và runbook hoạt động |

Nếu trễ tiến độ, cắt tính năng nâng cao trước. Không cắt authentication, ownership, testing cốt lõi, Docker/deploy hoặc README.

---

## 12. Kế hoạch ứng tuyển song song

Không chờ “giỏi rồi mới ứng tuyển”.

### Tuần 1–6

- Làm CV một trang.
- Dọn GitHub profile và pin repository.
- Mỗi tuần đọc 10 tin tuyển Junior/Intern .NET, thống kê kỹ năng lặp lại.
- Ôn C#, OOP, SQL và HTTP theo câu hỏi phỏng vấn căn bản.

### Tuần 7–12

- Bắt đầu ứng tuyển có chọn lọc ngay khi MVP đủ demo.
- Ghi link repo và mô tả “actively developed” nếu chưa deploy production.
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
| Overengineering | Thêm CQRS, microservice, Redis trước MVP | Đưa vào backlog nâng cao, quay lại vertical slice |
| Sa đà frontend | Mất nhiều ngày chọn màu/animation | Dùng design system nhỏ; ưu tiên luồng và backend |
| Sợ deploy | App chỉ chạy trên máy cá nhân | Docker local từ tuần 19, deploy staging trước production |
| Secret bị lộ | Key/connection string nằm trong repo | Rotate secret ngay, xóa khỏi history đúng cách, dùng env var |
| Bỏ cuộc vì trễ | Backlog tăng liên tục | Cắt scope nâng cao, giữ MVP và nhịp tuần |
| Tutorial cũ | Code/API không khớp phiên bản | Đối chiếu docs .NET 10 chính thức |

---

## 14. Việc cần làm ngay trong 7 ngày đầu

- [ ] Chốt tên `JobTrack` hoặc một tên thay thế duy nhất.
- [ ] Cài/kiểm tra .NET 10 SDK, Git, VS Code, C# Dev Kit và Docker Desktop.
- [ ] Tạo GitHub repository public.
- [ ] Viết README 1 trang với problem, users, MVP và non-goals.
- [ ] Tạo backlog cho 6 feature MVP; chưa thêm feature nâng cao.
- [ ] Hoàn thành phần đầu của Microsoft Learn C#.
- [ ] Làm 3 console exercises và tự giải thích code.
- [ ] Thêm `CLAUDE.md` từ mẫu, chỉnh lại nếu cần.
- [ ] Tạo `LEARNING_LOG.md` và ghi entry tuần 1.
- [ ] Chỉ sau các bước trên mới scaffold solution web chính.

---

## 15. Prompt để nhờ Claude review kế hoạch này

```text
Tôi là sinh viên CNTT mới tốt nghiệp, định hướng Junior .NET Backend nhưng nền
tảng C#/.NET còn yếu. Tôi có khoảng 12–15 giờ mỗi tuần và muốn vừa học thật,
vừa hoàn thành một dự án có thể deploy và đưa lên CV. Database chính là SQL
Server và tôi muốn ôn T-SQL bài bản song song với EF Core. Tôi dùng Windows 10,
VS Code/C# Dev Kit và Claude Code.

Hãy review file plan.md này như một senior .NET mentor.

Yêu cầu:
1. Không viết lại toàn bộ ngay.
2. Chỉ ra những phần quá sức, thiếu kiến thức tiên quyết, phụ thuộc sai thứ tự,
   hoặc không tạo giá trị cho vị trí Junior .NET Backend.
3. Kiểm tra stack/phiên bản và tính khả thi của kế hoạch 24 tuần.
4. Ưu tiên giúp tôi hiểu và tự code; không đề xuất để AI làm trọn dự án.
5. Phân loại đề xuất thành Must change / Should change / Optional.
6. Với mỗi thay đổi, nói rõ lý do và trade-off.
7. Hỏi tối đa 5 câu thật sự cần thiết về thời gian, thiết bị và mục tiêu tuyển dụng.
8. Sau khi tôi trả lời, đề xuất một patch/diff cụ thể cho plan.md thay vì thay
   toàn bộ file.
```

---

## 16. Nguồn kiểm tra phiên bản tại thời điểm lập plan

- [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core): .NET 10 là LTS, phát hành 11/11/2025 và được hỗ trợ đến 14/11/2028; .NET 8 và .NET 9 hết hỗ trợ trong tháng 11/2026.
- [.NET SDK, MSBuild, and Visual Studio versioning](https://learn.microsoft.com/en-us/dotnet/core/porting/versioning-sdk-msbuild-vs): target `net10.0` được hỗ trợ chính thức từ Visual Studio 2026 (18.0); VS Code + .NET CLI vẫn là lựa chọn phù hợp.
- [ASP.NET Core integration testing](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-10.0): hướng dẫn test ứng dụng qua test host và `WebApplicationFactory`.
- [SQL Server downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads): Developer miễn phí cho development/testing; Express miễn phí và phù hợp với web/small server production.
- [SQL Server editions](https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2025): Developer không được cấp phép làm production; Express phù hợp cho học và ứng dụng server nhỏ.
- [SQL Server Linux containers](https://learn.microsoft.com/en-us/sql/linux/install-upgrade/quickstart-install-docker?view=sql-server-ver17): image SQL Server 2025 chính thức, yêu cầu tối thiểu 2 GB RAM và cần volume/backup để giữ dữ liệu.

Phiên bản và dịch vụ cloud thay đổi theo thời gian. Trước khi bắt đầu deploy, kiểm tra lại tài liệu chính thức thay vì phụ thuộc hoàn toàn vào câu lệnh trong một video cũ.
