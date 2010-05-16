set schema `fn71100_71012`;

-- -----------------------------------------------------
-- Table `fn71100_71012`.`User`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`User` (
  `email` VARCHAR(255) NOT NULL ,
  `first_name` VARCHAR(45) NOT NULL ,
  `last_name` VARCHAR(45) NOT NULL ,
  `password` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`email`) )


-- -----------------------------------------------------
-- Table `fn71100_71012`.`StudentProfile`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`StudentProfile` (
  `faculty_number` INT NOT NULL ,
  `User_email` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`User_email`) ,
  INDEX `fk_StudentProfile_User` (`User_email` ASC) ,
  CONSTRAINT `fk_StudentProfile_User`
    FOREIGN KEY (`User_email` )
    REFERENCES `fn71100_71012`.`User` (`email` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`TeacherProfile`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`TeacherProfile` (
  `title` VARCHAR(45) NULL ,
  `User_email` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`User_email`) ,
  INDEX `fk_TeacherProfile_User` (`User_email` ASC) ,
  CONSTRAINT `fk_TeacherProfile_User`
    FOREIGN KEY (`User_email` )
    REFERENCES `fn71100_71012`.`User` (`email` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`Category`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`Category` (
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`name`) )


-- -----------------------------------------------------
-- Table `fn71100_71012`.`Course`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`Course` (
  `name` VARCHAR(255) NOT NULL ,
  `year` SMALLINT NOT NULL ,
  `TeacherProfile_User_email` VARCHAR(255) NOT NULL ,
  `Category_name` VARCHAR(45) NOT NULL ,
  `password` VARCHAR(45) NULL ,
  `numEnrolled` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`name`, `year`) ,
  INDEX `fk_Course_TeacherProfile` (`TeacherProfile_User_email` ASC) ,
  INDEX `fk_Course_Category` (`Category_name` ASC) ,
  CONSTRAINT `fk_Course_TeacherProfile`
    FOREIGN KEY ()
    REFERENCES `fn71100_71012`.`TeacherProfile` ()
  CONSTRAINT `fk_Course_Category`
    FOREIGN KEY (`Category_name` )
    REFERENCES `fn71100_71012`.`Category` (`name` )
    ON DELETE SET NULL
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`ForumThread`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`ForumThread` (
  `ForumReply_created_at` TIMESTAMP NOT NULL ,
  `ForumReply_User_email` VARCHAR(255) NOT NULL ,
  `Course_name` VARCHAR(255) NOT NULL ,
  `Course_year` SMALLINT NOT NULL ,
  INDEX `fk_ForumThread_ForumReply` (`ForumReply_created_at` ASC, `ForumReply_User_email` ASC) ,
  PRIMARY KEY (`ForumReply_created_at`, `ForumReply_User_email`) ,
  INDEX `fk_ForumThread_Course` (`Course_name` ASC, `Course_year` ASC) ,
  CONSTRAINT `fk_ForumThread_ForumReply`
    FOREIGN KEY (`ForumReply_created_at` )
    REFERENCES `fn71100_71012`.`ForumReply` (`created_at` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ForumThread_Course`
    FOREIGN KEY (`Course_name` , `Course_year` )
    REFERENCES `fn71100_71012`.`Course` (`name` , `year` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`ForumReply`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`ForumReply` (
  `ForumReply_created_at` TIMESTAMP NOT NULL ,
  `ForumReply_User_email` VARCHAR(255) NOT NULL ,
  `ForumThread_ForumReply_created_at` TIMESTAMP NOT NULL ,
  `ForumThread_ForumReply_User_email` VARCHAR(255) NOT NULL ,
  `created_at` TIMESTAMP NOT NULL ,
  `title` VARCHAR(45) NOT NULL ,
  `body` MEDIUMTEXT NOT NULL ,
  `num_likes` INT UNSIGNED NOT NULL DEFAULT 0 ,
  `User_email` VARCHAR(255) NOT NULL ,
  `num_edits` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`created_at`, `User_email`) ,
  INDEX `fk_ForumReply_User` (`User_email` ASC) ,
  INDEX `fk_ForumReply_ForumReply` (`ForumReply_created_at` ASC, `ForumReply_User_email` ASC) ,
  INDEX `fk_ForumReply_ForumThread` (`ForumThread_ForumReply_created_at` ASC, `ForumThread_ForumReply_User_email` ASC) ,
  CONSTRAINT `fk_ForumReply_User`
    FOREIGN KEY (`User_email` )
    REFERENCES `fn71100_71012`.`User` (`email` )
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ForumReply_ForumReply`
    FOREIGN KEY (`ForumReply_created_at` , `ForumReply_User_email` )
    REFERENCES `fn71100_71012`.`ForumReply` (`created_at` , `User_email` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ForumReply_ForumThread`
    FOREIGN KEY (`ForumThread_ForumReply_created_at` , `ForumThread_ForumReply_User_email` )
    REFERENCES `fn71100_71012`.`ForumThread` (`ForumReply_created_at` , `ForumReply_User_email` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`Enrollment`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`Enrollment` (
  `StudentProfile_User_email` VARCHAR(255) NOT NULL ,
  `Course_name` VARCHAR(255) NOT NULL ,
  `Course_year` SMALLINT NOT NULL ,
  PRIMARY KEY (`StudentProfile_User_email`, `Course_name`, `Course_year`) ,
  INDEX `fk_Enrollment_StudentProfile` (`StudentProfile_User_email` ASC) ,
  INDEX `fk_Enrollment_Course` (`Course_name` ASC, `Course_year` ASC) ,
  CONSTRAINT `fk_Enrollment_StudentProfile`
    FOREIGN KEY (`StudentProfile_User_email` )
    REFERENCES `fn71100_71012`.`StudentProfile` (`User_email` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Enrollment_Course`
    FOREIGN KEY (`Course_name` , `Course_year` )
    REFERENCES `fn71100_71012`.`Course` (`name` , `year` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`CourseGrade`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`CourseGrade` (
  `value` SMALLINT UNSIGNED NOT NULL DEFAULT 0 ,
  `StudentProfile_User_email` VARCHAR(255) NOT NULL ,
  `Course_name` VARCHAR(255) NOT NULL ,
  `Course_year` SMALLINT NOT NULL ,
  PRIMARY KEY (`StudentProfile_User_email`, `Course_name`, `Course_year`) ,
  INDEX `fk_CourseGrade_StudentProfile` (`StudentProfile_User_email` ASC) ,
  INDEX `fk_CourseGrade_Course` (`Course_name` ASC, `Course_year` ASC) ,
  CONSTRAINT `fk_CourseGrade_StudentProfile`
    FOREIGN KEY (`StudentProfile_User_email` )
    REFERENCES `fn71100_71012`.`StudentProfile` (`User_email` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_CourseGrade_Course`
    FOREIGN KEY (`Course_name` , `Course_year` )
    REFERENCES `fn71100_71012`.`Course` (`name` , `year` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`Rating`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`Rating` (
  `value` SMALLINT UNSIGNED NOT NULL ,
  `TeacherProfile_User_email` VARCHAR(255) NOT NULL ,
  `Course_name` VARCHAR(255) NOT NULL ,
  `Course_year` SMALLINT NOT NULL ,
  `StudentProfile_User_email` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`TeacherProfile_User_email`, `Course_name`, `Course_year`, `StudentProfile_User_email`) ,
  INDEX `fk_Rating_TeacherProfile` (`TeacherProfile_User_email` ASC) ,
  INDEX `fk_Rating_Course` (`Course_name` ASC, `Course_year` ASC) ,
  INDEX `fk_Rating_StudentProfile` (`StudentProfile_User_email` ASC) ,
  CONSTRAINT `fk_Rating_TeacherProfile`
    FOREIGN KEY ()
    REFERENCES `fn71100_71012`.`TeacherProfile` ()
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Rating_Course`
    FOREIGN KEY (`Course_name` , `Course_year` )
    REFERENCES `fn71100_71012`.`Course` (`name` , `year` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Rating_StudentProfile`
    FOREIGN KEY (`StudentProfile_User_email` )
    REFERENCES `fn71100_71012`.`StudentProfile` (`User_email` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`Assignment`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`Assignment` (
  `title` VARCHAR(255) NOT NULL ,
  `description` MEDIUMTEXT NOT NULL ,
  `deadline` TIMESTAMP NULL ,
  `max_points` SMALLINT UNSIGNED NOT NULL ,
  `Course_name` VARCHAR(255) NOT NULL ,
  `Course_year` SMALLINT NOT NULL ,
  `TeacherProfile_User_email` VARCHAR(255) NOT NULL ,
  `created_at` VARCHAR(45) NULL ,
  PRIMARY KEY (`title`, `Course_name`, `Course_year`) ,
  INDEX `fk_Assignment_Course` (`Course_name` ASC, `Course_year` ASC) ,
  INDEX `fk_Assignment_TeacherProfile` (`TeacherProfile_User_email` ASC) ,
  CONSTRAINT `fk_Assignment_Course`
    FOREIGN KEY (`Course_name` , `Course_year` )
    REFERENCES `fn71100_71012`.`Course` (`name` , `year` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Assignment_TeacherProfile`
    FOREIGN KEY ()
    REFERENCES `fn71100_71012`.`TeacherProfile` ()
    ON DELETE SET NULL
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`AssignmentGrade`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`AssignmentGrade` (
  `value` SMALLINT UNSIGNED NOT NULL ,
  `StudentProfile_faculty_number` INT NOT NULL ,
  `StudentProfile_User_email` VARCHAR(255) NOT NULL ,
  `Assignment_title` VARCHAR(255) NOT NULL ,
  `Assignment_Course_name` VARCHAR(255) NOT NULL ,
  `Assignment_Course_year` SMALLINT NOT NULL ,
  PRIMARY KEY (`StudentProfile_faculty_number`, `StudentProfile_User_email`, `Assignment_title`, `Assignment_Course_name`, `Assignment_Course_year`) ,
  INDEX `fk_AssignmentGrade_StudentProfile` (`StudentProfile_faculty_number` ASC, `StudentProfile_User_email` ASC) ,
  INDEX `fk_AssignmentGrade_Assignment` (`Assignment_title` ASC, `Assignment_Course_name` ASC, `Assignment_Course_year` ASC) ,
  CONSTRAINT `fk_AssignmentGrade_StudentProfile`
    FOREIGN KEY (`StudentProfile_faculty_number` )
    REFERENCES `fn71100_71012`.`StudentProfile` (`faculty_number` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_AssignmentGrade_Assignment`
    FOREIGN KEY (`Assignment_title` , `Assignment_Course_name` , `Assignment_Course_year` )
    REFERENCES `fn71100_71012`.`Assignment` (`title` , `Course_name` , `Course_year` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`CourseOtherTeachers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`CourseOtherTeachers` (
  `TeacherProfile_User_email` VARCHAR(255) NOT NULL ,
  `Course_name` VARCHAR(255) NOT NULL ,
  `Course_year` SMALLINT NOT NULL ,
  PRIMARY KEY (`TeacherProfile_User_email`, `Course_name`, `Course_year`) ,
  INDEX `fk_CourseOtherTeachers_TeacherProfile` (`TeacherProfile_User_email` ASC) ,
  INDEX `fk_CourseOtherTeachers_Course` (`Course_name` ASC, `Course_year` ASC) ,
  CONSTRAINT `fk_CourseOtherTeachers_TeacherProfile`
    FOREIGN KEY (`TeacherProfile_User_email` )
    REFERENCES `fn71100_71012`.`TeacherProfile` (`User_email` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_CourseOtherTeachers_Course`
    FOREIGN KEY (`Course_name` , `Course_year` )
    REFERENCES `fn71100_71012`.`Course` (`name` , `year` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`News`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`News` (
  `created_at` TIMESTAMP NOT NULL ,
  `Course_name` VARCHAR(255) NOT NULL ,
  `Course_year` SMALLINT NOT NULL ,
  `TeacherProfile_User_email` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`created_at`, `TeacherProfile_User_email`) ,
  INDEX `fk_News_Course` (`Course_name` ASC, `Course_year` ASC) ,
  INDEX `fk_News_TeacherProfile` (`TeacherProfile_User_email` ASC) ,
  CONSTRAINT `fk_News_Course`
    FOREIGN KEY (`Course_name` , `Course_year` )
    REFERENCES `fn71100_71012`.`Course` (`name` , `year` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_News_TeacherProfile`
    FOREIGN KEY (`TeacherProfile_User_email` )
    REFERENCES `fn71100_71012`.`TeacherProfile` (`User_email` )
    ON DELETE SET NULL
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`AssignmentFile`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`AssignmentFile` (
  `path` MEDIUMTEXT NOT NULL ,
  `name` VARCHAR(255) NULL ,
  `Assignment_title` VARCHAR(255) NOT NULL ,
  `Assignment_Course_name` VARCHAR(255) NOT NULL ,
  `Assignment_Course_year` SMALLINT NOT NULL ,
  PRIMARY KEY (`path`) ,
  INDEX `fk_AssignmentFile_Assignment` (`Assignment_title` ASC, `Assignment_Course_name` ASC, `Assignment_Course_year` ASC) ,
  CONSTRAINT `fk_AssignmentFile_Assignment`
    FOREIGN KEY (`Assignment_title` , `Assignment_Course_name` , `Assignment_Course_year` )
    REFERENCES `fn71100_71012`.`Assignment` (`title` , `Course_name` , `Course_year` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`Resource`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`Resource` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `created_at` TIMESTAMP NOT NULL ,
  `description` MEDIUMTEXT NOT NULL ,
  `Course_name` VARCHAR(255) NOT NULL ,
  `Course_year` SMALLINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_Resource_Course` (`Course_name` ASC, `Course_year` ASC) ,
  CONSTRAINT `fk_Resource_Course`
    FOREIGN KEY (`Course_name` , `Course_year` )
    REFERENCES `fn71100_71012`.`Course` (`name` , `year` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`ResourceFile`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`ResourceFile` (
  `path` MEDIUMTEXT NOT NULL ,
  `name` VARCHAR(255) NULL ,
  `Resource_id` INT NOT NULL ,
  PRIMARY KEY (`path`) ,
  INDEX `fk_ResourceFile_Resource` (`Resource_id` ASC) ,
  CONSTRAINT `fk_ResourceFile_Resource`
    FOREIGN KEY (`Resource_id` )
    REFERENCES `fn71100_71012`.`Resource` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`AssignmentNotification`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`AssignmentNotification` (
  `body` MEDIUMTEXT NOT NULL ,
  `created_at` TIMESTAMP NOT NULL ,
  `id` INT NOT NULL AUTO_INCREMENT ,
  `Assignment_title` VARCHAR(255) NOT NULL ,
  `Assignment_Course_name` VARCHAR(255) NOT NULL ,
  `Assignment_Course_year` SMALLINT NOT NULL ,
  PRIMARY KEY (`id`, `Assignment_title`, `Assignment_Course_name`, `Assignment_Course_year`) ,
  INDEX `fk_AssignmentNotification_Assignment` (`Assignment_title` ASC, `Assignment_Course_name` ASC, `Assignment_Course_year` ASC) ,
  CONSTRAINT `fk_AssignmentNotification_Assignment`
    FOREIGN KEY (`Assignment_title` , `Assignment_Course_name` , `Assignment_Course_year` )
    REFERENCES `fn71100_71012`.`Assignment` (`title` , `Course_name` , `Course_year` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`CourseNotification`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`CourseNotification` (
  `body` MEDIUMTEXT NOT NULL ,
  `created_at` TIMESTAMP NOT NULL ,
  `id` INT NOT NULL AUTO_INCREMENT ,
  `Course_name` VARCHAR(255) NOT NULL ,
  `Course_year` SMALLINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_CourseNotification_Course` (`Course_name` ASC, `Course_year` ASC) ,
  CONSTRAINT `fk_CourseNotification_Course`
    FOREIGN KEY (`Course_name` , `Course_year` )
    REFERENCES `fn71100_71012`.`Course` (`name` , `year` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)


-- -----------------------------------------------------
-- Table `fn71100_71012`.`ForumReplyNotification`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`ForumReplyNotification` (
  `body` MEDIUMTEXT NOT NULL ,
  `created_at` TIMESTAMP NOT NULL ,
  `id` INT NOT NULL AUTO_INCREMENT ,
  PRIMARY KEY (`id`) )


-- -----------------------------------------------------
-- Table `fn71100_71012`.`Speciality`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`Speciality` (
  `name` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`name`) )


-- -----------------------------------------------------
-- Table `fn71100_71012`.`SpecialityLookup`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fn71100_71012`.`SpecialityLookup` (
  `fn_from` VARCHAR(45) NOT NULL ,
  `fn_to` VARCHAR(45) NOT NULL ,
  `Speciality_name` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`fn_from`, `fn_to`, `Speciality_name`) ,
  INDEX `fk_SpecialityLookup_Speciality1` (`Speciality_name` ASC) ,
  CONSTRAINT `fk_SpecialityLookup_Speciality1`
    FOREIGN KEY (`Speciality_name` )
    REFERENCES `fn71100_71012`.`Speciality` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
