--#SET TERMINATOR @
-- If the above does not work, set it manually in datastudio
set schema FN71100_71012 @

-- DROP FUNCTION too_old @
CREATE FUNCTION too_old(t TIMESTAMP) RETURNS INT
	BEGIN ATOMIC
	IF (TIMESTAMPDIFF(16,char(CURRENT TIMESTAMP - t))>5)
		THEN RETURN 1;
	ELSE
		RETURN 0;
	END IF;
	END @

-- DROP PROCEDURE cleanup_old_notifications @
CREATE PROCEDURE cleanup_old_notifications() 
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
	DELETE FROM ForumReplyNotification fn
	WHERE FN71100_71012.too_old(fn.created_at)<>0; --older than five days
	DELETE FROM AssignmentNotification an
	WHERE FN71100_71012.too_old(an.created_at)<>0;
	DELETE FROM CourseNotification cn
	WHERE FN71100_71012.too_old(cn.created_at)<>0;
END @

--DROP PROCEDURE urgent_assignment_notifications @
CREATE PROCEDURE urgent_assignment_notifications() 
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
    DECLARE as_title VARCHAR(255);
	DECLARE as_cname VARCHAR(255);
	DECLARE as_cyear SMALLINT;
	DECLARE SQLCODE INTEGER DEFAULT 0;
	DECLARE	as_cursor CURSOR FOR (SELECT title, Course_name, Course_year
						   FROM Assignment
						   WHERE deadline < CURRENT TIMESTAMP + 1 DAYS);
	OPEN as_cursor;
	FETCH as_cursor INTO as_title, as_cname, as_cyear;
	WHILE(SQLCODE=0) DO
		INSERT INTO AssignmentNotification(body, Assignment_title, Assignment_Course_name, Assignment_Course_year)
			VALUES ('Assignment ' CONCAT as_title CONCAT '  has less than 2 days left!',
					as_title, as_cname, as_cyear);
		FETCH as_cursor INTO as_title, as_cname, as_cyear; --beware - the last statement in the while loop is what counts for SQLCODE
	END WHILE;
END @

-- TEST urgent_assignment_notifications
UPDATE Assignment
	SET deadline=CURRENT TIMESTAMP + 1 HOURS
	WHERE Course_name='Python' @

CALL FN71100_71012.urgent_assignment_notifications() @

SELECT * FROM AssignmentNotification @
-- END TEST

-- TEST cleanup_old_notifications
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

-- make it too old
UPDATE ForumReplyNotification frn
    SET frn.created_at=CURRENT TIMESTAMP - 10 DAYS
	WHERE ForumReply_created_at=TIMESTAMP('2010-05-17 21:16:23')
		  AND ForumReply_User_email='valentin@yahoo.com' @

SELECT * FROM forumreplynotification @

CALL FN71100_71012.cleanup_old_notifications() @

SELECT * FROM forumreplynotification @

DELETE FROM ForumReplyNotification frn
	WHERE ForumReply_created_at=TIMESTAMP('2010-05-17 21:16:23')
		  AND ForumReply_User_email='valentin@yahoo.com' @

DELETE FROM forumreply
	WHERE created_at=TIMESTAMP('2010-05-17 21:16:23')
		  AND User_email='valentin@yahoo.com' @
-- END TEST
