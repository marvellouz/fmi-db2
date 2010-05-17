set schema FN71100_71012;
--CREATE TRIGGER tr_forumreply_notify AFTER INSERT ON ForumReply
--REFERENCING
--	NEW AS N_ROW
--	FOR EACH ROW
--	INSERT INTO ForumReplyNotification(body,  ForumReply_created_at, ForumReply_User_email)
--	VALUES ('New reply ' CONCAT N_ROW.title CONCAT ' was added to the forum of course ' CONCAT N_ROW.course_name CONCAT '!', N_ROW.title, N_ROW.course_name, N_ROW.course_year);
drop trigger tr_new_assignment_notify;
drop trigger tr_deleted_assignment_notify;
drop trigger tr_enrollment_new_count;
drop trigger tr_enrollment_delete_count;

CREATE TRIGGER tr_new_assignment_notify AFTER INSERT ON Assignment
REFERENCING
	NEW AS N_ROW
	FOR EACH ROW
	INSERT INTO AssignmentNotification(body, Assignment_title, Assignment_Course_name, Assignment_Course_year)
	VALUES ('New assignment ' CONCAT N_ROW.title CONCAT ' was added to course ' CONCAT N_ROW.course_name CONCAT '!', N_ROW.title, N_ROW.course_name, N_ROW.course_year);

CREATE TRIGGER tr_deleted_assignment_notify AFTER DELETE ON Assignment
REFERENCING
	OLD AS O_ROW
	FOR EACH ROW
	INSERT INTO AssignmentNotification(body, Assignment_Course_name, Assignment_Course_year)
	VALUES ('Assignment ' CONCAT O_ROW.title CONCAT ' from course ' CONCAT O_ROW.course_name CONCAT ' was deleted!', O_ROW.course_name, O_ROW.course_year);

CREATE TRIGGER tr_enrollment_new_count AFTER INSERT ON Enrollment
	FOR EACH ROW
		UPDATE Course
		SET numEnrolled=numEnrolled + 1;

CREATE TRIGGER tr_enrollment_delete_count AFTER DELETE ON Enrollment
	FOR EACH ROW
		UPDATE Course
		SET numEnrolled=numEnrolled - 1;

-- Insert an assignment, then deleted and show the triggered notifications
INSERT INTO Assignment (title,description,deadline,max_points,Course_name,Course_year,TeacherProfile_User_email,created_at)
 VALUES('Test assignment 102', 'Description of test assignment 102', TIMESTAMP('2010-06-17 22:35:43'), 6, 'Python', 2009, 'dinko@yahoo.com', TIMESTAMP('2010-05-17 12:38:00'));
DELETE FROM Assignment a
WHERE a.title='Test assignment 102';
SELECT * from AssignmentNotification;
DELETE FROM AssignmentNotification;

-- Show course numEnrolled, Insert enrollment, show again, Delete Enrollment, show again
SELECT numEnrolled FROM Course
WHERE name='Python';
INSERT INTO ENROLLMENT (StudentProfile_User_email, Course_name,  Course_year)
			 VALUES ('dragan@abv.bg', 'Python', 2009);
SELECT numEnrolled FROM Course
WHERE name='Python';
DELETE FROM ENROLLMENT
			WHERE StudentProfile_User_email='dragan@abv.bg' AND Course_name='Set Theory' AND Course_year=2010;
SELECT numEnrolled FROM Course
WHERE name='Python';