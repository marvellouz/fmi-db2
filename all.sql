set schema FN71100_71012;

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
DROP TABLE  SpecialityLookup ;

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
  TeacherProfile_User_email VARCHAR(255) NOT NULL ,
  PRIMARY KEY (name, year),
  CONSTRAINT fk_Course_Category
    FOREIGN KEY (Category_name )
    REFERENCES Category (name)
    ON DELETE SET NULL,
  CONSTRAINT fk_Course_TeacherProfile
    FOREIGN KEY (TeacherProfile_User_email )
    REFERENCES TeacherProfile (User_email )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX fk_Course_Category ON Course (Category_name ASC) ;

CREATE INDEX fk_Course_TeacherProfile ON Course (TeacherProfile_User_email ASC) ;

-- -----------------------------------------------------
-- Table ForumReply
-- -----------------------------------------------------
CREATE  TABLE  ForumReply (
  User_email VARCHAR(255) NOT NULL ,
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  ForumThread_created_at TIMESTAMP NOT NULL ,
  ForumThread_title VARCHAR(45) NOT NULL ,
  -- parent
  ForumReply_created_at TIMESTAMP,
  ForumReply_User_email VARCHAR(255),
  title VARCHAR(45) NOT NULL ,
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

-- -----------------------------------------------------
-- Table ForumThread
-- -----------------------------------------------------
CREATE  TABLE  ForumThread (
  created_at TIMESTAMP NOT NULL ,
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  title VARCHAR(45) NOT NULL ,
  body VARCHAR(1644) NOT NULL ,
  PRIMARY KEY (created_at, title) ,
  CONSTRAINT fk_ForumThread_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES fn71100_71012.Course (name , year )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

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
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

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
  TeacherProfile_User_email VARCHAR(255) NOT NULL ,
  created_at VARCHAR(45),
  PRIMARY KEY (title, Course_name, Course_year) ,
  CONSTRAINT fk_Assignment_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE CASCADE,
  CONSTRAINT fk_Assignment_TeacherProfile
    FOREIGN KEY (TeacherProfile_User_email )
    REFERENCES TeacherProfile (User_email )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX fk_Assignment_Course ON Assignment (Course_name ASC, Course_year ASC) ;

CREATE INDEX fk_Assignment_TeacherProfile ON Assignment (TeacherProfile_User_email ASC) ;


-- -----------------------------------------------------
-- Table AssignmentGrade
-- -----------------------------------------------------
CREATE  TABLE  AssignmentGrade (
  value SMALLINT NOT NULL , -- unsigned
  StudentProfile_faculty_number INT NOT NULL ,
  StudentProfile_User_email VARCHAR(255) NOT NULL ,
  Assignment_title VARCHAR(255) NOT NULL ,
  Assignment_Course_name VARCHAR(255) NOT NULL ,
  Assignment_Course_year SMALLINT NOT NULL ,
  PRIMARY KEY (StudentProfile_faculty_number, StudentProfile_User_email, Assignment_title, Assignment_Course_name, Assignment_Course_year) ,
  CONSTRAINT fk_AssignmentGrade_StudentProfile
    FOREIGN KEY (StudentProfile_User_email )
    REFERENCES StudentProfile (User_email )
    ON DELETE CASCADE,
  CONSTRAINT fk_AssignmentGrade_Assignment
    FOREIGN KEY (Assignment_title , Assignment_Course_name , Assignment_Course_year )
    REFERENCES Assignment (title , Course_name , Course_year )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX fk_AssignmentGrade_StudentProfile ON AssignmentGrade (StudentProfile_faculty_number ASC, StudentProfile_User_email ASC) ;

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
  Course_year INT NOT NULL ,
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
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

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
  Assignment_title VARCHAR(255) NOT NULL ,
  Assignment_Course_name VARCHAR(255) NOT NULL ,
  Assignment_Course_year SMALLINT NOT NULL ,
  PRIMARY KEY (id, Assignment_title, Assignment_Course_name, Assignment_Course_year) ,
  CONSTRAINT fk_AssignmentNotification_Assignment
    FOREIGN KEY (Assignment_title , Assignment_Course_name , Assignment_Course_year )
    REFERENCES Assignment (title , Course_name , Course_year )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX fk_AssignmentNotification_Assignment ON AssignmentNotification (Assignment_title ASC, Assignment_Course_name ASC, Assignment_Course_year ASC) ;


-- -----------------------------------------------------
-- Table CourseNotification
-- -----------------------------------------------------
CREATE  TABLE  CourseNotification (
  body VARCHAR(6144) NOT NULL ,
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  Course_name VARCHAR(255) NOT NULL ,
  Course_year SMALLINT NOT NULL ,
  PRIMARY KEY (id) ,
  CONSTRAINT fk_CourseNotification_Course
    FOREIGN KEY (Course_name , Course_year )
    REFERENCES Course (name , year )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX fk_CourseNotification_Course ON CourseNotification (Course_name ASC, Course_year ASC) ;

-- -----------------------------------------------------
-- Table ForumReplyNotification
-- -----------------------------------------------------
CREATE  TABLE  ForumReplyNotification (
  body VARCHAR(1644) NOT NULL ,
  created_at TIMESTAMP NOT NULL WITH DEFAULT,
  id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  PRIMARY KEY (id) );

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
  fn_from VARCHAR(45) NOT NULL ,
  fn_to VARCHAR(45) NOT NULL ,
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
 VALUES(70046, 'nikola@yahoo.com');
INSERT INTO Studentprofile
 VALUES(70047, 'violeta@yahoo.com');
INSERT INTO Studentprofile
 VALUES(70048, 'nikoleta@yahoo.com');
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
INSERT INTO Forumreply
 VALUES('valentin@yahoo.com', CURRENT TIMESTAMP, 'simeon@yahoo.com', CURRENT TIMESTAMP, 'violeta@yahoo.com', CURRENT TIMESTAMP, 'arch - wireless', 'Hey, new archer here!!! Yesterday I installed arch 64bit and after doing some configuration tricks, Im still left with a couple of issues. 1. No wireless networks founeITs an usb wifi card - (works out of the box in slackware-current on the same laptop).', 4, 1);
INSERT INTO Forumreply
 VALUES('dinko@yahoo.com', CURRENT TIMESTAMP, 'valentin@yahoo.com', CURRENT TIMESTAMP, 'nikola@yahoo.com', CURRENT TIMESTAMP, 'Hi Archers... :) Is it difficult to create a LiveArch...?', 'Hi there everybody I wish to create a Live Lightweight Arch Distro, packed with stuff compiled from source, mostly engineering apps...Is this "Mission Impossible", or Just "Mission difficult"...Tried to use Knoppix for that... there are rather well detailed Howtos in Google... but, as I was trying to set up the environment to build my own stuff from source, the libs and all, Synaptic said some of them were not Installable... although it installed some stuff ...I was using the LiveCD... to start from a minimal base... is this a LiceCD issue, or is it to be expected in the LiveDVD also... ? Happened with the 6.3 Knoppix... So I wanna try Arch...Shylock made a nice Live distro, ArchBang, but it cannot be remastered and rebuilt so as to create an Iso and burn it into a CD (DVD ) with all the stuff that I want to put in there... can it...? Think of it as my "Lightweight" B-52, ROFL , as ArchBang would be a sort of Lightweight F23 Raptor... BRGDS Alex', 2, 0);
INSERT INTO Forumreply
 VALUES('elena@yahoo.com', CURRENT TIMESTAMP, 'violeta@yahoo.com', CURRENT TIMESTAMP, 'simeon@yahoo.com', CURRENT TIMESTAMP, 'Problems after changing controlling boot distro', 'Hello, I have 2 500gb drives. Arch used to be /dev/sda1 with /home on /dev/sda6. I have decided to hook up both my drives and now I have PClinux on /dev/sda1 with the home on /dev/sda6. I setup grub on PClinux to boot Arch on /dev/sdb1 without issue. Now the problem I have is when I boot Arch everything goes fine until I login as user. It gives some sort of cant find HOME= defaulting to default (home is on /dev/sdb6). I cant start X or anything. Anyone have any ideas without doing a re-install?', 3, 2);
INSERT INTO Forumreply
 VALUES('petkan@abv.bg', CURRENT TIMESTAMP, 'valentin@yahoo.com', CURRENT TIMESTAMP, 'ilian@yahoo.com', CURRENT TIMESTAMP, 'Im thinking I am having permission problems with oblogout and openbox in arch.', 'I am currently running Arch with openbox. I have setup oblogout, but the only buttons that work are Logout and cancel. I cant get shutdown, reboot, suspend, or lock to work. Any ideas?', 5, 9);
INSERT INTO Forumthread
 VALUES(CURRENT TIMESTAMP, 'Not Classical Logics For Artificial Intelligence', 2010, 'Test title of thread', 'Test body of thread');
INSERT INTO Forumthread
 VALUES(CURRENT TIMESTAMP, 'Set Theory', 2010);
INSERT INTO Forumthread
 VALUES(CURRENT TIMESTAMP, 'Not Classical Logics For Artificial Intelligence', 2010, 'Test title of thread 2', 'Test body of thread 2');
INSERT INTO Forumthread
 VALUES(CURRENT TIMESTAMP, 'Python', 2009, 'Test title of thread 3', 'Test body of thread 3');
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


