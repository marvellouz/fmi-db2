set schema FN71100_71012;

CREATE TRIGGER tr_new_assignment_notify AFTER INSERT ON Assignment
REFERENCING
	NEW AS N_ROW
	FOR EACH ROW
	INSERT INTO AssignmentNotification(body, Assignment_title, Assignment_Course_name, Assignment_Course_year)
	VALUES ('New assignment was added!', N_ROW.title, N_ROW.course_name, N_ROW.course_year);