-- =========================================
-- Intagram graph database
-- =========================================
USE Instagram
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE NAME = 'Instagram')
	CREATE DATABASE Instagram;
GO

DROP TABLE IF EXISTS [Hashtag];
DROP TABLE IF EXISTS [Comment];
DROP TABLE IF EXISTS [Post];
DROP TABLE IF EXISTS [User];
DROP TABLE IF EXISTS Followers;
DROP TABLE IF EXISTS PostSaves;
DROP TABLE IF EXISTS PostUsers;
DROP TABLE IF EXISTS PostHashtags;
DROP TABLE IF EXISTS PostLikes;
DROP TABLE IF EXISTS CommentLikes;
DROP TABLE IF EXISTS CommentUsers;
DROP TABLE IF EXISTS CommentHashtags;

CREATE TABLE [User] (
  Id VARCHAR(100) PRIMARY KEY,
  Name VARCHAR(100),
  Description VARCHAR(100),
  PhotoPath VARCHAR(100)
) AS NODE;
GO

CREATE TABLE [Post] (
  Id BIGINT PRIMARY KEY,
  Creator VARCHAR(100),
  Description VARCHAR(100),
  --PhotoPath VARCHAR(100),
  CreatedAt DATETIME
) AS NODE;
GO

CREATE TABLE [Comment] (
  Id BIGINT PRIMARY KEY,
  PostId BIGINT,
  Creator VARCHAR(100),
  Description VARCHAR(100),
  CreatedAt DATETIME
) AS NODE;
GO


CREATE TABLE [Hashtag] (
  Name VARCHAR(100)
) AS NODE;
GO

CREATE TABLE Followers AS EDGE;
--CREATE TABLE PostCreators AS EDGE;
CREATE TABLE PostLikes AS EDGE;
CREATE TABLE PostSaves AS EDGE;
CREATE TABLE PostUsers AS EDGE;
CREATE TABLE PostHashtags AS EDGE;
--CREATE TABLE CommentCreators AS EDGE;
CREATE TABLE CommentLikes AS EDGE;
CREATE TABLE CommentUsers AS EDGE;
CREATE TABLE CommentHashtags AS EDGE;
--CREATE TABLE PostComments AS EDGE;


--------------INSERTS NODES------------------
INSERT INTO [User] (Id, Name, Description)
	VALUES ('Alexis', 'Alex', 'Viajar :D')
		 , ('Ezequiel', 'Ezequiel', ' ')
		 , ('Cristian', 'Cristian', ' ')
		 , ('Luis', 'Luis', ' ')
		 , ('Marcos', 'Marcos', ' ');

INSERT INTO [Post] (Id, Creator, Description, CreatedAt)
	VALUES 
		(1, 'Alexis', 'Descansando', GETDATE()),
		(2, 'Alexis', 'Un poco de tiempo Libre', GETDATE() ),
		(3, 'Alexis', ' ', GETDATE()),
		(4, 'Ezequiel', 'Vacaciones Post Pandemia!', GETDATE() ),
		(5, 'Luis', 'Unas merecidas vacaciones!!!', GETDATE() )

INSERT INTO [Comment] (Id, PostId, Creator, Description, CreatedAt)
	VALUES 
		(1, 1, 'Ezequiel', 'Gran Foto', GETDATE() ),
		(2, 1, 'Luis', 'Que buenas vacaciones!!!', GETDATE() ),
		(3, 4, 'Alexis', 'Espectacular', GETDATE() )

INSERT INTO [Hashtag] (Name)
	VALUES 
		('TiempoLibre'),
		('Relax'),
		('Vacaciones')

--------------INSERTS EDGES------------------
INSERT INTO Followers VALUES 
	((SELECT $node_id FROM [User] WHERE ID = 'Alexis'), (SELECT $node_id FROM [User] WHERE ID = 'Ezequiel')),
	((SELECT $node_id FROM [User] WHERE ID = 'Alexis'), (SELECT $node_id FROM [User] WHERE ID = 'Cristian')),
	((SELECT $node_id FROM [User] WHERE ID = 'Alexis'), (SELECT $node_id FROM [User] WHERE ID = 'Luis')),
	((SELECT $node_id FROM [User] WHERE ID = 'Alexis'), (SELECT $node_id FROM [User] WHERE ID = 'Marcos')),
	((SELECT $node_id FROM [User] WHERE ID = 'Ezequiel'), (SELECT $node_id FROM [User] WHERE ID = 'Cristian')),
	((SELECT $node_id FROM [User] WHERE ID = 'Ezequiel'), (SELECT $node_id FROM [User] WHERE ID = 'Alexis')),
	((SELECT $node_id FROM [User] WHERE ID = 'Cristian'), (SELECT $node_id FROM [User] WHERE ID = 'Alexis')),
	((SELECT $node_id FROM [User] WHERE ID = 'Cristian'), (SELECT $node_id FROM [User] WHERE ID = 'Ezequiel')),
	((SELECT $node_id FROM [User] WHERE ID = 'Ezequiel'), (SELECT $node_id FROM [User] WHERE ID = 'Luis')),
	((SELECT $node_id FROM [User] WHERE ID = 'Marcos'), (SELECT $node_id FROM [User] WHERE ID = 'Luis'));

INSERT INTO PostLikes VALUES 
	((SELECT $node_id FROM [User] WHERE ID = 'Ezequiel'), (SELECT $node_id FROM [Post] WHERE ID = 1)),
	((SELECT $node_id FROM [User] WHERE ID = 'Cristian'), (SELECT $node_id FROM [Post] WHERE ID = 1)),
	((SELECT $node_id FROM [User] WHERE ID = 'Luis'), (SELECT $node_id FROM [Post] WHERE ID = 1)),
	((SELECT $node_id FROM [User] WHERE ID = 'Cristian'), (SELECT $node_id FROM [Post] WHERE ID = 2)),
	((SELECT $node_id FROM [User] WHERE ID = 'Alexis'), (SELECT $node_id FROM [Post] WHERE ID = 4)),
	--((SELECT $node_id FROM [User] WHERE ID = 'Alexis'), (SELECT $node_id FROM [Post] WHERE ID = 5)),
	((SELECT $node_id FROM [User] WHERE ID = 'Marcos'), (SELECT $node_id FROM [Post] WHERE ID = 5));

INSERT INTO PostUsers VALUES 
	((SELECT $node_id FROM [Post] WHERE ID = 4), (SELECT $node_id FROM [User] WHERE ID = 'Marcos')),
	((SELECT $node_id FROM [Post] WHERE ID = 4), (SELECT $node_id FROM [User] WHERE ID = 'Cristian'));
	
INSERT INTO PostHashtags VALUES 
	((SELECT $node_id FROM [Post] WHERE ID = 1), (SELECT $node_id FROM [Hashtag] WHERE Name = 'Vacaciones')),
	((SELECT $node_id FROM [Post] WHERE ID = 1), (SELECT $node_id FROM [Hashtag] WHERE Name = 'TiempoLibre')),
	((SELECT $node_id FROM [Post] WHERE ID = 1), (SELECT $node_id FROM [Hashtag] WHERE Name = 'Relax')),
	((SELECT $node_id FROM [Post] WHERE ID = 2), (SELECT $node_id FROM [Hashtag] WHERE Name = 'Relax')),
	((SELECT $node_id FROM [Post] WHERE ID = 3), (SELECT $node_id FROM [Hashtag] WHERE Name = 'TiempoLibre')),
	((SELECT $node_id FROM [Post] WHERE ID = 4), (SELECT $node_id FROM [Hashtag] WHERE Name = 'TiempoLibre')),
    ((SELECT $node_id FROM [Post] WHERE ID = 4), (SELECT $node_id FROM [Hashtag] WHERE Name = 'Vacaciones'));
	
INSERT INTO CommentLikes VALUES 
	((SELECT $node_id FROM [User] WHERE ID = 'Alexis'), (SELECT $node_id FROM [Comment] WHERE ID = 1)),
	((SELECT $node_id FROM [User] WHERE ID = 'Alexis'), (SELECT $node_id FROM [Comment] WHERE ID = 2)),
	((SELECT $node_id FROM [User] WHERE ID = 'Cristian'), (SELECT $node_id FROM [Comment] WHERE ID = 1)),
	((SELECT $node_id FROM [User] WHERE ID = 'Luis'), (SELECT $node_id FROM [Comment] WHERE ID = 2)),
	((SELECT $node_id FROM [User] WHERE ID = 'Ezequiel'), (SELECT $node_id FROM [Comment] WHERE ID = 3));

INSERT INTO CommentUsers VALUES 
	((SELECT $node_id FROM [Comment] WHERE ID = 3), (SELECT $node_id FROM [User] WHERE ID = 'Marcos'));
	
INSERT INTO PostHashtags VALUES 
	((SELECT $node_id FROM [Comment] WHERE ID = 2), (SELECT $node_id FROM [Hashtag] WHERE Name = 'Vacaciones'));
	
--------------SELECTS------------------
DECLARE @user VARCHAR(100);   
SET @user = 'Alexis';  

-- Feed
SELECT  Feed.*, 
	CASE WHEN LikedPost.Id is not null THEN 1 ELSE 0 END AS UserLike
	 FROM 
(
	SELECT Post.Id, Post.Creator, Post.Description, CASE WHEN PostLikes.Likes is not null THEN PostLikes.Likes ELSE 0 END AS Likes FROM 
	(
		SELECT Distinct Post.Id, Post.Creator, Post.Description FROM Post, [User], PostLikes
			WHERE 
			Post.Creator in (
				SELECT follower.Id
					FROM [User] usr, Followers, [User] follower
					WHERE 
						MATCH(usr-(Followers)->follower)
						AND usr.Id = @user
			)
	) AS Post 
	LEFT JOIN (
		SELECT Post.Id, Count(*) Likes FROM Post, [User], PostLikes
		WHERE MATCH([User]-(PostLikes)->[Post])
		GROUP BY Post.Id
	) AS PostLikes ON PostLikes.Id = Post.Id
) AS Feed
LEFT JOIN (
SELECT Post.Id, Post.Description FROM Post, [User], PostLikes
WHERE 
	MATCH([User]-(PostLikes)->Post)
	AND [User].Id = @user
) AS LikedPost ON LikedPost.Id = Feed.Id

SELECT 
Feed.*, 
CASE WHEN LikedPost.Id is not null THEN 1 ELSE 0 END AS UserLike
	FROM 
	(
		SELECT Post.Id, Post.Description, Post.Creator, COUNT(Post.Id) Likes FROM Post, [User], PostLikes
		WHERE 
		Post.Creator in (
			SELECT follower.Id
				FROM [User] usr, Followers, [User] follower
				WHERE 
					MATCH(usr-(Followers)->follower)
					AND usr.Id = @user
		) AND MATCH([User]-(PostLikes)->[Post])
		GROUP BY Post.Id, Post.Creator, Post.Description 
	) AS Feed
	LEFT JOIN (
	SELECT Post.Id, Post.Description FROM Post, [User], PostLikes
	WHERE 
		MATCH([User]-(PostLikes)->Post)
		AND [User].Id = @user
	) AS LikedPost ON LikedPost.Id = Feed.Id

-- SELECT * FROM Post
-- Delete a like
/*
DELETE PostLikes
FROM [User], PostLikes, [Post]
WHERE MATCH([User]-(PostLikes)->[Post])
 AND [User].Id= 'Alexis'
 AND [Post].Id = 5;
*/

-- PostCreated
SELECT Id, Description FROM Post
WHERE Creator = @user

-- PostLiked
SELECT Post.Id, Post.Description FROM Post, [User], PostLikes
WHERE 
	MATCH([User]-(PostLikes)->Post)
	AND [User].Id = @user;

-- PostLiked
SELECT Hashtag.Name FROM Post, PostHashtags, Hashtag
WHERE 
	MATCH(Post-(PostHashtags)->Hashtag)

-- CommentCreated
SELECT Comment.Id, Comment.Description FROM Comment
WHERE Creator = @user;

-- CommentLiked
SELECT Comment.Id, Comment.Description FROM Comment, [User], CommentLikes
WHERE 
	MATCH([User]-(CommentLikes)->Comment)
	AND [User].Id = @user;
