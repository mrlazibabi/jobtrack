/*
    JobTrackSample — database mẫu CHỈ ĐỂ LUYỆN SELECT ở tuần 2–3 của track T-SQL.

    Chạy:  sqlcmd -S localhost -E -i database/seed/practice-sample.sql
    Chạy lại được nhiều lần (script tự xóa và tạo lại database).

    Lưu ý:
    - Đây KHÔNG phải schema của ứng dụng. Tuần 4–5 bạn tự thiết kế JobTrackPractice từ đầu.
    - Cố tình có NULL (Website, SalaryRange, Result, JobUrl) để luyện IS NULL / LEFT JOIN.
    - Có 2 user (U1, U2) để thấy vì sao mọi query của app phải lọc theo UserId.
    - Thời gian lưu UTC (datetime2). Status lưu dạng chuỗi (xem docs/decisions.md D-0004).
*/

SET NOCOUNT ON;
GO

IF DB_ID(N'JobTrackSample') IS NOT NULL
BEGIN
    ALTER DATABASE JobTrackSample SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE JobTrackSample;
END;
GO

CREATE DATABASE JobTrackSample;
GO

USE JobTrackSample;
GO

CREATE TABLE dbo.Users
(
    Id          nvarchar(36)   NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
    Email       nvarchar(256)  NOT NULL CONSTRAINT UQ_Users_Email UNIQUE,
    DisplayName nvarchar(50)   NOT NULL,
    CreatedAt   datetime2(0)   NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT (SYSUTCDATETIME())
);

CREATE TABLE dbo.Companies
(
    Id        int            NOT NULL IDENTITY(1,1) CONSTRAINT PK_Companies PRIMARY KEY,
    UserId    nvarchar(36)   NOT NULL CONSTRAINT FK_Companies_Users REFERENCES dbo.Users(Id),
    Name      nvarchar(100)  NOT NULL,
    Website   nvarchar(200)  NULL,
    Location  nvarchar(100)  NULL,
    CreatedAt datetime2(0)   NOT NULL CONSTRAINT DF_Companies_CreatedAt DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT UQ_Companies_User_Name UNIQUE (UserId, Name)
);

CREATE TABLE dbo.JobApplications
(
    Id          int            NOT NULL IDENTITY(1,1) CONSTRAINT PK_JobApplications PRIMARY KEY,
    UserId      nvarchar(36)   NOT NULL CONSTRAINT FK_JobApplications_Users REFERENCES dbo.Users(Id),
    CompanyId   int            NOT NULL CONSTRAINT FK_JobApplications_Companies REFERENCES dbo.Companies(Id),
    Position    nvarchar(100)  NOT NULL,
    Status      nvarchar(20)   NOT NULL
        CONSTRAINT CK_JobApplications_Status CHECK (Status IN ('Saved','Applied','Interviewing','Offer','Rejected','Withdrawn')),
    AppliedAt   date           NULL,   -- NULL khi còn ở trạng thái Saved
    JobUrl      nvarchar(500)  NULL,
    SalaryRange nvarchar(50)   NULL,
    CreatedAt   datetime2(0)   NOT NULL CONSTRAINT DF_JobApplications_CreatedAt DEFAULT (SYSUTCDATETIME())
);

CREATE TABLE dbo.Interviews
(
    Id               int            NOT NULL IDENTITY(1,1) CONSTRAINT PK_Interviews PRIMARY KEY,
    JobApplicationId int            NOT NULL CONSTRAINT FK_Interviews_JobApplications REFERENCES dbo.JobApplications(Id) ON DELETE CASCADE,
    ScheduledAt      datetime2(0)   NOT NULL,
    Type             nvarchar(20)   NOT NULL
        CONSTRAINT CK_Interviews_Type CHECK (Type IN ('Phone','Online','Onsite','Technical','HR')),
    LocationOrLink   nvarchar(300)  NULL,
    Result           nvarchar(20)   NULL
        CONSTRAINT CK_Interviews_Result CHECK (Result IS NULL OR Result IN ('Pending','Passed','Failed'))
);

CREATE TABLE dbo.Notes
(
    Id               int            NOT NULL IDENTITY(1,1) CONSTRAINT PK_Notes PRIMARY KEY,
    JobApplicationId int            NOT NULL CONSTRAINT FK_Notes_JobApplications REFERENCES dbo.JobApplications(Id) ON DELETE CASCADE,
    Content          nvarchar(2000) NOT NULL,
    CreatedAt        datetime2(0)   NOT NULL CONSTRAINT DF_Notes_CreatedAt DEFAULT (SYSUTCDATETIME()),
    UpdatedAt        datetime2(0)   NULL
);
GO

-- ---------------------------------------------------------------------------
-- Users
-- ---------------------------------------------------------------------------
INSERT INTO dbo.Users (Id, Email, DisplayName, CreatedAt) VALUES
('U1', N'anh@example.com',  N'Tuấn Anh', '2026-06-01T08:00:00'),
('U2', N'linh@example.com', N'Linh',     '2026-07-15T09:30:00');

-- ---------------------------------------------------------------------------
-- Companies (U1 có 6, U2 có 3; một số Website/Location NULL)
-- ---------------------------------------------------------------------------
INSERT INTO dbo.Companies (UserId, Name, Website, Location, CreatedAt) VALUES
('U1', N'FPT Software',     N'https://fptsoftware.com', N'Hà Nội',       '2026-06-02T02:00:00'),
('U1', N'VNG',              N'https://vng.com.vn',      N'TP. Hồ Chí Minh','2026-06-02T02:05:00'),
('U1', N'KMS Technology',   N'https://kms-technology.com', N'TP. Hồ Chí Minh','2026-06-03T03:00:00'),
('U1', N'Nashtech',         NULL,                       N'Hà Nội',       '2026-06-10T04:00:00'),
('U1', N'Tiki',             N'https://tiki.vn',         NULL,            '2026-07-01T05:00:00'),
('U1', N'Startup ABC',      NULL,                       NULL,            '2026-08-20T06:00:00'),
('U2', N'FPT Software',     N'https://fptsoftware.com', N'Đà Nẵng',      '2026-07-16T02:00:00'),
('U2', N'MoMo',             N'https://momo.vn',         N'TP. Hồ Chí Minh','2026-07-16T02:10:00'),
('U2', N'Axon',             N'https://axon.com',        N'TP. Hồ Chí Minh','2026-08-01T02:00:00');

-- ---------------------------------------------------------------------------
-- JobApplications (U1: 12 đơn, U2: 4 đơn)
-- ---------------------------------------------------------------------------
INSERT INTO dbo.JobApplications (UserId, CompanyId, Position, Status, AppliedAt, JobUrl, SalaryRange, CreatedAt) VALUES
('U1', 1, N'Junior .NET Developer',        'Applied',      '2026-06-05', N'https://jobs.example.com/fpt-1',  N'10-14M',  '2026-06-05T02:00:00'),
('U1', 1, N'Fresher Backend (.NET)',       'Rejected',     '2026-06-20', N'https://jobs.example.com/fpt-2',  NULL,       '2026-06-20T02:00:00'),
('U1', 2, N'Backend Engineer (C#)',        'Interviewing', '2026-07-03', N'https://jobs.example.com/vng-1',  N'15-20M',  '2026-07-03T02:00:00'),
('U1', 3, N'Junior Software Engineer',     'Interviewing', '2026-07-10', NULL,                               N'12-16M',  '2026-07-10T02:00:00'),
('U1', 3, N'QA Automation (C#)',           'Withdrawn',    '2026-07-12', N'https://jobs.example.com/kms-2',  NULL,       '2026-07-12T02:00:00'),
('U1', 4, N'.NET Developer',               'Offer',        '2026-07-25', N'https://jobs.example.com/nash-1', N'14-18M',  '2026-07-25T02:00:00'),
('U1', 5, N'Backend Developer Intern',     'Rejected',     '2026-08-01', N'https://jobs.example.com/tiki-1', N'6-8M',    '2026-08-01T02:00:00'),
('U1', 5, N'Junior Backend (.NET/SQL)',    'Applied',      '2026-08-15', N'https://jobs.example.com/tiki-2', N'12-15M',  '2026-08-15T02:00:00'),
('U1', 6, N'Fullstack Developer',          'Saved',        NULL,         N'https://jobs.example.com/abc-1',  NULL,       '2026-08-21T02:00:00'),
('U1', 6, N'.NET Backend Developer',       'Saved',        NULL,         NULL,                               NULL,       '2026-08-22T02:00:00'),
('U1', 2, N'Junior Backend Developer',     'Applied',      '2026-09-01', N'https://jobs.example.com/vng-2',  N'13-17M',  '2026-09-01T02:00:00'),
('U1', 1, N'Software Engineer (.NET)',     'Applied',      '2026-09-10', N'https://jobs.example.com/fpt-3',  N'12-15M',  '2026-09-10T02:00:00'),
('U2', 7, N'Junior .NET Developer',        'Interviewing', '2026-07-20', N'https://jobs.example.com/fpt-dn', N'10-13M',  '2026-07-20T02:00:00'),
('U2', 8, N'Backend Engineer',             'Rejected',     '2026-07-28', NULL,                               N'18-25M',  '2026-07-28T02:00:00'),
('U2', 9, N'Software Engineer I',          'Applied',      '2026-08-05', N'https://jobs.example.com/axon-1', N'20-30M',  '2026-08-05T02:00:00'),
('U2', 8, N'Junior Backend (.NET)',        'Saved',        NULL,         NULL,                               NULL,       '2026-09-02T02:00:00');

-- ---------------------------------------------------------------------------
-- Interviews (một số Result NULL = chưa diễn ra / chưa cập nhật)
-- ---------------------------------------------------------------------------
INSERT INTO dbo.Interviews (JobApplicationId, ScheduledAt, Type, LocationOrLink, Result) VALUES
(3,  '2026-07-08T03:00:00', 'Phone',     NULL,                                  'Passed'),
(3,  '2026-07-15T07:00:00', 'Technical', N'https://meet.example.com/vng-tech',  'Passed'),
(3,  '2026-09-18T07:00:00', 'Onsite',    N'VNG Campus, Q7',                     NULL),
(4,  '2026-07-17T08:00:00', 'Online',    N'https://meet.example.com/kms-1',     'Passed'),
(4,  '2026-09-20T02:00:00', 'Technical', N'https://meet.example.com/kms-2',     'Pending'),
(6,  '2026-07-30T02:00:00', 'HR',        N'https://meet.example.com/nash-hr',   'Passed'),
(6,  '2026-08-06T02:00:00', 'Technical', N'Nashtech Office, Hà Nội',            'Passed'),
(2,  '2026-06-27T02:00:00', 'Phone',     NULL,                                  'Failed'),
(7,  '2026-08-08T03:00:00', 'Online',    N'https://meet.example.com/tiki-1',    'Failed'),
(13, '2026-07-27T02:00:00', 'HR',        N'https://meet.example.com/fpt-dn-hr', 'Passed'),
(13, '2026-09-16T02:00:00', 'Technical', N'FPT Complex, Đà Nẵng',               NULL),
(14, '2026-08-02T03:00:00', 'Technical', N'https://meet.example.com/momo-1',    'Failed');

-- ---------------------------------------------------------------------------
-- Notes
-- ---------------------------------------------------------------------------
INSERT INTO dbo.Notes (JobApplicationId, Content, CreatedAt, UpdatedAt) VALUES
(1,  N'Nộp qua website. HR nói phản hồi trong 2 tuần.',                          '2026-06-05T02:10:00', NULL),
(3,  N'Vòng phone: hỏi về OOP, LINQ, async. Cần ôn lại deferred execution.',      '2026-07-08T04:00:00', '2026-07-08T05:00:00'),
(3,  N'Vòng technical: bài SQL join + group by; làm được 2/3 câu.',               '2026-07-15T08:30:00', NULL),
(4,  N'Interviewer là team lead. Hỏi về dự án cá nhân.',                          '2026-07-17T09:00:00', NULL),
(6,  N'Offer 16M gross, thử việc 2 tháng. Hạn trả lời 15/09.',                    '2026-08-10T02:00:00', '2026-08-11T02:00:00'),
(6,  N'Đã hỏi về lộ trình thăng tiến và mentor. Cân nhắc so với VNG.',           '2026-08-12T02:00:00', NULL),
(7,  N'Bị loại sau vòng online. Feedback: thiếu kinh nghiệm EF Core.',            '2026-08-09T02:00:00', NULL),
(9,  N'Tìm thấy trên LinkedIn. Chưa rõ stack.',                                   '2026-08-21T02:05:00', NULL),
(11, N'Referral từ bạn. Nên nhắc lại sau 1 tuần.',                                '2026-09-01T02:30:00', NULL),
(13, N'HR hỏi mức lương mong muốn; trả lời 10-13M.',                              '2026-07-27T03:00:00', NULL),
(15, N'Yêu cầu tiếng Anh tốt. Chuẩn bị self-intro.',                              '2026-08-05T02:30:00', NULL);
GO

-- Kiểm tra nhanh
SELECT 'Users' AS TableName, COUNT(*) AS Rows FROM dbo.Users
UNION ALL SELECT 'Companies',       COUNT(*) FROM dbo.Companies
UNION ALL SELECT 'JobApplications', COUNT(*) FROM dbo.JobApplications
UNION ALL SELECT 'Interviews',      COUNT(*) FROM dbo.Interviews
UNION ALL SELECT 'Notes',           COUNT(*) FROM dbo.Notes;
GO
