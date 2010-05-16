set schema "fn71100_71012"

-- -----------------------------------------------------
-- Table "User"
-- -----------------------------------------------------
CREATE  TABLE  "User" (
  "email" VARCHAR(255) NOT NULL ,
  "first_name" VARCHAR(45) NOT NULL ,
  "last_name" VARCHAR(45) NOT NULL ,
  "password" VARCHAR(45) NOT NULL ,
  PRIMARY KEY ("email") );

drop table "StudentProfile";

-- -----------------------------------------------------
-- Table "StudentProfile"
-- -----------------------------------------------------
CREATE  TABLE  "StudentProfile" (
  "faculty_number" INT NOT NULL ,
  "User_email" VARCHAR(255) NOT NULL ,
  PRIMARY KEY ("User_email") ,
  CONSTRAINT "fk_StudentProfile_User"
    FOREIGN KEY ("User_email" )
    REFERENCES "User" ("email" )
    ON DELETE CASCADE
    ON UPDATE RESTRICT
    );

CREATE INDEX "fk_StudentProfile_User" ON "StudentProfile" ("User_email" ASC) ;

drop table "TeacherProfile";
-- -----------------------------------------------------
-- Table "TeacherProfile"
-- -----------------------------------------------------
CREATE  TABLE  "TeacherProfile" (
  "title" VARCHAR(45),
  "User_email" VARCHAR(255) NOT NULL,
  PRIMARY KEY ("User_email") ,
  CONSTRAINT "fk_TeacherProfile_User"
    FOREIGN KEY ("User_email" )
    REFERENCES "User" ("email" )
    ON DELETE CASCADE
    );


-- -----------------------------------------------------
-- Table "Category"
-- -----------------------------------------------------
CREATE  TABLE  "Category" (
  "name" VARCHAR(45) NOT NULL ,
  PRIMARY KEY ("name") )

drop table "Course";
-- -----------------------------------------------------
-- Table "Course"
-- -----------------------------------------------------
CREATE  TABLE  "Course" (
  "name" VARCHAR(255) NOT NULL ,
  "year" SMALLINT NOT NULL ,
  "Category_name" VARCHAR(45) ,
  "password" VARCHAR(45),
  "numEnrolled" INT NOT NULL DEFAULT 0 ,
  "TeacherProfile_User_email" VARCHAR(255) NOT NULL ,
  PRIMARY KEY ("name", "year"),
  CONSTRAINT "fk_Course_Category"
    FOREIGN KEY ("Category_name" )
    REFERENCES "Category" ("name")
    ON DELETE SET NULL,
  CONSTRAINT "fk_Course_TeacherProfile"
    FOREIGN KEY ("TeacherProfile_User_email" )
    REFERENCES "TeacherProfile" ("User_email" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX "fk_Course_Category" ON "Course" ("Category_name" ASC) ;

CREATE INDEX "fk_Course_TeacherProfile" ON "Course" ("TeacherProfile_User_email" ASC) ;

-- -----------------------------------------------------
-- Table "ForumReply"
-- -----------------------------------------------------
CREATE  TABLE  "FN71100_71012"."ForumReply" (
  "ForumReply_created_at" TIMESTAMP NOT NULL ,
  "ForumReply_User_email" VARCHAR(255) NOT NULL ,
  "ForumThread_ForumReply_created_at" TIMESTAMP NOT NULL ,
  "ForumThread_ForumReply_User_email" VARCHAR(255) NOT NULL ,
  "created_at" TIMESTAMP NOT NULL ,
  "title" VARCHAR(45) NOT NULL ,
  "body" VARCHAR(16352) NOT NULL ,
  "num_likes" INT NOT NULL DEFAULT 0 , --unsigned
  "User_email" VARCHAR(255) NOT NULL ,
  "num_edits" INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY ("created_at", "User_email") ,
  CONSTRAINT "fk_ForumReply_User"
    FOREIGN KEY ("User_email" )
    REFERENCES "User" ("email" )
    ON DELETE SET NULL,
  CONSTRAINT "fk_ForumReply_ForumReply"
    FOREIGN KEY ("ForumReply_created_at" , "ForumReply_User_email" )
    REFERENCES "FN71100_71012"."ForumReply" ("created_at" , "User_email" )
    ON DELETE CASCADE,
  CONSTRAINT "fk_ForumReply_ForumThread"
    FOREIGN KEY ("ForumThread_ForumReply_created_at" , "ForumThread_ForumReply_User_email" )
    REFERENCES "FN71100_71012"."ForumThread" ("ForumReply_created_at" , "ForumReply_User_email" )
    ON DELETE CASCADE
    );

-- -----------------------------------------------------
-- Table "ForumThread"
-- -----------------------------------------------------
CREATE  TABLE  "ForumThread" (
  "ForumReply_created_at" TIMESTAMP NOT NULL ,
  "ForumReply_User_email" VARCHAR(255) NOT NULL ,
  "Course_name" VARCHAR(255) NOT NULL ,
  "Course_year" SMALLINT NOT NULL ,
  PRIMARY KEY ("ForumReply_created_at", "ForumReply_User_email") ,
  CONSTRAINT "fk_ForumThread_ForumReply"
    FOREIGN KEY ("ForumReply_created_at" )
    REFERENCES "FN71100_71012"."ForumReply" ("created_at" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_ForumThread_Course"
    FOREIGN KEY ("Course_name" , "Course_year" )
    REFERENCES "Course" ("name" , "year" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE INDEX "fk_ForumThread_ForumReply" ON "ForumThread" ("ForumReply_created_at" ASC, "ForumReply_User_email" ASC) ;

CREATE INDEX "fk_ForumThread_Course" ON "ForumThread" ("Course_name" ASC, "Course_year" ASC) ;

drop table "ForumReply";




CREATE INDEX "fk_ForumReply_User" ON "ForumReply" ("User_email" ASC) ;

CREATE INDEX "fk_ForumReply_ForumReply" ON "ForumReply" ("ForumReply_created_at" ASC, "ForumReply_User_email" ASC) ;

CREATE INDEX "fk_ForumReply_ForumThread" ON "ForumReply" ("ForumThread_ForumReply_created_at" ASC, "ForumThread_ForumReply_User_email" ASC) ;


-- -----------------------------------------------------
-- Table "Enrollment"
-- -----------------------------------------------------
CREATE  TABLE  "Enrollment" (
  "StudentProfile_User_email" VARCHAR(255) NOT NULL ,
  "Course_name" VARCHAR(255) NOT NULL ,
  "Course_year" SMALLINT NOT NULL ,
  PRIMARY KEY ("StudentProfile_User_email", "Course_name", "Course_year") ,
  CONSTRAINT "fk_Enrollment_StudentProfile"
    FOREIGN KEY ("StudentProfile_User_email" )
    REFERENCES "StudentProfile" ("User_email" )
    ON DELETE CASCADE
    ,
  CONSTRAINT "fk_Enrollment_Course"
    FOREIGN KEY ("Course_name" , "Course_year" )
    REFERENCES "Course" ("name" , "year" )
    ON DELETE CASCADE
    )

CREATE INDEX "fk_Enrollment_StudentProfile" ON "Enrollment" ("StudentProfile_User_email" ASC) ;

CREATE INDEX "fk_Enrollment_Course" ON "Enrollment" ("Course_name" ASC, "Course_year" ASC) ;


-- -----------------------------------------------------
-- Table "CourseGrade"
-- -----------------------------------------------------
CREATE  TABLE  "CourseGrade" (
  "value" SMALLINT UNSIGNED NOT NULL DEFAULT 0 ,
  "StudentProfile_User_email" VARCHAR(255) NOT NULL ,
  "Course_name" VARCHAR(255) NOT NULL ,
  "Course_year" SMALLINT NOT NULL ,
  PRIMARY KEY ("StudentProfile_User_email", "Course_name", "Course_year") ,
  CONSTRAINT "fk_CourseGrade_StudentProfile"
    FOREIGN KEY ("StudentProfile_User_email" )
    REFERENCES "StudentProfile" ("User_email" )
    ON DELETE CASCADE
    ,
  CONSTRAINT "fk_CourseGrade_Course"
    FOREIGN KEY ("Course_name" , "Course_year" )
    REFERENCES "Course" ("name" , "year" )
    ON DELETE CASCADE
    )

CREATE INDEX "fk_CourseGrade_StudentProfile" ON "CourseGrade" ("StudentProfile_User_email" ASC) ;

CREATE INDEX "fk_CourseGrade_Course" ON "CourseGrade" ("Course_name" ASC, "Course_year" ASC) ;


-- -----------------------------------------------------
-- Table "Rating"
-- -----------------------------------------------------
CREATE  TABLE  "Rating" (
  "value" SMALLINT UNSIGNED NOT NULL ,
  "Course_name" VARCHAR(255) NOT NULL ,
  "Course_year" SMALLINT NOT NULL ,
  "StudentProfile_User_email" VARCHAR(255) NOT NULL ,
  "TeacherProfile_User_email" VARCHAR(255) NOT NULL ,
  PRIMARY KEY ("Course_name", "Course_year", "StudentProfile_User_email", "TeacherProfile_User_email") ,
  CONSTRAINT "fk_Rating_Course"
    FOREIGN KEY ("Course_name" , "Course_year" )
    REFERENCES "Course" ("name" , "year" )
    ON DELETE CASCADE
    ,
  CONSTRAINT "fk_Rating_StudentProfile"
    FOREIGN KEY ("StudentProfile_User_email" )
    REFERENCES "StudentProfile" ("User_email" )
    ON DELETE CASCADE
    ,
  CONSTRAINT "fk_Rating_TeacherProfile1"
    FOREIGN KEY ("TeacherProfile_User_email" )
    REFERENCES "TeacherProfile" ("User_email" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

CREATE INDEX "fk_Rating_Course" ON "Rating" ("Course_name" ASC, "Course_year" ASC) ;

CREATE INDEX "fk_Rating_StudentProfile" ON "Rating" ("StudentProfile_User_email" ASC) ;

CREATE INDEX "fk_Rating_TeacherProfile1" ON "Rating" ("TeacherProfile_User_email" ASC) ;


-- -----------------------------------------------------
-- Table "Assignment"
-- -----------------------------------------------------
CREATE  TABLE  "Assignment" (
  "title" VARCHAR(255) NOT NULL ,
  "description" MEDIUMTEXT NOT NULL ,
  "deadline" TIMESTAMP NULL ,
  "max_points" SMALLINT UNSIGNED NOT NULL ,
  "Course_name" VARCHAR(255) NOT NULL ,
  "Course_year" SMALLINT NOT NULL ,
  "TeacherProfile_User_email" VARCHAR(255) NOT NULL ,
  "created_at" VARCHAR(45) NULL ,
  "TeacherProfile_User_email1" VARCHAR(255) NOT NULL ,
  PRIMARY KEY ("title", "Course_name", "Course_year") ,
  CONSTRAINT "fk_Assignment_Course"
    FOREIGN KEY ("Course_name" , "Course_year" )
    REFERENCES "Course" ("name" , "year" )
    ON DELETE CASCADE
    ,
  CONSTRAINT "fk_Assignment_TeacherProfile1"
    FOREIGN KEY ("TeacherProfile_User_email1" )
    REFERENCES "TeacherProfile" ("User_email" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

CREATE INDEX "fk_Assignment_Course" ON "Assignment" ("Course_name" ASC, "Course_year" ASC) ;

CREATE INDEX "fk_Assignment_TeacherProfile1" ON "Assignment" ("TeacherProfile_User_email1" ASC) ;


-- -----------------------------------------------------
-- Table "AssignmentGrade"
-- -----------------------------------------------------
CREATE  TABLE  "AssignmentGrade" (
  "value" SMALLINT UNSIGNED NOT NULL ,
  "StudentProfile_faculty_number" INT NOT NULL ,
  "StudentProfile_User_email" VARCHAR(255) NOT NULL ,
  "Assignment_title" VARCHAR(255) NOT NULL ,
  "Assignment_Course_name" VARCHAR(255) NOT NULL ,
  "Assignment_Course_year" SMALLINT NOT NULL ,
  PRIMARY KEY ("StudentProfile_faculty_number", "StudentProfile_User_email", "Assignment_title", "Assignment_Course_name", "Assignment_Course_year") ,
  CONSTRAINT "fk_AssignmentGrade_StudentProfile"
    FOREIGN KEY ("StudentProfile_faculty_number" )
    REFERENCES "StudentProfile" ("faculty_number" )
    ON DELETE CASCADE
    ,
  CONSTRAINT "fk_AssignmentGrade_Assignment"
    FOREIGN KEY ("Assignment_title" , "Assignment_Course_name" , "Assignment_Course_year" )
    REFERENCES "Assignment" ("title" , "Course_name" , "Course_year" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

CREATE INDEX "fk_AssignmentGrade_StudentProfile" ON "AssignmentGrade" ("StudentProfile_faculty_number" ASC, "StudentProfile_User_email" ASC) ;

CREATE INDEX "fk_AssignmentGrade_Assignment" ON "AssignmentGrade" ("Assignment_title" ASC, "Assignment_Course_name" ASC, "Assignment_Course_year" ASC) ;


-- -----------------------------------------------------
-- Table "CourseOtherTeachers"
-- -----------------------------------------------------
CREATE  TABLE  "CourseOtherTeachers" (
  "TeacherProfile_User_email" VARCHAR(255) NOT NULL ,
  "Course_name" VARCHAR(255) NOT NULL ,
  "Course_year" SMALLINT NOT NULL ,
  PRIMARY KEY ("TeacherProfile_User_email", "Course_name", "Course_year") ,
  CONSTRAINT "fk_CourseOtherTeachers_TeacherProfile"
    FOREIGN KEY ("TeacherProfile_User_email" )
    REFERENCES "TeacherProfile" ("User_email" )
    ON DELETE CASCADE
    ,
  CONSTRAINT "fk_CourseOtherTeachers_Course"
    FOREIGN KEY ("Course_name" , "Course_year" )
    REFERENCES "Course" ("name" , "year" )
    ON DELETE CASCADE
    )

CREATE INDEX "fk_CourseOtherTeachers_TeacherProfile" ON "CourseOtherTeachers" ("TeacherProfile_User_email" ASC) ;

CREATE INDEX "fk_CourseOtherTeachers_Course" ON "CourseOtherTeachers" ("Course_name" ASC, "Course_year" ASC) ;


-- -----------------------------------------------------
-- Table "News"
-- -----------------------------------------------------
CREATE  TABLE  "News" (
  "created_at" TIMESTAMP NOT NULL ,
  "Course_name" VARCHAR(255) NOT NULL ,
  "Course_year" SMALLINT NOT NULL ,
  "TeacherProfile_User_email" VARCHAR(255) NOT NULL ,
  PRIMARY KEY ("created_at", "TeacherProfile_User_email") ,
  CONSTRAINT "fk_News_Course"
    FOREIGN KEY ("Course_name" , "Course_year" )
    REFERENCES "Course" ("name" , "year" )
    ON DELETE CASCADE
    ,
  CONSTRAINT "fk_News_TeacherProfile"
    FOREIGN KEY ("TeacherProfile_User_email" )
    REFERENCES "TeacherProfile" ("User_email" )
    ON DELETE SET NULL
    )

CREATE INDEX "fk_News_Course" ON "News" ("Course_name" ASC, "Course_year" ASC) ;

CREATE INDEX "fk_News_TeacherProfile" ON "News" ("TeacherProfile_User_email" ASC) ;


-- -----------------------------------------------------
-- Table "AssignmentFile"
-- -----------------------------------------------------
CREATE  TABLE  "AssignmentFile" (
  "path" MEDIUMTEXT NOT NULL ,
  "name" VARCHAR(255) NULL ,
  "Assignment_title" VARCHAR(255) NOT NULL ,
  "Assignment_Course_name" VARCHAR(255) NOT NULL ,
  "Assignment_Course_year" SMALLINT NOT NULL ,
  PRIMARY KEY ("path") ,
  CONSTRAINT "fk_AssignmentFile_Assignment"
    FOREIGN KEY ("Assignment_title" , "Assignment_Course_name" , "Assignment_Course_year" )
    REFERENCES "Assignment" ("title" , "Course_name" , "Course_year" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

CREATE INDEX "fk_AssignmentFile_Assignment" ON "AssignmentFile" ("Assignment_title" ASC, "Assignment_Course_name" ASC, "Assignment_Course_year" ASC) ;


-- -----------------------------------------------------
-- Table "Resource"
-- -----------------------------------------------------
CREATE  TABLE  "Resource" (
  "id" INT NOT NULL AUTO_INCREMENT ,
  "created_at" TIMESTAMP NOT NULL ,
  "description" MEDIUMTEXT NOT NULL ,
  "Course_name" VARCHAR(255) NOT NULL ,
  "Course_year" SMALLINT NOT NULL ,
  PRIMARY KEY ("id") ,
  CONSTRAINT "fk_Resource_Course"
    FOREIGN KEY ("Course_name" , "Course_year" )
    REFERENCES "Course" ("name" , "year" )
    ON DELETE CASCADE
    )

CREATE INDEX "fk_Resource_Course" ON "Resource" ("Course_name" ASC, "Course_year" ASC) ;


-- -----------------------------------------------------
-- Table "ResourceFile"
-- -----------------------------------------------------
CREATE  TABLE  "ResourceFile" (
  "path" MEDIUMTEXT NOT NULL ,
  "name" VARCHAR(255) NULL ,
  "Resource_id" INT NOT NULL ,
  PRIMARY KEY ("path") ,
  CONSTRAINT "fk_ResourceFile_Resource"
    FOREIGN KEY ("Resource_id" )
    REFERENCES "Resource" ("id" )
    ON DELETE CASCADE
    )

CREATE INDEX "fk_ResourceFile_Resource" ON "ResourceFile" ("Resource_id" ASC) ;


-- -----------------------------------------------------
-- Table "AssignmentNotification"
-- -----------------------------------------------------
CREATE  TABLE  "AssignmentNotification" (
  "body" MEDIUMTEXT NOT NULL ,
  "created_at" TIMESTAMP NOT NULL ,
  "id" INT NOT NULL AUTO_INCREMENT ,
  "Assignment_title" VARCHAR(255) NOT NULL ,
  "Assignment_Course_name" VARCHAR(255) NOT NULL ,
  "Assignment_Course_year" SMALLINT NOT NULL ,
  PRIMARY KEY ("id", "Assignment_title", "Assignment_Course_name", "Assignment_Course_year") ,
  CONSTRAINT "fk_AssignmentNotification_Assignment"
    FOREIGN KEY ("Assignment_title" , "Assignment_Course_name" , "Assignment_Course_year" )
    REFERENCES "Assignment" ("title" , "Course_name" , "Course_year" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

CREATE INDEX "fk_AssignmentNotification_Assignment" ON "AssignmentNotification" ("Assignment_title" ASC, "Assignment_Course_name" ASC, "Assignment_Course_year" ASC) ;


-- -----------------------------------------------------
-- Table "CourseNotification"
-- -----------------------------------------------------
CREATE  TABLE  "CourseNotification" (
  "body" MEDIUMTEXT NOT NULL ,
  "created_at" TIMESTAMP NOT NULL ,
  "id" INT NOT NULL AUTO_INCREMENT ,
  "Course_name" VARCHAR(255) NOT NULL ,
  "Course_year" SMALLINT NOT NULL ,
  PRIMARY KEY ("id") ,
  CONSTRAINT "fk_CourseNotification_Course"
    FOREIGN KEY ("Course_name" , "Course_year" )
    REFERENCES "Course" ("name" , "year" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

CREATE INDEX "fk_CourseNotification_Course" ON "CourseNotification" ("Course_name" ASC, "Course_year" ASC) ;


-- -----------------------------------------------------
-- Table "ForumReplyNotification"
-- -----------------------------------------------------
CREATE  TABLE  "ForumReplyNotification" (
  "body" MEDIUMTEXT NOT NULL ,
  "created_at" TIMESTAMP NOT NULL ,
  "id" INT NOT NULL AUTO_INCREMENT ,
  PRIMARY KEY ("id") )


-- -----------------------------------------------------
-- Table "Speciality"
-- -----------------------------------------------------
CREATE  TABLE  "Speciality" (
  "name" VARCHAR(255) NOT NULL ,
  PRIMARY KEY ("name") )


-- -----------------------------------------------------
-- Table "SpecialityLookup"
-- -----------------------------------------------------
CREATE  TABLE  "SpecialityLookup" (
  "fn_from" VARCHAR(45) NOT NULL ,
  "fn_to" VARCHAR(45) NOT NULL ,
  "Speciality_name" VARCHAR(255) NOT NULL ,
  PRIMARY KEY ("fn_from", "fn_to", "Speciality_name") ,
  CONSTRAINT "fk_SpecialityLookup_Speciality1"
    FOREIGN KEY ("Speciality_name" )
    REFERENCES "Speciality" ("name" )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

CREATE INDEX "fk_SpecialityLookup_Speciality1" ON "SpecialityLookup" ("Speciality_name" ASC) ;
