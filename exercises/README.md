# exercises/

Bài tập C# ngoài dự án cho tuần 1–6. **Tự code toàn bộ**; chỉ hỏi Claude khi đã thử ≥ 20 phút, và hỏi theo dạng "giải thích lỗi / gợi ý" chứ không "làm giúp". Mỗi bài là một console project riêng:

```bash
cd exercises
dotnet new console -n Week2.Calculator -o week2-calculator
cd week2-calculator && dotnet run
```

Commit mỗi bài khi chạy được và bạn giải thích được từng dòng. Không cần đẹp; cần đúng và hiểu.

## Tuần 1 — Làm quen công cụ

### W1.1 Hello + debug
- Tạo `week1-hello`, in ra tên và ngày hiện tại (`DateTime.Now`).
- Đặt breakpoint trong VS Code (C# Dev Kit), chạy F5, xem giá trị biến ở panel Variables, step over 2 dòng.
- Hoàn thành khi: tự tạo, chạy, debug được và commit với message `chore: add week1 hello exercise`.

## Tuần 2 — Cú pháp và tư duy chương trình

### W2.1 Máy tính console
- Đọc 2 số và một phép tính (`+ - * /`) từ `Console.ReadLine()`.
- Dùng `double.TryParse`; nhập sai thì báo lỗi và hỏi lại, không crash.
- Chia cho 0 phải được xử lý.
- Hoàn thành khi: chạy 5 trường hợp (kể cả nhập chữ) không crash.

### W2.2 Số nguyên tố
- Nhập `n`, in ra tất cả số nguyên tố ≤ n.
- Tách thành method `bool IsPrime(int x)`.
- Hoàn thành khi: giải thích được vì sao chỉ cần kiểm tra tới `sqrt(x)`.

### W2.3 Thống kê đơn theo trạng thái (mảng)
- Cho mảng `string[] statuses = { "Applied", "Rejected", "Applied", "Interviewing", ... }` (tự tạo ≥ 12 phần tử).
- Đếm số lần mỗi trạng thái bằng vòng lặp + `Dictionary<string,int>` (chưa dùng LINQ).
- In theo dạng `Applied: 5`.
- Hoàn thành khi: thêm một trạng thái mới vào mảng thì không phải sửa code đếm.

## Tuần 3 — OOP và mô hình nghiệp vụ

### W3.1 Model
- Tạo `Company`, `JobApplication`, `Interview` với property, constructor và `enum ApplicationStatus { Saved, Applied, Interviewing, Offer, Rejected, Withdrawn }`.
- `JobApplication` có `List<Interview> Interviews`.
- Bật `<Nullable>enable</Nullable>` và xử lý warning thay vì tắt.

### W3.2 Rule: interview không trước ngày ứng tuyển
- Method `AddInterview(DateTime scheduledAt, InterviewType type)` trên `JobApplication`.
- Nếu `scheduledAt < AppliedAt` → throw `ArgumentException` với message rõ.
- Hoàn thành khi: có `try/catch` trong `Program.cs` chứng minh rule hoạt động.

### W3.3 Rule: chuyển trạng thái hợp lệ
- Method `ChangeStatus(ApplicationStatus next)`; bảng chuyển hợp lệ xem `docs/backlog.md` story 3.5.
- Chuyển không hợp lệ → throw `InvalidOperationException`.
- Viết bảng chuyển bằng `switch` expression hoặc `Dictionary<ApplicationStatus, ApplicationStatus[]>` — thử cả hai, ghi nhận xét cái nào dễ đọc.
- Hoàn thành khi: giải thích được vì sao rule nằm trong entity chứ không trong `Program.cs`.

### W3.4 Phân biệt khái niệm (viết vào LEARNING_LOG)
- Entity vs DTO vs Service: mỗi thứ một câu, một ví dụ từ JobTrack.
- `class` vs `record` vs `struct`: khi nào dùng.

## Tuần 4 — Collections, LINQ, async

### W4.1 Lọc và nhóm
- Tạo `List<JobApplication>` ≥ 10 phần tử (dùng model tuần 3).
- `Where` đơn `Applied`; `GroupBy` công ty rồi `Count`; `OrderByDescending` AppliedAt; `FirstOrDefault` đơn có offer.
- Hoàn thành khi: viết lại một query LINQ bằng `foreach` để thấy LINQ làm gì; giải thích deferred execution với một ví dụ `Where` rồi thêm phần tử vào list sau đó.

### W4.2 JSON bất đồng bộ
- File `applications.json` (tự viết ≥ 5 đơn).
- `await File.ReadAllTextAsync` + `JsonSerializer.Deserialize<List<JobApplicationDto>>`.
- In báo cáo số đơn theo trạng thái.
- Truyền `CancellationToken` từ `CancellationTokenSource` với timeout 5 giây.
- Hoàn thành khi: giải thích được vì sao `async` giúp với I/O nhưng không giúp với tính toán CPU.

### W4.3 (tùy chọn) Dictionary vs List
- Tìm đơn theo Id trong `List` (O(n)) và trong `Dictionary<int, JobApplication>` (O(1)); đo bằng `Stopwatch` với 100k phần tử.

## Tuần 5 — Web API in-memory

### W5.1 `week5-api`
- `dotnet new webapi --use-controllers -n Week5.Api -o week5-api`.
- `JobApplicationsController` với `GET /api/applications`, `GET /{id}`, `POST`, `PUT /{id}`, `DELETE /{id}`; dữ liệu trong `List` static.
- Trả đúng `200/201/204/400/404`; validation bằng data annotations.
- Gọi bằng file `week5-api/requests.http` (extension REST Client) — commit file này.
- Xem OpenAPI ở `/openapi/v1.json`; thêm Scalar UI.
- Hoàn thành khi: vẽ được bằng lời đường đi của một POST từ browser → routing → model binding → controller → response.

## Tuần 6 — EF Core

### W6.1 Chuyển `week5-api` sang SQL Server
- Thêm `Microsoft.EntityFrameworkCore.SqlServer` + `Design`; `AppDbContext`; connection string bằng `dotnet user-secrets`.
- Migration `InitialCreate`; đọc file migration và SQL của nó (`dotnet ef migrations script`).
- Bật logging để thấy SQL EF Core sinh ra; với 5 query LINQ, viết T-SQL tương đương vào `database/sql-practice/04-grouping-subqueries.sql` phần cuối.
- Hoàn thành khi: `AsNoTracking` vs tracking — chỉ ra một query nên dùng cái nào và vì sao.
