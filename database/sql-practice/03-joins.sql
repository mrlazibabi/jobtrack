/*
    Tuần 5 — PK, FK, UNIQUE, CHECK, DEFAULT; INNER JOIN, LEFT JOIN
    Database: JobTrackPractice (thêm Interviews, Notes vào schema của tuần 4)
*/

-- C01. Thêm FK Companies.UserId → Users, JobApplications.CompanyId → Companies. Thử INSERT CompanyId không tồn tại.


-- C02. Thêm UNIQUE (UserId, Name) cho Companies. Vì sao UNIQUE trên Name một mình là sai với hệ nhiều user?


-- C03. Thêm CHECK cho Status và DEFAULT SYSUTCDATETIME() cho CreatedAt.


-- C04. Tạo bảng Interviews và Notes với FK ON DELETE CASCADE. Khi nào CASCADE là hợp lý, khi nào nguy hiểm?


-- ===== 10 query join =====

-- C05. Position + tên công ty của mọi đơn (INNER JOIN).


-- C06. Tất cả công ty và số đơn của mỗi công ty, kể cả công ty chưa có đơn (LEFT JOIN + COUNT). So sánh với INNER JOIN.


-- C07. Đơn và interview gần nhất của nó (LEFT JOIN; đơn chưa có interview vẫn hiện).


-- C08. Interview kèm Position và tên công ty (join 3 bảng).


-- C09. Notes của user U1 (Notes → JobApplications → lọc UserId). Vì sao Notes không cần cột UserId riêng?


-- C10. Công ty KHÔNG có đơn nào (LEFT JOIN ... WHERE ... IS NULL). Viết lại bằng NOT EXISTS.


-- C11. Đơn có ít nhất 2 interview (JOIN + GROUP BY + HAVING).


-- C12. Đơn và số note của nó, kể cả 0 (LEFT JOIN + COUNT(n.Id) — vì sao COUNT(*) sai ở đây?).


-- C13. Interview của user U2 sắp diễn ra trong 30 ngày tới.


-- C14. Với mỗi công ty: số đơn, số đơn đang Interviewing, số offer (điều kiện trong SUM(CASE WHEN ...)).

