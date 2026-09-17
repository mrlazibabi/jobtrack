# MVP backlog

Mỗi story dưới đây trở thành một GitHub Issue (template *Feature*). Thứ tự epic = thứ tự tuần trong `docs/plan.md`. Chỉ có story MVP; tính năng nâng cao nằm ở cuối, **chưa** tạo issue.

Quy ước: `AC` = acceptance criteria. Mỗi story phải kèm ít nhất một test (unit hoặc integration) chứng minh AC quan trọng nhất. Hãy chỉnh sửa AC theo hiểu biết của mình trước khi tạo issue — viết AC là kỹ năng cần luyện.

---

## Epic 0 — Project skeleton (Tuần 7)

### 0.1 Create solution and web project
- AC: `dotnet build` và `dotnet test` chạy thành công từ root.
- AC: `global.json` ghim SDK 10.x; `Directory.Build.props` bật nullable + implicit usings.
- AC: `src/JobTrack.Web` có folder `Domain/`, `Features/`, `Data/`.
- AC: `/health` trả `200`.

### 0.2 Configure EF Core + first migration
- AC: `JobTrackDbContext` kết nối SQL Server local qua user-secrets.
- AC: Migration `InitialCreate` tạo được database rỗng.
- AC: README ghi cách set connection string bằng `dotnet user-secrets`.

### 0.3 Layout and navigation
- AC: Layout chung có navbar (Dashboard, Applications, Companies, Account).
- AC: Responsive ở 375px và 1280px.
- AC: Chọn Tailwind standalone CLI hoặc Bootstrap; ghi vào `docs/decisions.md`.

### 0.4 OpenAPI document and UI
- AC: `/openapi/v1.json` có sẵn ở Development.
- AC: Scalar (hoặc Swagger UI) hiển thị document; tắt ở Production.

---

## Epic 1 — Authentication and account (Tuần 8)

### 1.1 Register
- AC: Form Email + Password + Confirm; validation server-side.
- AC: Email trùng → thông báo rõ, không lộ thông tin thừa.
- AC: Sau đăng ký chuyển tới Dashboard.
- Test: đăng ký thành công tạo user; email trùng trả lỗi.

### 1.2 Login / Logout
- AC: Đăng nhập sai → thông báo chung, không nói rõ email hay password sai.
- AC: Cookie `HttpOnly`, `Secure`, `SameSite=Lax`.
- AC: Logout là POST có antiforgery.
- Test: login đúng → 302 tới Dashboard; sai → ở lại form.

### 1.3 Protect routes by default
- AC: Fallback policy yêu cầu đăng nhập cho mọi route trừ Home/Login/Register.
- AC: Request tới `/api/*` khi chưa đăng nhập trả `401`, không redirect.
- Test: GET `/companies` chưa login → redirect login; GET `/api/companies` chưa login → 401.

### 1.4 Profile
- AC: Xem/sửa DisplayName; email chỉ đọc trong MVP.
- AC: Validation DisplayName 2–50 ký tự.

### 1.5 Development seed user
- AC: Ở Development, khởi động app tạo user demo nếu chưa có (thông tin trong README, không phải secret thật).

---

## Epic 2 — Companies (Tuần 9)

### 2.1 List my companies
- AC: Chỉ hiện công ty của user hiện tại.
- AC: Empty state có nút "Add company".
- Test: user A không thấy công ty của user B.

### 2.2 Create company
- AC: Name bắt buộc (2–100), Website là URL hợp lệ nếu có, Location tùy chọn.
- AC: Company mới gắn `UserId` từ user đăng nhập, không từ form.
- AC: Trùng tên trong cùng user → lỗi validation.
- Test: tạo thành công; trùng tên bị chặn.

### 2.3 Edit company
- AC: Chỉ chủ sở hữu sửa được; user khác nhận `404` (không phải `403`, để không lộ tồn tại).
- Test: user B PUT/POST vào company của A → 404.

### 2.4 Delete company
- AC: Nếu công ty còn đơn ứng tuyển → chặn xóa và thông báo số đơn đang gắn.
- AC: Xóa là POST có confirm.
- Test: xóa công ty có đơn → bị chặn; không có đơn → xóa được.

### 2.5 Company API
- AC: `GET/POST/PUT/DELETE /api/companies` dùng request/response model, không trả entity.
- AC: Status code đúng: 200/201/204/400/404.

---

## Epic 3 — Job applications (Tuần 10)

### 3.1 Create application
- AC: Position (bắt buộc), Company (chỉ chọn được công ty của mình), Status mặc định `Saved`, AppliedAt không ở tương lai, JobUrl là URL hợp lệ nếu có, SalaryRange tùy chọn.
- AC: Chống overposting: request model không có `UserId`/`Id`.
- Test: chọn company của user khác → validation error; AppliedAt tương lai → lỗi.

### 3.2 List applications
- AC: Bảng: Position, Company, Status (badge), AppliedAt, next interview.
- AC: Mặc định sắp xếp theo AppliedAt giảm dần.
- AC: Chỉ hiện đơn của user hiện tại.

### 3.3 Application detail
- AC: Hiện thông tin đơn, danh sách interview, notes.
- AC: User khác truy cập → 404.
- Test: cross-user detail → 404.

### 3.4 Edit application
- AC: Sửa được các trường như 3.1 với cùng validation.

### 3.5 Change status
- AC: Chuyển trạng thái hợp lệ theo bảng: `Saved→Applied`, `Applied→Interviewing/Rejected/Withdrawn`, `Interviewing→Offer/Rejected/Withdrawn`, `Offer→Withdrawn` (chấp nhận/không là quyết định sau MVP). Mọi chuyển khác bị từ chối.
- AC: Rule nằm trong Domain (method trên entity hoặc service), có unit test cho từng chuyển hợp lệ và ít nhất 3 chuyển không hợp lệ.
- Test: unit test bảng chuyển trạng thái.

### 3.6 Delete application
- AC: Xóa cascade interview + notes; POST có confirm.

### 3.7 Application API
- AC: `GET/POST/PUT/DELETE /api/applications`, `POST /api/applications/{id}/status`.
- AC: Quyết định antiforgery cho API cookie-auth ghi ở `docs/decisions.md`.

---

## Epic 4 — Interviews and notes (Tuần 11)

### 4.1 Add interview
- AC: ScheduledAt (UTC, không trước AppliedAt), Type (`Phone`, `Online`, `Onsite`, `Technical`, `HR`), LocationOrLink, Result (`Pending`, `Passed`, `Failed`).
- AC: Thêm interview khi đơn ở `Applied` tự chuyển sang `Interviewing` (ghi rõ trong UI).
- Test: interview trước AppliedAt bị chặn; auto-transition hoạt động.

### 4.2 Edit / delete interview
- AC: Chỉ chủ đơn; user khác → 404.

### 4.3 Notes CRUD
- AC: Content 1–2000 ký tự; hiển thị CreatedAt/UpdatedAt theo giờ địa phương.
- AC: Sắp xếp mới nhất trước.
- Test: cross-user note → 404.

### 4.4 Small JS for confirm/modal
- AC: Không thêm framework; JS thuần ≤ 100 dòng; form vẫn hoạt động nếu JS tắt.

---

## Epic 5 — Search, filter, pagination, dashboard (Tuần 12)

### 5.1 Search and filter
- AC: Search theo Position/Company (contains, không phân biệt hoa thường).
- AC: Filter Status (multi), Company, AppliedAt from/to.
- AC: Filter giữ trong query string; xóa filter một nút.

### 5.2 Sort and pagination
- AC: Sort theo AppliedAt, Company, Status; page size 10/20/50.
- AC: Server-side `Skip/Take`; có test kiểm tra SQL không load toàn bảng (xem `ToQueryString()`).

### 5.3 Dashboard
- AC: Tổng đơn, số interview sắp tới (7 ngày), số offer, breakdown theo status.
- AC: Query dùng `GroupBy` projection; không `ToList()` toàn bảng rồi đếm trong memory.

### 5.4 Demo data seed
- AC: Tài khoản demo với ~5 công ty, ~15 đơn, ~10 interview, ~10 note.
- AC: Chỉ chạy khi cấu hình `Seed:Demo=true`.

### 5.5 Responsive pass
- AC: Bảng đơn ứng tuyển dùng được ở 375px (card hoặc scroll ngang có chủ ý).

---

## Post-MVP (không tạo issue lúc này)

- Application status history.
- Interview reminder email (BackgroundService, idempotent).
- Attachments (CV/cover letter) với allowlist và ownership.
- CSV export.
- Audit log.
- Optimistic concurrency (`rowversion`).
- Dashboard caching.
- Rate limiting login/register.
- Health checks DB.
- Admin dashboard.
- JWT cho client tách rời.
