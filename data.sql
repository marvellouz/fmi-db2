set schema FN71100_71012;
INSERT INTO Teacherprofile
 VALUES('docent', 'valentin@yahoo.com');
INSERT INTO Teacherprofile
 VALUES(NULL, 'dinko@yahoo.com');
INSERT INTO Teacherprofile
 VALUES(NULL, 'emil@yahoo.com');
INSERT INTO Teacherprofile
 VALUES('proffessor', 'dimitar@yahoo.com');
INSERT INTO Teacherprofile
 VALUES('proffessor', 'elena@yahoo.com');
INSERT INTO Teacherprofile
 VALUES('proffessor', 'maria@yahoo.com');
INSERT INTO Teacherprofile
 VALUES(NULL, 'petia@yahoo.com');
INSERT INTO Teacherprofile
 VALUES(NULL, 'ivanka@yahoo.com');
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
INSERT INTO Course
 VALUES('Not Classicat Logics For Artificial Intelligence', 2010, 'logic', 'passlogic', 12, 'dimitar@yahoo.com');
INSERT INTO Course
 VALUES('Set Theoty', 2010, 'mathematics', 'passsetth', 7, 'valentin@yahoo.com');
INSERT INTO Course
 VALUES('Python', 2009, 'informatics', NULL, 120, 'dinko@yahoo.com');
INSERT INTO Course
 VALUES('Ruby on Rails', 2008, NULL, NULL, 'petia@yahoo.com');
INSERT INTO Course
 VALUES('Algebra', 2010, 'mathematics', 'passalgebra', 9, 'elena@yahoo.com');
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
INSERT INTO Forumreply
 VALUES('valentin@yahoo.com', CURRENT TIMESTAMP, 'simeon@yahoo.com', CURRENT TIMESTAMP, 'violeta@yahoo.com', CURRENT TIMESTAMP, NULL);
INSERT INTO Forumreply
 VALUES('dinko@yahoo.com', CURRENT TIMESTAMP, 'valentin@yahoo.com', CURRENT TIMESTAMP, 'nikola@yahoo.com', CURRENT TIMESTAMP, NULL);
INSERT INTO Forumreply
 VALUES('elena@yahoo.com', CURRENT TIMESTAMP, 'violeta@yahoo.com', CURRENT TIMESTAMP, 'simeon@yahoo.com', CURRENT TIMESTAMP, NULL);
INSERT INTO Forumreply
 VALUES('petkan@abv.bg', CURRENT TIMESTAMP, 'valentin@yahoo.com', CURRENT TIMESTAMP, 'ilian@yahoo.com', CURRENT TIMESTAMP, NULL);
INSERT INTO Forumreply
 VALUES('ilian@yahoo.com', CURRENT TIMESTAMP, 'dinko@yahoo.com', CURRENT TIMESTAMP, 'elena@yahoo.com', CURRENT TIMESTAMP, NULL);
INSERT INTO Forumreply
 VALUES('simeon@yahoo.com', CURRENT TIMESTAMP, 'elena@yahoo.com', CURRENT TIMESTAMP, 'petkan@abv.bg', CURRENT TIMESTAMP, NULL);
INSERT INTO Forumreply
 VALUES('nikola@yahoo.com', CURRENT TIMESTAMP, 'petkan@abv.bg', CURRENT TIMESTAMP, 'elena@yahoo.com', CURRENT TIMESTAMP, NULL);
INSERT INTO Forumreply
 VALUES('violeta@yahoo.com', CURRENT TIMESTAMP, 'ilian@yahoo.com', CURRENT TIMESTAMP, 'valentin@yahoo.com', CURRENT TIMESTAMP, NULL);
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
