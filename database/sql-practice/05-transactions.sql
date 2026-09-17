/*
    Tuần 8  — ACID, BEGIN TRAN / COMMIT / ROLLBACK, TRY...CATCH
    Tuần 13 — Isolation level, blocking, deadlock, optimistic concurrency (lost update)
    Database: JobTrackPractice
*/

-- E01. Transaction thành công: tạo công ty + 1 đơn ứng tuyển trong cùng transaction; COMMIT; kiểm tra.


-- E02. Transaction rollback: chèn đơn với CompanyId không tồn tại ở bước 2 -> toàn bộ ROLLBACK (TRY...CATCH + XACT_STATE()).


-- E03. Giải thích bằng comment: A, C, I, D — mỗi chữ ứng với điều gì trong E01/E02.


-- E04. Mở 2 cửa sổ SSMS. Cửa sổ 1: BEGIN TRAN; UPDATE một đơn; KHÔNG commit. Cửa sổ 2: SELECT đơn đó.
--      Ghi lại: cửa sổ 2 chờ (blocking) hay đọc được? Dùng sys.dm_exec_requests / sp_who2 để thấy blocking.


-- E05. Lặp lại E04 với SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ở cửa sổ 2. Đọc được gì? Vì sao nguy hiểm?


-- E06. Lost update: 2 cửa sổ cùng đọc Status='Applied', cửa sổ 1 đổi 'Interviewing', cửa sổ 2 đổi 'Withdrawn'.
--      Kết quả cuối là gì? Ai "thắng"? Vì sao app không thể phát hiện?


-- E07. Thêm cột RowVersion rowversion vào JobApplications. Viết UPDATE ... WHERE Id=@id AND RowVersion=@ver;
--      kiểm tra @@ROWCOUNT = 0 -> báo xung đột. Đây là điều EF Core làm với [Timestamp]/IsRowVersion().


-- E08. Mô phỏng deadlock đơn giản (2 transaction cập nhật 2 bảng theo thứ tự ngược nhau). Ghi lại thông báo lỗi 1205.

