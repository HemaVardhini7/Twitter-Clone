-- Forth
USE TwitterDB;
GO

INSERT INTO Followers (FollowerEmail, FollowingEmail)
VALUES ('hema@gmail.com', 'tom@gmail.com');

INSERT INTO Followers (FollowerEmail, FollowingEmail)
VALUES ('tom@gmail.com', 'hema@gmail.com');

INSERT INTO Likes (TweetId, Email)
VALUES (1, 'hema@gmail.com');

INSERT INTO Likes (TweetId, Email)
VALUES (3, 'hema@gmail.com');

INSERT INTO Likes (TweetId, Email)
VALUES (1, 'tom@gmail.com');

INSERT INTO Likes (TweetId, Email)
VALUES (3, 'tom@gmail.com');

INSERT INTO Likes (TweetId, Email)
VALUES (4, 'tom@gmail.com');

INSERT INTO Comments
    (TweetId, Email, CommentText, CreatedAt)
VALUES
    (1, 'hema@gmail.com', 'Nice first tweet!', GETDATE());

INSERT INTO Comments
    (TweetId, Email, CommentText, CreatedAt)
VALUES
    (3, 'hema@gmail.com', 'Great post!', GETDATE());

INSERT INTO Comments
    (TweetId, Email, CommentText, CreatedAt)
VALUES
    (1, 'tom@gmail.com', 'Thanks for the support!', GETDATE());

INSERT INTO Retweets
    (TweetId, Email, RetweetedAt)
VALUES
    (1, 'hema@gmail.com', GETDATE());

INSERT INTO Retweets
    (TweetId, Email, RetweetedAt)
VALUES
    (3, 'hema@gmail.com', GETDATE());

INSERT INTO Reports
    (ReporterEmail, ReportedTweetId, ReportedEmail, Reason, CreatedAt, Status)
VALUES
    ('hema@gmail.com', 7, 'tom@gmail.com',
     'WHY NEW POST!!', GETDATE(), 'Pending');
GO