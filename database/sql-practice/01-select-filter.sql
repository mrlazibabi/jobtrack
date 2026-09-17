/*
    Tuần 2–3 — SELECT, alias, DISTINCT, TOP, WHERE, LIKE, IN, BETWEEN, IS NULL, ORDER BY
    Database: JobTrackSample   (tạo bằng database/seed/practice-sample.sql)
    Chạy:     sqlcmd -S localhost -E -d JobTrackSample -i database/sql-practice/01-select-filter.sql
              hoặc mở bằng SSMS / MSSQL extension và chạy từng query.

    Quy tắc: tự viết ≥ 20 phút trước khi hỏi. Mỗi query ghi 1 dòng comment "kết quả mong đợi" trước khi chạy.
    Không dùng SELECT * trong bài nộp.
*/
USE JobTrackSample;
GO

-- ===== Tuần 2: đọc dữ liệu (10 query) =====

-- Q01. Liệt kê Position, Status, AppliedAt của tất cả đơn ứng tuyển.
-- Mong đợi: 16 dòng.


-- Q02. Liệt kê tên công ty và Website, đặt alias cột thành CompanyName, Site.


-- Q03. Các Status khác nhau đang có trong bảng JobApplications (DISTINCT).


-- Q04. 5 đơn ứng tuyển được tạo gần đây nhất (TOP + ORDER BY CreatedAt DESC).


-- Q05. Tất cả interview kiểu 'Technical'.


-- Q06. Ghép Position và Status thành một cột dạng "Position — Status" (dùng CONCAT hoặc +).


-- Q07. Đơn ứng tuyển của user 'U1' (cột UserId), chỉ lấy Position và CompanyId.


-- Q08. Số ngày kể từ AppliedAt đến hôm nay cho mỗi đơn (DATEDIFF, SYSUTCDATETIME()).


-- Q09. Interview có ScheduledAt sau ngày hôm nay (sắp diễn ra).


-- Q10. Notes có UpdatedAt khác NULL (đã từng sửa).


-- ===== Tuần 3: lọc và sắp xếp (10 query, ít nhất 3 query về NULL) =====

-- Q11. Đơn có Status 'Applied' hoặc 'Interviewing' (IN).


-- Q12. Đơn có Position chứa chữ '.NET' (LIKE).


-- Q13. Đơn nộp trong tháng 7/2026 (BETWEEN hoặc >= và <). Giải thích vì sao >= và < an toàn hơn BETWEEN với datetime.


-- Q14. Công ty không có Website (IS NULL) — KHÔNG dùng = NULL, giải thích vì sao.


-- Q15. Đơn chưa có ngày nộp (AppliedAt IS NULL) — những đơn này đang ở Status nào?


-- Q16. Interview chưa có Result (IS NULL) VÀ đã qua ngày hôm nay — có thể là dữ liệu quên cập nhật.


-- Q17. Đơn sắp xếp theo Status tăng dần rồi AppliedAt giảm dần; NULL AppliedAt xuất hiện ở đâu? (ORDER BY nhiều cột)


-- Q18. Đơn có SalaryRange bắt đầu bằng '1' (LIKE '1%') — chú ý đây là chuỗi, không phải số. Ghi nhận xét về việc lưu lương dạng nvarchar.


-- Q19. 3 công ty được tạo sớm nhất của user U2.


-- Q20. Đơn có JobUrl NULL hoặc rỗng — dùng COALESCE/NULLIF để xử lý cả 2 trường hợp.

