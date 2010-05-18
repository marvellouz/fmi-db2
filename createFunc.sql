set schema FN71100_71012;

DROP FUNCTION Get_Speciality;

-- returns the speciality of a based on a faculty number
-- does not check if there is actually a student with this faculty number
CREATE FUNCTION Get_Speciality(fn INT) RETURNS VARCHAR(255)
	RETURN (SELECT speciality_name
	  	FROM SpecialityLookup
	  	WHERE fn>=fn_from AND fn<=fn_to);

SELECT FN71100_71012.Get_Speciality(faculty_number)
FROM StudentProfile;
