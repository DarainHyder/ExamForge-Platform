-- ============================================
-- ExamForge Database Schema
-- ============================================

USE master;
GO

-- Drop database if exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ExamForge')
BEGIN
    ALTER DATABASE ExamForge SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ExamForge;
END
GO

CREATE DATABASE ExamForge;
GO

USE ExamForge;
GO

-- ============================================
-- TABLES
-- ============================================

-- Subjects Table
CREATE TABLE Subjects (
    SubjectID INT PRIMARY KEY IDENTITY(1,1),
    SubjectName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256) NOT NULL,
    Role NVARCHAR(20) CHECK (Role IN ('Admin', 'Teacher', 'Student')) NOT NULL,
    SubjectID INT NULL,
    Email NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Questions Table
CREATE TABLE QuestionsTable (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    SubjectID INT NOT NULL,
    QuestionStatement NVARCHAR(MAX) NOT NULL,
    QuestionType NVARCHAR(20) CHECK (QuestionType IN ('MCQ', 'MultiSelect', 'Paragraph')) NOT NULL,
    OptionA NVARCHAR(500),
    OptionB NVARCHAR(500),
    OptionC NVARCHAR(500),
    OptionD NVARCHAR(500),
    CorrectOption NVARCHAR(10), -- For MCQ: 'A', 'B', 'C', 'D' | For MultiSelect: 'A,B,C'
    CorrectAnswer NVARCHAR(MAX), -- For Paragraph type
    DifficultyLevel NVARCHAR(20) CHECK (DifficultyLevel IN ('Easy', 'Medium', 'Hard')),
    Marks DECIMAL(5,2) DEFAULT 1,
    ImagePath NVARCHAR(500),
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Quiz Table
CREATE TABLE Quiz (
    QuizID INT PRIMARY KEY IDENTITY(1,1),
    QuizTitle NVARCHAR(200) NOT NULL,
    SubjectID INT NOT NULL,
    StartTime DATETIME,
    EndTime DATETIME,
    AllowedTime INT NOT NULL, -- in minutes
    TotalQuestions INT NOT NULL,
    TotalMarks DECIMAL(6,2) NOT NULL,
    PassingMarks DECIMAL(6,2),
    RandomizeQuestions BIT DEFAULT 0,
    ShuffleOptions BIT DEFAULT 0,
    AllowReview BIT DEFAULT 1,
    AttemptOnce BIT DEFAULT 1,
    NegativeMarking BIT DEFAULT 0,
    NegativeMarks DECIMAL(5,2) DEFAULT 0,
    Remarks NVARCHAR(MAX),
    IsPublished BIT DEFAULT 0,
    IsTestMode BIT DEFAULT 0, -- For teacher preview
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Quiz Questions Mapping
CREATE TABLE QuizQuestions (
    QuizID INT NOT NULL,
    QuestionID INT NOT NULL,
    DisplayOrder INT NOT NULL,
    PRIMARY KEY (QuizID, QuestionID),
    FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES QuestionsTable(QuestionID)
);

-- Student Answers
CREATE TABLE Answers (
    AnswerID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    QuizID INT NOT NULL,
    QuestionID INT NOT NULL,
    QuestionNumber INT NOT NULL,
    CorrectAnswer NVARCHAR(MAX),
    StudentAnswer NVARCHAR(MAX),
    MarksAwarded DECIMAL(5,2) DEFAULT 0,
    IsCorrect BIT DEFAULT 0,
    AnsweredAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID)
);

-- Quiz Results
CREATE TABLE Results (
    ResultID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    QuizID INT NOT NULL,
    TotalMarks DECIMAL(6,2) NOT NULL,
    ObtainedMarks DECIMAL(6,2) NOT NULL,
    Percentage DECIMAL(5,2),
    TotalCorrect INT DEFAULT 0,
    TotalIncorrect INT DEFAULT 0,
    TotalUnanswered INT DEFAULT 0,
    TimeTaken INT, -- in minutes
    AttemptDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID)
);

-- Notifications
CREATE TABLE Notifications (
    NotifID INT PRIMARY KEY IDENTITY(1,1),
    ToUserID INT NOT NULL,
    FromUserID INT,
    Message NVARCHAR(MAX) NOT NULL,
    RelatedQuizID INT,
    IsRead BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ToUserID) REFERENCES Users(UserID),
    FOREIGN KEY (FromUserID) REFERENCES Users(UserID),
    FOREIGN KEY (RelatedQuizID) REFERENCES Quiz(QuizID)
);

GO

-- ============================================
-- SEED DATA
-- ============================================

-- Insert Subjects
INSERT INTO Subjects (SubjectName, Description) VALUES
('Mathematics', 'Math and Numerical Analysis'),
('Computer Science', 'Programming and Algorithms'),
('Physics', 'Applied Physics'),
('English', 'Language and Literature');
GO

-- Insert Users (Password: Admin@123, Teacher@1, Student@1 etc - hashed with SHA256)
-- Note: In production, use proper hashing with salt

-- Admin
INSERT INTO Users (FullName, Username, PasswordHash, Role, Email) VALUES
('System Administrator', 'admin', 
CONVERT(NVARCHAR(256), HASHBYTES('SHA2_256', 'Admin@123'), 2), 
'Admin', 'admin@examforge.com');

-- Teachers
INSERT INTO Users (FullName, Username, PasswordHash, Role, SubjectID, Email) VALUES
('Ali Hassan', 't_ali', 
CONVERT(NVARCHAR(256), HASHBYTES('SHA2_256', 'Teacher@1'), 2), 
'Teacher', 1, 'ali@examforge.com'),
('Sara Ahmed', 't_sara', 
CONVERT(NVARCHAR(256), HASHBYTES('SHA2_256', 'Teacher@2'), 2), 
'Teacher', 2, 'sara@examforge.com');

-- Students
INSERT INTO Users (FullName, Username, PasswordHash, Role, SubjectID, Email) VALUES
('Usman Khan', 's_usman', 
CONVERT(NVARCHAR(256), HASHBYTES('SHA2_256', 'Student@1'), 2), 
'Student', 1, 'usman@student.com'),
('Ayesha Malik', 's_ayesha', 
CONVERT(NVARCHAR(256), HASHBYTES('SHA2_256', 'Student@2'), 2), 
'Student', 2, 'ayesha@student.com'),
('Bilal Raza', 's_bilal', 
CONVERT(NVARCHAR(256), HASHBYTES('SHA2_256', 'Student@3'), 2), 
'Student', 1, 'bilal@student.com');
GO

-- Sample Questions
INSERT INTO QuestionsTable (SubjectID, QuestionStatement, QuestionType, OptionA, OptionB, OptionC, OptionD, CorrectOption, DifficultyLevel, Marks, CreatedBy) VALUES
(1, 'What is 15 + 27?', 'MCQ', '41', '42', '43', '44', 'B', 'Easy', 1, 2),
(1, 'Solve: 12 * 8', 'MCQ', '84', '96', '88', '92', 'B', 'Medium', 1, 2),
(2, 'Which are programming languages?', 'MultiSelect', 'Python', 'HTML', 'Java', 'CSS', 'A,C', 'Medium', 2, 3),
(2, 'What does CPU stand for?', 'MCQ', 'Central Processing Unit', 'Computer Personal Unit', 'Central Program Utility', 'None', 'A', 'Easy', 1, 3);
GO

-- ============================================
-- STORED PROCEDURES
-- ============================================

-- Get Available Quizzes for Student
CREATE PROCEDURE sp_GetAvailableQuizzes
    @StudentID INT
AS
BEGIN
    SELECT 
        Q.QuizID,
        Q.QuizTitle,
        S.SubjectName,
        Q.TotalQuestions,
        Q.TotalMarks,
        Q.AllowedTime,
        Q.StartTime,
        Q.EndTime,
        CASE 
            WHEN EXISTS (SELECT 1 FROM Results WHERE StudentID = @StudentID AND QuizID = Q.QuizID)
            THEN 1 ELSE 0 
        END AS IsAttempted
    FROM Quiz Q
    INNER JOIN Subjects S ON Q.SubjectID = S.SubjectID
    WHERE Q.IsPublished = 1 
      AND Q.IsTestMode = 0
      AND GETDATE() BETWEEN Q.StartTime AND Q.EndTime
    ORDER BY Q.StartTime DESC;
END
GO

-- Get Quiz Questions with Randomization
CREATE PROCEDURE sp_GetQuizQuestions
    @QuizID INT,
    @Randomize BIT
AS
BEGIN
    IF @Randomize = 1
    BEGIN
        SELECT TOP 100 PERCENT
            QT.QuestionID,
            QT.QuestionStatement,
            QT.QuestionType,
            QT.OptionA,
            QT.OptionB,
            QT.OptionC,
            QT.OptionD,
            QT.Marks,
            QT.ImagePath
        FROM QuizQuestions QQ
        INNER JOIN QuestionsTable QT ON QQ.QuestionID = QT.QuestionID
        WHERE QQ.QuizID = @QuizID
        ORDER BY NEWID();
    END
    ELSE
    BEGIN
        SELECT 
            QT.QuestionID,
            QT.QuestionStatement,
            QT.QuestionType,
            QT.OptionA,
            QT.OptionB,
            QT.OptionC,
            QT.OptionD,
            QT.Marks,
            QT.ImagePath
        FROM QuizQuestions QQ
        INNER JOIN QuestionsTable QT ON QQ.QuestionID = QT.QuestionID
        WHERE QQ.QuizID = @QuizID
        ORDER BY QQ.DisplayOrder;
    END
END
GO

-- Calculate and Save Result
CREATE PROCEDURE sp_CalculateResult
    @StudentID INT,
    @QuizID INT
AS
BEGIN
    DECLARE @TotalMarks DECIMAL(6,2);
    DECLARE @ObtainedMarks DECIMAL(6,2);
    DECLARE @TotalCorrect INT;
    DECLARE @TotalIncorrect INT;
    DECLARE @TotalQuestions INT;
    DECLARE @Percentage DECIMAL(5,2);

    -- Get quiz total marks
    SELECT @TotalMarks = TotalMarks, @TotalQuestions = TotalQuestions
    FROM Quiz WHERE QuizID = @QuizID;

    -- Calculate obtained marks
    SELECT 
        @ObtainedMarks = SUM(MarksAwarded),
        @TotalCorrect = SUM(CASE WHEN IsCorrect = 1 THEN 1 ELSE 0 END),
        @TotalIncorrect = SUM(CASE WHEN IsCorrect = 0 AND StudentAnswer IS NOT NULL THEN 1 ELSE 0 END)
    FROM Answers
    WHERE StudentID = @StudentID AND QuizID = @QuizID;

    SET @ObtainedMarks = ISNULL(@ObtainedMarks, 0);
    SET @Percentage = (@ObtainedMarks / @TotalMarks) * 100;

    -- Insert result
    INSERT INTO Results (StudentID, QuizID, TotalMarks, ObtainedMarks, Percentage, TotalCorrect, TotalIncorrect, TotalUnanswered)
    VALUES (@StudentID, @QuizID, @TotalMarks, @ObtainedMarks, @Percentage, @TotalCorrect, @TotalIncorrect, @TotalQuestions - (@TotalCorrect + @TotalIncorrect));

    SELECT @ObtainedMarks AS ObtainedMarks, @TotalMarks AS TotalMarks, @Percentage AS Percentage;
END
GO

PRINT 'ExamForge Database Schema Created Successfully!';
GO
