set schema FN71100_71012;

DROP FUNCTION FN71100_71012.get_speciality;
DROP FUNCTION FN71100_71012.count_speciality_students;

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
set schema FN71100_71012;
INSERT INTO User 
 VALUES('ivan@abv.bg', 'Ivan', 'Ivanov', 'ivanivanov123');
INSERT INTO User 
 VALUES('dragan@abv.bg', 'Dragan', 'Ivanov', 'draganivanov123');
INSERT INTO User 
 VALUES('petkan@abv.bg', 'Petkan', 'Draganov', '12345678a');
INSERT INTO User 
 VALUES('ilian@yahoo.com', 'ilian', 'Simeonov', 'abcdefg1234');
INSERT INTO User 
 VALUES('simeon@yahoo.com', 'Simeon', 'Simeonov', 'asdasd23');
INSERT INTO User 
 VALUES('nikola@yahoo.com', 'Nikola', 'Simeonov', 'sasda23');
INSERT INTO User 
 VALUES('violeta@yahoo.com', 'Violeta', 'Simeonova', 'simeosd3');
INSERT INTO User 
 VALUES('nikoleta@yahoo.com', 'Nikoleta', 'Ilieva', 'sdghrd23');
INSERT INTO User 
 VALUES('ivanka@yahoo.com', 'Ivanka', 'Ilieva', 'sduyfd23');
INSERT INTO User 
 VALUES('petia@yahoo.com', 'Petia', 'Djurdjeva', '23423frr');
INSERT INTO User 
 VALUES('maria@yahoo.com', 'Maria', 'Radeva', 'siuerh33');
INSERT INTO User 
 VALUES('elena@yahoo.com', 'Elena', 'Petkova', 'dheg77dshg');
INSERT INTO User 
 VALUES('dimitar@yahoo.com', 'Dimitar', 'Dimitrov', 'k_jdeh78sd');
INSERT INTO User 
 VALUES('emil@yahoo.com', 'Emil', 'Dinev', 'kjdeh78s_d');
INSERT INTO User 
 VALUES('dinko@yahoo.com', 'Dinko', 'Gospodinov', 'kjdeh7_8sd');
INSERT INTO User 
 VALUES('valentin@yahoo.com', 'Valentin', 'Dinkov', 'kjd_eh78sd');
INSERT INTO Studentprofile 
 VALUES(70041, 'ivan@abv.bg');
INSERT INTO Studentprofile 
 VALUES(70042, 'dragan@abv.bg');
INSERT INTO Studentprofile 
 VALUES(70043, 'petkan@abv.bg');
INSERT INTO Studentprofile 
 VALUES(70044, 'ilian@yahoo.com');
INSERT INTO Studentprofile 
 VALUES(70045, 'simeon@yahoo.com');
INSERT INTO Studentprofile 
 VALUES(71046, 'nikola@yahoo.com');
INSERT INTO Studentprofile 
 VALUES(71047, 'violeta@yahoo.com');
INSERT INTO Studentprofile 
 VALUES(71048, 'nikoleta@yahoo.com');
INSERT INTO Teacherprofile 
 VALUES('dr', 'valentin@yahoo.com');
INSERT INTO Teacherprofile 
 VALUES(NULL, 'dinko@yahoo.com');
INSERT INTO Teacherprofile 
 VALUES(NULL, 'emil@yahoo.com');
INSERT INTO Teacherprofile 
 VALUES('professor', 'dimitar@yahoo.com');
INSERT INTO Teacherprofile 
 VALUES('professor', 'elena@yahoo.com');
INSERT INTO Teacherprofile 
 VALUES('professor', 'maria@yahoo.com');
INSERT INTO Teacherprofile 
 VALUES(NULL, 'petia@yahoo.com');
INSERT INTO Teacherprofile 
 VALUES(NULL, 'ivanka@yahoo.com');
INSERT INTO Category 
 VALUES('mathematics');
INSERT INTO Category 
 VALUES('computer science');
INSERT INTO Category 
 VALUES('informatics');
INSERT INTO Category 
 VALUES('humanitarian');
INSERT INTO Category 
 VALUES('logic');
INSERT INTO Course 
 VALUES('Not Classical Logics For Artificial Intelligence', 2010, 'logic', 'passlogic', 3, 'dimitar@yahoo.com');
INSERT INTO Course 
 VALUES('Set Theory', 2010, 'mathematics', 'passsetth', 73, 'valentin@yahoo.com');
INSERT INTO Course 
 VALUES('Python', 2009, 'informatics', 'pass', 2, 'dinko@yahoo.com');
INSERT INTO Course 
 VALUES('Ruby on Rails', 2008, NULL, NULL, 44, 'petia@yahoo.com');
INSERT INTO Course 
 VALUES('Algebra', 2010, 'mathematics', 'passalgebra', 33, 'elena@yahoo.com');
INSERT INTO Forumthread (created_at,Course_name,Course_year,title,body)
 VALUES(TIMESTAMP('2010-05-17 13:16:23'), 'Not Classical Logics For Artificial Intelligence', 2010, 'Test title of thread', 'Test body of thread');
INSERT INTO Forumthread (created_at,Course_name,Course_year,title,body)
 VALUES(TIMESTAMP('2010-05-17 13:16:31'), 'Set Theory', 2010, 'Another title', 'This is some small body with a question or something.');
INSERT INTO Forumthread (created_at,Course_name,Course_year,title,body)
 VALUES(TIMESTAMP('2010-05-17 13:16:34'), 'Not Classical Logics For Artificial Intelligence', 2010, 'Test title of thread 2', 'Test body of thread 2');
INSERT INTO Forumthread (created_at,Course_name,Course_year,title,body)
 VALUES(TIMESTAMP('2010-05-17 13:16:37'), 'Python', 2009, 'Test title of thread 3', 'Test body of thread 3');
INSERT INTO Forumreply (User_email,created_at,ForumThread_created_at,ForumThread_title,ForumReply_created_at,ForumReply_User_email,title,body,num_likes,num_edits)
 VALUES('valentin@yahoo.com', TIMESTAMP('2010-05-17 13:46:49'), TIMESTAMP('2010-05-17 13:16:23'), 'Test title of thread', NULL, NULL, 'arch - wireless', 'Hey, new archer here!!! Yesterday I installed arch 64bit and after doing some configuration tricks, Im still left with a couple of issues. 1. No wireless networks founeITs an usb wifi card - (works out of the box in slackware-current on the same laptop).', 4, 1);
INSERT INTO Forumreply (User_email,created_at,ForumThread_created_at,ForumThread_title,ForumReply_created_at,ForumReply_User_email,title,body,num_likes,num_edits)
 VALUES('dinko@yahoo.com', TIMESTAMP('2010-05-17 13:19:41'), TIMESTAMP('2010-05-17 13:16:31'), 'Another title', NULL, NULL, 'Hi Archers... :) Is it difficult to create a LiveArch...?', 'Hi there everybody I wish to create a Live Lightweight Arch Distro, packed with stuff compiled from source, mostly engineering apps...Is this "Mission Impossible", or Just "Mission difficult"...Tried to use Knoppix for that... there are rather well detailed Howtos in Google... but, as I was trying to set up the environment to build my own stuff from source, the libs and all, Synaptic said some of them were not Installable... although it installed some stuff ...I was using the LiveCD... to start from a minimal base... is this a LiceCD issue, or is it to be expected in the LiveDVD also... ? Happened with the 6.3 Knoppix... So I wanna try Arch...Shylock made a nice Live distro, ArchBang, but it cannot be remastered and rebuilt so as to create an Iso and burn it into a CD (DVD ) with all the stuff that I want to put in there... can it...? Think of it as my "Lightweight" B-52, ROFL , as ArchBang would be a sort of Lightweight F23 Raptor... BRGDS Alex', 2, 0);
INSERT INTO Forumreply (User_email,created_at,ForumThread_created_at,ForumThread_title,ForumReply_created_at,ForumReply_User_email,title,body,num_likes,num_edits)
 VALUES('elena@yahoo.com', TIMESTAMP('2010-05-17 13:22:32'), TIMESTAMP('2010-05-17 13:16:23'), 'Test title of thread', TIMESTAMP('2010-05-17 13:46:49'), 'valentin@yahoo.com', 'Problems after changing controlling boot distro', 'Hello, I have 2 500gb drives. Arch used to be /dev/sda1 with /home on /dev/sda6. I have decided to hook up both my drives and now I have PClinux on /dev/sda1 with the home on /dev/sda6. I setup grub on PClinux to boot Arch on /dev/sdb1 without issue. Now the problem I have is when I boot Arch everything goes fine until I login as user. It gives some sort of cant find HOME= defaulting to default (home is on /dev/sdb6). I cant start X or anything. Anyone have any ideas without doing a re-install?', 3, 2);
INSERT INTO Forumreply (User_email,created_at,ForumThread_created_at,ForumThread_title,ForumReply_created_at,ForumReply_User_email,title,body,num_likes,num_edits)
 VALUES('petkan@abv.bg', TIMESTAMP('2010-05-17 13:27:15'), TIMESTAMP('2010-05-17 13:16:23'), 'Test title of thread', TIMESTAMP('2010-05-17 13:22:32'), 'elena@yahoo.com', 'Im thinking I am having permission problems with oblogout and openbox in arch.', 'I am currently running Arch with openbox. I have setup oblogout, but the only buttons that work are Logout and cancel. I cant get shutdown, reboot, suspend, or lock to work. Any ideas?', 0, 9);
INSERT INTO Enrollment 
 VALUES('ivan@abv.bg', 'Not Classical Logics For Artificial Intelligence', 2010);
INSERT INTO Enrollment 
 VALUES('dragan@abv.bg', 'Set Theory', 2010);
INSERT INTO Enrollment 
 VALUES('petkan@abv.bg', 'Not Classical Logics For Artificial Intelligence', 2010);
INSERT INTO Enrollment 
 VALUES('ilian@yahoo.com', 'Set Theory', 2010);
INSERT INTO Enrollment 
 VALUES('simeon@yahoo.com', 'Set Theory', 2010);
INSERT INTO Enrollment 
 VALUES('nikola@yahoo.com', 'Not Classical Logics For Artificial Intelligence', 2010);
INSERT INTO Enrollment 
 VALUES('violeta@yahoo.com', 'Python', 2009);
INSERT INTO Enrollment 
 VALUES('nikoleta@yahoo.com', 'Python', 2009);
INSERT INTO Coursegrade 
 VALUES(4, 'ivan@abv.bg', 'Not Classical Logics For Artificial Intelligence', 2010);
INSERT INTO Coursegrade 
 VALUES(5, 'dragan@abv.bg', 'Set Theory', 2010);
INSERT INTO Coursegrade 
 VALUES(4, 'petkan@abv.bg', 'Not Classical Logics For Artificial Intelligence', 2010);
INSERT INTO Coursegrade 
 VALUES(6, 'ilian@yahoo.com', 'Set Theory', 2010);
INSERT INTO Coursegrade 
 VALUES(6, 'simeon@yahoo.com', 'Set Theory', 2010);
INSERT INTO Coursegrade 
 VALUES(4, 'nikola@yahoo.com', 'Not Classical Logics For Artificial Intelligence', 2010);
INSERT INTO Coursegrade 
 VALUES(6, 'violeta@yahoo.com', 'Python', 2009);
INSERT INTO Coursegrade 
 VALUES(6, 'nikoleta@yahoo.com', 'Python', 2009);
INSERT INTO Rating (value,Course_name,Course_year,StudentProfile_User_email,TeacherProfile_User_email)
 VALUES(10, 'Not Classical Logics For Artificial Intelligence', 2010, 'ivan@abv.bg', 'dimitar@yahoo.com');
INSERT INTO Rating (value,Course_name,Course_year,StudentProfile_User_email,TeacherProfile_User_email)
 VALUES(10, 'Not Classical Logics For Artificial Intelligence', 2010, 'petkan@abv.bg', 'dimitar@yahoo.com');
INSERT INTO Rating (value,Course_name,Course_year,StudentProfile_User_email,TeacherProfile_User_email)
 VALUES(9, 'Not Classical Logics For Artificial Intelligence', 2010, 'nikola@yahoo.com', 'dimitar@yahoo.com');
INSERT INTO Rating (value,Course_name,Course_year,StudentProfile_User_email,TeacherProfile_User_email)
 VALUES(9, 'Set Theory', 2010, 'dragan@abv.bg', 'valentin@yahoo.com');
INSERT INTO Rating (value,Course_name,Course_year,StudentProfile_User_email,TeacherProfile_User_email)
 VALUES(8, 'Set Theory', 2010, 'ilian@yahoo.com', 'valentin@yahoo.com');
INSERT INTO Rating (value,Course_name,Course_year,StudentProfile_User_email,TeacherProfile_User_email)
 VALUES(10, 'Set Theory', 2010, 'simeon@yahoo.com', 'valentin@yahoo.com');
INSERT INTO Rating (value,Course_name,Course_year,StudentProfile_User_email,TeacherProfile_User_email)
 VALUES(10, 'Python', 2009, 'violeta@yahoo.com', 'dinko@yahoo.com');
INSERT INTO Rating (value,Course_name,Course_year,StudentProfile_User_email,TeacherProfile_User_email)
 VALUES(10, 'Python', 2009, 'nikoleta@yahoo.com', 'maria@yahoo.com');
INSERT INTO Assignment (title,description,deadline,max_points,Course_name,Course_year,TeacherProfile_User_email,created_at)
 VALUES('Test assignment 1', 'Description of test assignment 1', TIMESTAMP('2010-06-17 12:35:43'), 6, 'Python', 2009, 'dinko@yahoo.com', TIMESTAMP('2010-05-17 12:38:00'));
INSERT INTO Assignment (title,description,deadline,max_points,Course_name,Course_year,TeacherProfile_User_email,created_at)
 VALUES('Test assignment 2', 'Description of test assignment 2', TIMESTAMP('2010-07-17 12:35:43'), 6, 'Python', 2009, 'dinko@yahoo.com', TIMESTAMP('2010-06-17 12:38:00'));
INSERT INTO Assignment (title,description,deadline,max_points,Course_name,Course_year,TeacherProfile_User_email,created_at)
 VALUES('Test assignment 3', 'Description of test assignment 3', TIMESTAMP('2010-07-27 12:35:43'), 10, 'Set Theory', 2010, 'valentin@yahoo.com', TIMESTAMP('2010-06-27 12:38:00'));
INSERT INTO Assignmentgrade (value,StudentProfile_User_email,Assignment_title,Assignment_Course_name,Assignment_Course_year)
 VALUES(4, 'violeta@yahoo.com', 'Test assignment 1', 'Python', 2009);
INSERT INTO Assignmentgrade (value,StudentProfile_User_email,Assignment_title,Assignment_Course_name,Assignment_Course_year)
 VALUES(5, 'nikoleta@yahoo.com', 'Test assignment 1', 'Python', 2009);
INSERT INTO Assignmentgrade (value,StudentProfile_User_email,Assignment_title,Assignment_Course_name,Assignment_Course_year)
 VALUES(6, 'violeta@yahoo.com', 'Test assignment 2', 'Python', 2009);
INSERT INTO Assignmentgrade (value,StudentProfile_User_email,Assignment_title,Assignment_Course_name,Assignment_Course_year)
 VALUES(5, 'nikoleta@yahoo.com', 'Test assignment 2', 'Python', 2009);
INSERT INTO Assignmentgrade (value,StudentProfile_User_email,Assignment_title,Assignment_Course_name,Assignment_Course_year)
 VALUES(8, 'dragan@abv.bg', 'Test assignment 3', 'Set Theory', 2010);
INSERT INTO Assignmentgrade (value,StudentProfile_User_email,Assignment_title,Assignment_Course_name,Assignment_Course_year)
 VALUES(8, 'ilian@yahoo.com', 'Test assignment 3', 'Set Theory', 2010);
INSERT INTO Assignmentgrade (value,StudentProfile_User_email,Assignment_title,Assignment_Course_name,Assignment_Course_year)
 VALUES(9, 'simeon@yahoo.com', 'Test assignment 3', 'Set Theory', 2010);
INSERT INTO Courseotherteachers (TeacherProfile_User_email,Course_name,Course_year)
 VALUES('maria@yahoo.com', 'Python', 2009);
INSERT INTO News (created_at,Course_name,Course_year,TeacherProfile_User_email,title,body)
 VALUES(TIMESTAMP('2010-05-17 13:15:27'), 'Not Classical Logics For Artificial Intelligence', 2010, 'dimitar@yahoo.com', 'Test logic news 1', 'Test logic news 1. Content of the news');
INSERT INTO News (created_at,Course_name,Course_year,TeacherProfile_User_email,title,body)
 VALUES(TIMESTAMP('2010-05-27 13:15:31'), 'Not Classical Logics For Artificial Intelligence', 2010, 'dimitar@yahoo.com', 'Test logic news 2', 'Test logic news 2. Content of the news');
INSERT INTO News (created_at,Course_name,Course_year,TeacherProfile_User_email,title,body)
 VALUES(TIMESTAMP('2010-04-14 13:15:34'), 'Python', 2009, 'dinko@yahoo.com', 'Test python news 1', 'Test python news 1. Content of the news.');
INSERT INTO Speciality 
 VALUES('Informatics');
INSERT INTO Speciality 
 VALUES('Computer Science');
INSERT INTO Speciality 
 VALUES('Mathematics');
INSERT INTO Speciality 
 VALUES('Applied Mathematics');
INSERT INTO Specialitylookup (fn_from,fn_to,Speciality_name)
 VALUES(70000, 70999, 'Informatics');
INSERT INTO Specialitylookup (fn_from,fn_to,Speciality_name)
 VALUES(71000, 71999, 'Computer Science');
set schema FN71100_71012;
--CREATE TRIGGER tr_forumreply_notify AFTER INSERT ON ForumReply
--REFERENCING
--	NEW AS N_ROW
--	FOR EACH ROW
--	INSERT INTO ForumReplyNotification(body,  ForumReply_created_at, ForumReply_User_email)
--	VALUES ('New reply ' CONCAT N_ROW.title CONCAT ' was added to the forum of course ' CONCAT N_ROW.course_name CONCAT '!', N_ROW.title, N_ROW.course_name, N_ROW.course_year);
-- drop trigger tr_new_assignment_notify;
-- drop trigger tr_deleted_assignment_notify;
-- drop trigger tr_enrollment_new_count;
-- drop trigger tr_enrollment_delete_count;

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
