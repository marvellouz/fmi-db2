create view StudentsInfoView as
select faculty_number, email, first_name, last_name from
StudentProfile s join User u on
s.User_email = u.email;

select * from StudentsInfoView;

create view TeacherInfoView as
select title, email, first_name, last_name from
TeacherProfile s join User u on
s.User_email = u.email;

select * from TeacherInfoView;

create view TeacherStudentView as
select * 
from User where
email in (select User_email from TeacherProfile)
and
email in (select User_email from StudentProfile);

select * from TeacherStudentView;