-- Second
USE TwitterDB;
GO

CREATE TABLE Tweets (
    TweetId INT IDENTITY(1,1) PRIMARY KEY,
    Email VARCHAR(100),
    TweetText VARCHAR(280),
    CreatedAt DATETIME DEFAULT GETDATE(),
    ImagePath VARCHAR(300) NULL,
    FOREIGN KEY (Email) REFERENCES Users(Email)
);
GO

CREATE TABLE Likes (
    LikeId INT IDENTITY(1,1) PRIMARY KEY,
    TweetId INT,
    Email VARCHAR(100),
    FOREIGN KEY (TweetId) REFERENCES Tweets(TweetId),
    FOREIGN KEY (Email) REFERENCES Users(Email)
);
GO

ALTER TABLE Likes
ADD LikedAt DATETIME NOT NULL
    CONSTRAINT DF_Likes_LikedAt DEFAULT GETDATE();
GO

CREATE TABLE Followers (
    FollowerId INT IDENTITY(1,1) PRIMARY KEY,
    FollowerEmail VARCHAR(100),
    FollowingEmail VARCHAR(100),
    FOREIGN KEY (FollowerEmail) REFERENCES Users(Email),
    FOREIGN KEY (FollowingEmail) REFERENCES Users(Email)
);

GO

ALTER TABLE Followers
ADD Status VARCHAR(20) NOT NULL
    CONSTRAINT DF_Followers_Status DEFAULT 'Accepted';
GO

CREATE TABLE Comments (
    CommentId INT IDENTITY(1,1) PRIMARY KEY,
    TweetId INT,
    Email VARCHAR(100),
    CommentText VARCHAR(200),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TweetId) REFERENCES Tweets(TweetId),
    FOREIGN KEY (Email) REFERENCES Users(Email)
);
GO

CREATE TABLE Retweets (
    RetweetId INT IDENTITY(1,1) PRIMARY KEY,
    TweetId INT,
    Email VARCHAR(100),
    RetweetedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TweetId) REFERENCES Tweets(TweetId),
    FOREIGN KEY (Email) REFERENCES Users(Email)
);
GO

CREATE TABLE Reports (
    ReportId INT IDENTITY(1,1) PRIMARY KEY,
    ReporterEmail VARCHAR(100),
    ReportedTweetId INT NULL,
    ReportedEmail VARCHAR(100) NULL,
    Reason VARCHAR(200),
    CreatedAt DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (ReportedTweetId) REFERENCES Tweets(TweetId),
    FOREIGN KEY (ReporterEmail) REFERENCES Users(Email),
    FOREIGN KEY (ReportedEmail) REFERENCES Users(Email)
);
GO



CREATE TABLE ContentModeration
(
    ModerationId INT IDENTITY(1,1) PRIMARY KEY,
    Email VARCHAR(100) NOT NULL,
    ContentType VARCHAR(20) NOT NULL,
    ContentText NVARCHAR(MAX) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    IsSafe BIT NOT NULL,
    Reason NVARCHAR(500) NULL,
    TweetId INT NULL,
    CommentId INT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (Email) REFERENCES Users(Email),
    FOREIGN KEY (TweetId) REFERENCES Tweets(TweetId),
    FOREIGN KEY (CommentId) REFERENCES Comments(CommentId),
    CHECK (ContentType IN ('Tweet', 'Comment'))
);
GO


CREATE TABLE Bookmarks (
    BookmarkId INT IDENTITY(1,1) PRIMARY KEY,
    TweetId INT NOT NULL,
    Email VARCHAR(100) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (TweetId) REFERENCES Tweets(TweetId),
    FOREIGN KEY (Email) REFERENCES Users(Email),

    CONSTRAINT UQ_Bookmarks UNIQUE (TweetId, Email)
);


