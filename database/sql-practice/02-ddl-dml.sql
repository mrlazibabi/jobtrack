/*
    Tuần 4 — CREATE TABLE, data type, INSERT, UPDATE, DELETE
    Database: JobTrackPractice  (TỰ TẠO, không copy từ practice-sample.sql)
    Chạy:     sqlcmd -S localhost -E -i database/sql-practice/02-ddl-dml.sql

    Mục tiêu: tự thiết kế bảng từ mô tả nghiệp vụ ở docs/plan.md §5, chọn data type có lý do.
    Khi xong, chép DDL cuối cùng sang database/schema/ (tuần 5–7 sẽ chỉnh tiếp).
*/

-- B01. Tạo database JobTrackPractice nếu chưa có (IF DB_ID(...) IS NULL).


-- B02. Tạo bảng Companies: Id, UserId, Name, Website, Location, CreatedAt.
--      Ghi comment cạnh mỗi cột: vì sao chọn data type và độ dài đó; cột nào NULL được, vì sao.


-- B03. Tạo bảng JobApplications: Id, UserId, CompanyId, Position, Status, AppliedAt, JobUrl, SalaryRange, CreatedAt.
--      Status: nvarchar(20) hay int? Đọc docs/decisions.md D-0004 rồi tự quyết định và ghi lý do.


-- B04. INSERT 3 công ty và 5 đơn ứng tuyển. Thử INSERT một dòng thiếu cột NOT NULL và ghi lại lỗi nhận được.


-- B05. UPDATE: đổi Status của một đơn từ 'Applied' sang 'Interviewing'. Chạy SELECT trước và sau để kiểm tra.
--      Thử UPDATE không có WHERE trong transaction rồi ROLLBACK — ghi lại điều gì xảy ra.


-- B06. DELETE một công ty đang có đơn ứng tuyển. Chuyện gì xảy ra nếu chưa có FK? Nếu có FK?


-- B07. ALTER TABLE thêm cột UpdatedAt datetime2 NULL vào JobApplications.


-- B08. DROP TABLE theo đúng thứ tự (bảng con trước) và tạo lại — hiểu vì sao thứ tự quan trọng.

