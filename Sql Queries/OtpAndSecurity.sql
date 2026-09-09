-- Third 

USE TwitterDB;
GO

ALTER TABLE Users
ALTER COLUMN Password VARCHAR(300) NOT NULL;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.columns
    WHERE object_id = OBJECT_ID('Users')
      AND name = 'IsVerified'
)
BEGIN
    ALTER TABLE Users
    ADD IsVerified BIT NOT NULL DEFAULT 0;
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE name = 'OtpVerification'
)
BEGIN
    CREATE TABLE OtpVerification (
        OtpId INT IDENTITY(1,1) PRIMARY KEY,
        Email VARCHAR(100) NOT NULL,
        OtpHash VARCHAR(128) NOT NULL,
        Purpose VARCHAR(20) NOT NULL,
        ExpiryTime DATETIME NOT NULL,
        Attempts INT NOT NULL DEFAULT 0,
        IsUsed BIT NOT NULL DEFAULT 0,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        LastSentAt DATETIME NOT NULL DEFAULT GETDATE()
    );

    CREATE INDEX IX_OtpVerification_Email_Purpose
    ON OtpVerification (Email, Purpose, IsUsed);
END
GO