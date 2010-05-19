set schema FN71100_71012;

DROP FUNCTION count_speciality_students; --NOTE: cout_speciality_students depends on get_speciality
DROP FUNCTION get_speciality;
DROP FUNCTION teacher_mean_rating;
DROP FUNCTION all_course_teachers;

DROP TABLE  User ;
DROP TABLE  StudentProfile ;
DROP TABLE  TeacherProfile ;
DROP TABLE  Category ;
DROP TABLE  Course ;
DROP TABLE  ForumThread ;
DROP TABLE  ForumReply ;
DROP TABLE  Enrollment ;
DROP TABLE  CourseGrade ;
DROP TABLE  Rating ;
DROP TABLE  Assignment ;
DROP TABLE  AssignmentGrade ;
DROP TABLE  CourseOtherTeachers ;
DROP TABLE  News ;
DROP TABLE  AssignmentFile ;
DROP TABLE  Resource ;
DROP TABLE  ResourceFile ;
DROP TABLE  AssignmentNotification ;
DROP TABLE  CourseNotification ;
DROP TABLE  ForumReplyNotification ;
DROP TABLE  Speciality ;
DROP TABLE  SpecialityLookup;

-- -----------------------------------------------------
-- Table User
-- -----------------------------------------------------
CREATE  TABLE  User (
  email VARCHAR(255) NOT NULL ,
  first_name VARCHAR(45) NOT NULL ,
  last_name VARCHAR(45) NOT NULL ,
  password VARCHAR(45) NOT NULL ,
  PRIMARY KEY (email) );

-- -----------------------------------------------------
-- Table StudentProfile
-- -----------------------------------------------------
CREATE  TABLE  StudentProfile (
  faculty_number INT NOT NULL ,
  User_email VARCHAR(255) NOT NULL ,
  PRIMARY KEY (User_email) ,
  CONSTRAINT fk_StudentProfile_User
    FOREIGN KEY (User_email )
    REFERENCES User (email )
    ON DELETE CASCADE
    ON UPDATE RESTRICT
    );

-- -----------------------------------------------------
-- Table TeacherProfile
-- -----------------------------------------------------
CREATE  TABLE  TeacherProfile (
  title VARCHAR(45),
  User_email VARCHAR(255) NOT NULL,
  PRIMARY KEY (User_email) ,
  CONSTRAINT fk_TeacherProfile_User
    FOREIGN KEY (User_email )
    REFERENCES User (email )
    ON DELETE CASCADE
    );

-- -----------------------------------------------------
-- Table Category
-- -----------------------------------------------------
CREATE  TABLE  Category (
  name VARCHAR(45) NOT NULL ,
  PRIMARY KEY (name) );

-- -----------------------------------------------------
-- Table Course
-- -----------------------------------------------------

CREATE  TABLE  Course (
  name VARCHAR(255) NOT NULL ,
  year SMALLINT NOT NULL ,
  Category_name VARCHAR(45) ,
  password VARCHAR(45),
  numEnrolled INT NOT NULL DEFAULT 0 ,
  TeacherProfile_User_email VARCHAR(255),
  PRIMARY KEY (name, year),
  CONSTRAINT fk_Course_Category
    FOREIGN KEY (Category_name )
    REFERENCES Category (name)
    ON DELETE SET NULL,
  CONSTRAINT fk_Course_TeacherProfile
    FOREIGN KEY (TeacherProfile_User_email )
    REFERENCES TeacherProfile (User_email )
    ON DELETE SET NULL
    ON UPDATE NO ACTION);

CREATE INDEX fk_Course_Category ON Course (Category_name ASC) ;

CREATE INDEX fk_Course_TeacherProfile ON Course (TeacherProfile_User_email ASC) ;

-- -----------------------------------------------------
-- Table ForumThread
-- -----------------------------------------------------
CREATE  TABLE  ForumThread (
  created_at TIMESTAMP NOT NULL ,
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  title VARCHAR(255) NOT NULL ,
  body VARCHAR(1644) NOT NULL ,
  PRIMARY KEY (created_at, title) ,
  CONSTRAINT fk_ForumThread_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE CASCADE
    );

-- -----------------------------------------------------
-- Table ForumReply
-- -----------------------------------------------------
CREATE  TABLE  ForumReply (
  User_email VARCHAR(255) NOT NULL ,
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  ForumThread_created_at TIMESTAMP NOT NULL ,
  ForumThread_title VARCHAR(255) NOT NULL ,
  -- parent
  ForumReply_created_at TIMESTAMP,
  ForumReply_User_email VARCHAR(255),
  title VARCHAR(255) NOT NULL ,
  body VARCHAR(6144) NOT NULL ,
  num_likes INT NOT NULL DEFAULT 0 , --unsigned
  num_edits INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (User_email, created_at) ,
  CONSTRAINT fk_ForumReply_User
    FOREIGN KEY (User_email )
    REFERENCES User (email )
    ON DELETE CASCADE
   );


ALTER TABLE ForumReply
    ADD CONSTRAINT fk_ForumReply_ForumReply
    FOREIGN KEY (ForumReply_created_at , ForumReply_User_email )
    REFERENCES ForumReply (created_at , User_email )
    ON DELETE CASCADE;

-- circular dependencies workaround
ALTER TABLE ForumReply ADD
    CONSTRAINT fk_ForumReply_ForumThread
    FOREIGN KEY (ForumThread_created_at , ForumThread_title )
    REFERENCES ForumThread (created_at , title )
    ON DELETE CASCADE;

CREATE INDEX fk_ForumThread_Course ON ForumThread (Course_name ASC, Course_year ASC) ;

CREATE INDEX fk_ForumReply_User ON ForumReply (User_email ASC) ;

CREATE INDEX fk_ForumReply_ForumReply ON ForumReply (ForumReply_created_at ASC, ForumReply_User_email ASC) ;

CREATE INDEX fk_ForumReply_ForumThread ON ForumReply (ForumThread_created_at ASC, ForumThread_title ASC) ;

-- -----------------------------------------------------
-- Table Enrollment
-- -----------------------------------------------------
CREATE  TABLE  Enrollment (
  StudentProfile_User_email VARCHAR(255) NOT NULL ,
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  PRIMARY KEY (StudentProfile_User_email, Course_name, Course_year) ,
  CONSTRAINT fk_Enrollment_StudentProfile
    FOREIGN KEY (StudentProfile_User_email )
    REFERENCES StudentProfile (User_email )
    ON DELETE CASCADE,
  CONSTRAINT fk_Enrollment_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE CASCADE
    );

CREATE INDEX fk_Enrollment_StudentProfile ON Enrollment (StudentProfile_User_email ASC) ;

CREATE INDEX fk_Enrollment_Course ON Enrollment (Course_name ASC, Course_year ASC) ;


-- -----------------------------------------------------
-- Table CourseGrade
-- -----------------------------------------------------
CREATE  TABLE  CourseGrade (
  value SMALLINT NOT NULL DEFAULT 0 , --unsigned
  StudentProfile_User_email VARCHAR(255) NOT NULL ,
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  PRIMARY KEY (StudentProfile_User_email, Course_name, Course_year) ,
  CONSTRAINT fk_CourseGrade_StudentProfile
    FOREIGN KEY (StudentProfile_User_email )
    REFERENCES StudentProfile (User_email )
    ON DELETE CASCADE,
  CONSTRAINT fk_CourseGrade_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE CASCADE
    );

CREATE INDEX fk_CourseGrade_StudentProfile ON CourseGrade (StudentProfile_User_email ASC) ;

CREATE INDEX fk_CourseGrade_Course ON CourseGrade (Course_name ASC, Course_year ASC) ;


-- -----------------------------------------------------
-- Table Rating
-- -----------------------------------------------------
CREATE  TABLE  Rating (
  value SMALLINT NOT NULL ,
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  StudentProfile_User_email VARCHAR(255) NOT NULL ,
  TeacherProfile_User_email VARCHAR(255) NOT NULL ,
  PRIMARY KEY (Course_name, Course_year, StudentProfile_User_email, TeacherProfile_User_email) ,
  CONSTRAINT fk_Rating_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE CASCADE,
  CONSTRAINT fk_Rating_StudentProfile
    FOREIGN KEY (StudentProfile_User_email )
    REFERENCES StudentProfile (User_email )
    ON DELETE CASCADE,
  CONSTRAINT fk_Rating_TeacherProfile
    FOREIGN KEY (TeacherProfile_User_email )
    REFERENCES TeacherProfile (User_email )
    ON DELETE CASCADE 
    );

CREATE INDEX fk_Rating_Course ON Rating (Course_name ASC, Course_year ASC) ;

CREATE INDEX fk_Rating_StudentProfile ON Rating (StudentProfile_User_email ASC) ;

CREATE INDEX fk_Rating_TeacherProfile ON Rating (TeacherProfile_User_email ASC) ;

-- -----------------------------------------------------
-- Table Assignment
-- -----------------------------------------------------
CREATE  TABLE  Assignment (
  title VARCHAR(255) NOT NULL ,
  description VARCHAR(6144) NOT NULL ,
  deadline TIMESTAMP NOT NULL WITH DEFAULT,
  max_points SMALLINT NOT NULL , --unsigned
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  TeacherProfile_User_email VARCHAR(255),
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  PRIMARY KEY (title, Course_name, Course_year) ,
  CONSTRAINT fk_Assignment_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE CASCADE,
  CONSTRAINT fk_Assignment_TeacherProfile
    FOREIGN KEY (TeacherProfile_User_email )
    REFERENCES TeacherProfile (User_email )
    );

CREATE INDEX fk_Assignment_Course ON Assignment (Course_name ASC, Course_year ASC) ;

CREATE INDEX fk_Assignment_TeacherProfile ON Assignment (TeacherProfile_User_email ASC) ;


-- -----------------------------------------------------
-- Table AssignmentGrade
-- -----------------------------------------------------
CREATE  TABLE  AssignmentGrade (
  value SMALLINT NOT NULL , -- unsigned
  StudentProfile_User_email VARCHAR(255) NOT NULL ,
  Assignment_title VARCHAR(255) NOT NULL ,
  Assignment_Course_name VARCHAR(255) NOT NULL ,
  Assignment_Course_year SMALLINT NOT NULL ,
  PRIMARY KEY (StudentProfile_User_email, Assignment_title, Assignment_Course_name, Assignment_Course_year) ,
  CONSTRAINT fk_AssignmentGrade_StudentProfile
    FOREIGN KEY (StudentProfile_User_email )
    REFERENCES StudentProfile (User_email )
    ON DELETE CASCADE,
  CONSTRAINT fk_AssignmentGrade_Assignment
    FOREIGN KEY (Assignment_title , Assignment_Course_name , Assignment_Course_year )
    REFERENCES Assignment (title , Course_name , Course_year )
    ON DELETE CASCADE
    );

CREATE INDEX fk_AssignmentGrade_Assignment ON AssignmentGrade (Assignment_title ASC, Assignment_Course_name ASC, Assignment_Course_year ASC) ;

-- -----------------------------------------------------
-- Table CourseOtherTeachers
-- -----------------------------------------------------
CREATE  TABLE  CourseOtherTeachers (
  TeacherProfile_User_email VARCHAR(255) NOT NULL ,
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  PRIMARY KEY (TeacherProfile_User_email, Course_name, Course_year) ,
  CONSTRAINT fk_CourseOtherTeachers_TeacherProfile
    FOREIGN KEY (TeacherProfile_User_email )
    REFERENCES TeacherProfile (User_email )
    ON DELETE CASCADE,
  CONSTRAINT fk_CourseOtherTeachers_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE CASCADE
    );

CREATE INDEX fk_CourseOtherTeachers_TeacherProfile ON CourseOtherTeachers (TeacherProfile_User_email ASC) ;

CREATE INDEX fk_CourseOtherTeachers_Course ON CourseOtherTeachers (Course_name ASC, Course_year ASC) ;

-- -----------------------------------------------------
-- Table News
-- -----------------------------------------------------
CREATE  TABLE  News (
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  title VARCHAR(255) NOT NULL ,
  body VARCHAR(1644) NOT NULL ,
  TeacherProfile_User_email VARCHAR(255) NOT NULL,
  PRIMARY KEY (created_at, TeacherProfile_User_email) ,
  CONSTRAINT fk_News_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE CASCADE,
  CONSTRAINT fk_News_TeacherProfile
    FOREIGN KEY (TeacherProfile_User_email )
    REFERENCES TeacherProfile (User_email )
    ON DELETE CASCADE
    );

CREATE INDEX fk_News_Course ON News (Course_name ASC, Course_year ASC) ;

CREATE INDEX fk_News_TeacherProfile ON News (TeacherProfile_User_email ASC) ;


-- -----------------------------------------------------
-- Table AssignmentFile
-- -----------------------------------------------------
CREATE  TABLE  AssignmentFile (
  path VARCHAR(1024) NOT NULL ,
  name VARCHAR(255) ,
  Assignment_title VARCHAR(255) NOT NULL ,
  Assignment_Course_name VARCHAR(255) NOT NULL ,
  Assignment_Course_year SMALLINT NOT NULL ,
  PRIMARY KEY (path) ,
  CONSTRAINT fk_AssignmentFile_Assignment
    FOREIGN KEY (Assignment_title , Assignment_Course_name , Assignment_Course_year )
    REFERENCES Assignment (title , Course_name , Course_year )
    ON DELETE CASCADE
    );

CREATE INDEX fk_AssignmentFile_Assignment ON AssignmentFile (Assignment_title ASC, Assignment_Course_name ASC, Assignment_Course_year ASC) ;

-- -----------------------------------------------------
-- Table Resource
-- -----------------------------------------------------
CREATE  TABLE  Resource (
  id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  description VARCHAR(6144) NOT NULL ,
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  PRIMARY KEY (id) ,
  CONSTRAINT fk_Resource_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE CASCADE
    );

CREATE INDEX fk_Resource_Course ON Resource (Course_name ASC, Course_year ASC) ;


-- -----------------------------------------------------
-- Table ResourceFile
-- -----------------------------------------------------
CREATE  TABLE  ResourceFile (
  path VARCHAR(1024) NOT NULL ,
  name VARCHAR(255) ,
  Resource_id INT NOT NULL ,
  PRIMARY KEY (path) ,
  CONSTRAINT fk_ResourceFile_Resource
    FOREIGN KEY (Resource_id )
    REFERENCES Resource (id )
    ON DELETE CASCADE
    );

CREATE INDEX fk_ResourceFile_Resource ON ResourceFile (Resource_id ASC) ;


-- -----------------------------------------------------
-- Table AssignmentNotification
-- -----------------------------------------------------
CREATE  TABLE  AssignmentNotification (
  body VARCHAR(6144) NOT NULL ,
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  Assignment_title VARCHAR(255),
  Assignment_Course_name VARCHAR(255),
  Assignment_Course_year SMALLINT,
  PRIMARY KEY (id) ,
  CONSTRAINT fk_AssignmentNotification_Assignment
    FOREIGN KEY (Assignment_title , Assignment_Course_name , Assignment_Course_year )
    REFERENCES Assignment (title , Course_name , Course_year )
    ON DELETE SET NULL
    );

CREATE INDEX fk_AssignmentNotification_Assignment ON AssignmentNotification (Assignment_title ASC, Assignment_Course_name ASC, Assignment_Course_year ASC) ;


-- -----------------------------------------------------
-- Table CourseNotification
-- -----------------------------------------------------
CREATE  TABLE  CourseNotification (
  body VARCHAR(6144) NOT NULL ,
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  Course_name VARCHAR(255) ,
  Course_year SMALLINT ,
  PRIMARY KEY (id) ,
  CONSTRAINT fk_CourseNotification_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE SET NULL
  );

CREATE INDEX fk_CourseNotification_Course ON CourseNotification (Course_name ASC, Course_year ASC) ;

-- -----------------------------------------------------
-- Table ForumReplyNotification
-- -----------------------------------------------------
CREATE  TABLE  ForumReplyNotification (
  body VARCHAR(1644) NOT NULL ,
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  PRIMARY KEY (id),
  ForumReply_created_at TIMESTAMP,
  ForumReply_User_email VARCHAR(255),
  CONSTRAINT fk_ForumReplyNotification_ForumReply
    FOREIGN KEY (ForumReply_created_at, ForumReply_User_email)
    REFERENCES ForumReply(created_at , User_email )
    ON DELETE SET NULL);
-- -----------------------------------------------------
-- Table Speciality
-- -----------------------------------------------------
CREATE  TABLE  Speciality (
  name VARCHAR(255) NOT NULL ,
  PRIMARY KEY (name) );

-- -----------------------------------------------------
-- Table SpecialityLookup
-- -----------------------------------------------------
CREATE  TABLE  SpecialityLookup (
  fn_from INT NOT NULL ,
  fn_to INT NOT NULL ,
  Speciality_name VARCHAR(255) NOT NULL ,
  PRIMARY KEY (fn_from, fn_to, Speciality_name) ,
  CONSTRAINT fk_SpecialityLookup_Speciality
    FOREIGN KEY (Speciality_name )
    REFERENCES Speciality (name )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX fk_SpecialityLookup_Speciality ON SpecialityLookup (Speciality_name ASC) ;
