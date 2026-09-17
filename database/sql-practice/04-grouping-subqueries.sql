/*
    Tuần 6 — Hàm tổng hợp, GROUP BY, HAVING, subquery, CTE
    Tuần 7 — Chuẩn hóa 1NF–3NF và ERD (ghi nhận xét ở cuối file)
    Database: JobTrackPractice hoặc JobTrackSample
*/

-- D01. Số đơn theo Status.


-- D02. Số đơn theo công ty, chỉ công ty có >= 2 đơn (HAVING).


-- D03. Số đơn theo tháng nộp (YEAR/MONTH hoặc DATEFROMPARTS). Đơn AppliedAt NULL đi đâu?


-- D04. Tỷ lệ % đơn theo Status (subquery lấy tổng, hoặc window SUM() OVER()).


-- D05. Công ty có số đơn nhiều nhất (subquery hoặc TOP 1 WITH TIES).


-- D06. CTE: đơn có interview Passed gần nhất, kèm ngày.


-- D07. Với mỗi user: tổng đơn, số interview, số offer — đây là query Dashboard của app. Ghi rõ index nào có thể giúp.


-- D08. Đơn không có note nào (NOT EXISTS) — so với LEFT JOIN ... IS NULL, cái nào dễ đọc hơn?


-- D09. Thời gian trung bình (ngày) từ AppliedAt đến interview đầu tiên, theo công ty.


-- D10. Báo cáo: số đơn theo công ty x trạng thái (dạng ma trận, dùng SUM(CASE WHEN) hoặc PIVOT).


-- ===== Tuần 7: chuẩn hóa =====
-- Nhận xét (viết bằng lời, 5–10 dòng):
-- 1. Cột SalaryRange dạng 'x-yM' vi phạm 1NF không? Nếu tách MinSalary/MaxSalary thì được/mất gì?
-- 2. Nếu thêm cột CompanyName vào JobApplications để "query nhanh" thì vi phạm dạng chuẩn nào? Hậu quả?
-- 3. Interview.Type và Result: giữ CHECK constraint hay tách bảng lookup? Khi nào mỗi cách hợp lý?
-- 4. Vẽ ERD (Mermaid) vào docs/erd.md và ghi lại thay đổi so với bản tuần 4.

