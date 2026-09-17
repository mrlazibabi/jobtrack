/*
    Tuần 11 — Clustered/nonclustered index, execution plan, SARGability
    Tuần 14 — Pagination (OFFSET/FETCH) và query performance
    Tuần 15 — Login/user quyền tối thiểu cho app
    Tuần 16 — Backup/restore
    Database: JobTrackPractice (hoặc DB thật JobTrack sau tuần 7)

    Cần nhiều dữ liệu để thấy khác biệt: sinh ~100k đơn bằng script ở F01.
*/

-- F01. Sinh dữ liệu lớn: 100 user x 1000 đơn (dùng CTE số hoặc vòng lặp). Ghi thời gian chạy.


-- F02. Bật SET STATISTICS IO, TIME ON. Chạy: SELECT ... WHERE UserId = 'U50' AND Status = 'Applied'.
--      Ghi logical reads và xem execution plan (Ctrl+M trong SSMS): Clustered Index Scan hay Index Seek?


-- F03. Tạo nonclustered index (UserId, Status) INCLUDE (Position, AppliedAt). Chạy lại F02. So sánh logical reads.
--      Giải thích: vì sao thứ tự cột trong index quan trọng; INCLUDE để làm gì.


-- F04. SARGability: so sánh WHERE YEAR(AppliedAt) = 2026 với WHERE AppliedAt >= '2026-01-01' AND AppliedAt < '2027-01-01'.
--      Cái nào dùng được index? Vì sao?


-- F05. LIKE 'Junior%' vs LIKE '%Junior%' — cái nào seek được?


-- F06. Pagination: trang 3, 20 dòng/trang, sắp theo AppliedAt DESC, Id DESC (ORDER BY ... OFFSET 40 ROWS FETCH NEXT 20 ROWS ONLY).
--      Vì sao cần cột Id làm tie-breaker? Thử bỏ đi và chạy 2 lần.


-- F07. So sánh OFFSET lớn (trang 4000) với keyset pagination (WHERE AppliedAt < @lastDate OR (AppliedAt = @lastDate AND Id < @lastId)). Ghi logical reads.


-- F08. Dashboard query (D07) trên 100k dòng: đo trước/sau khi có index. Không tuyên bố "nhanh hơn" nếu chưa có số.


-- ===== Tuần 15: security =====

-- F09. CREATE LOGIN jobtrack_app WITH PASSWORD = '<mật khẩu mạnh, KHÔNG commit>'; CREATE USER; GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo.
--      Không cấp db_owner. Thử chạy DROP TABLE bằng user này và ghi lại lỗi.


-- F10. Connection string cho app dùng login này. Vì sao không dùng sa? Vì sao migration cần quyền cao hơn và xử lý thế nào?


-- ===== Tuần 16: backup/restore =====

-- F11. BACKUP DATABASE JobTrackPractice TO DISK = '...\JobTrackPractice.bak' WITH INIT, COMPRESSION. Ghi kích thước file.


-- F12. RESTORE DATABASE JobTrackPractice_Restored FROM DISK = '...' WITH MOVE ... (đổi tên file .mdf/.ldf). Kiểm tra COUNT(*) khớp.


-- F13. Tổng ôn: 20 query tự chọn từ 01–06, mỗi query ghi 1 dòng "học được gì".

