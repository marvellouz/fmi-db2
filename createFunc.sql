set schema FN71100_71012;

-- DROP FUNCTION Get_Speciality;

-- returns the speciality of a based on a faculty number
-- does not check if there is actually a student with this faculty number
CREATE FUNCTION get_speciality(fn INT) RETURNS VARCHAR(255)
	RETURN (SELECT speciality_name
	  	FROM SpecialityLookup
	  	WHERE fn>=fn_from AND fn<=fn_to);

CREATE FUNCTION count_speciality_students(spec VARCHAR(255)) RETURNS INT
	RETURN (SELECT COUNT(*)
	  	FROM StudentProfile sp
	  	WHERE spec=FN71100_71012.get_speciality(sp.faculty_number));

CREATE FUNCTION get_teacher_mean_rating(teacher_email VARCHAR(255)) RETURNS DOUBLE
	RETURN (SELECT 1.0*SUM(value) / COUNT(value)
			FROM Rating r
			WHERE r.TeacherProfile_User_email=teacher_email);

SELECT u.first_name, u.last_name, faculty_number, FN71100_71012.get_speciality(sp.faculty_number) as "Speciality"
FROM StudentProfile sp
LEFT JOIN User u
on u.email=sp.User_email
GROUP BY sp.faculty_number, u.first_name, u.last_name ;

SELECT s.name, FN71100_71012.count_speciality_students(s.name) as "Students"
FROM Speciality s
GROUP BY s.name;

SELECT t.User_email, FN71100_71012.get_teacher_mean_rating(t.User_email) FROM
TeacherProfile t
GROUP BY t.User_email;

SELECT * FROM RATING;