--#SET TERMINATOR @
-- If the above does not work, set it manually in datastudio
set schema FN71100_71012 @

DROP PROCEDURE cleanup_old_notifications @

CREATE PROCEDURE cleanup_old_notifications() 
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
	DELETE FROM ForumReplyNotification an
	WHERE TIMESTAMPDIFF(16,char(CURRENT TIMESTAMP - an.created_at)) > 5; --older than five days
END @

SELECT * FROM forumreplynotification @

INSERT INTO ForumReply (User_email,created_at,ForumThread_created_at,ForumThread_title,ForumReply_created_at,ForumReply_User_email,title,body,num_likes,num_edits)
 VALUES('valentin@yahoo.com',
 		TIMESTAMP('2010-05-17 21:16:23'),
 		TIMESTAMP('2010-05-17 13:16:23'),
 		'Test title of thread',
 		NULL, NULL,
 		'Some stuff.',
 		'Some body stuff.',
 		4, 1) @

SELECT * FROM forumreplynotification @

UPDATE ForumReplyNotification frn
    SET frn.created_at=CURRENT TIMESTAMP - 10 DAYS
	WHERE ForumReply_created_at=TIMESTAMP('2010-05-17 21:16:23')
		  AND ForumReply_User_email='valentin@yahoo.com' @

SELECT * FROM forumreplynotification @
