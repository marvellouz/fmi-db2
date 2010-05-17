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
 VALUES('valentin@yahoo.com', TIMESTAMP("2010-05-17 12:40:44"), 'simeon@yahoo.com', CURRENT TIMESTAMP, 'violeta@yahoo.com', CURRENT TIMESTAMP, 'arch - wireless', 'Hey, new archer here!!! Yesterday I installed arch 64bit and after doing some configuration tricks, Im still left with a couple of issues. 1. No wireless networks founeITs an usb wifi card - (works out of the box in slackware-current on the same laptop).', 4, 1);
INSERT INTO Forumreply 
 VALUES('dinko@yahoo.com', CURRENT TIMESTAMP, 'valentin@yahoo.com', CURRENT TIMESTAMP, 'nikola@yahoo.com', CURRENT TIMESTAMP, 'Hi Archers... :) Is it difficult to create a LiveArch...?', 'Hi there everybody I wish to create a Live Lightweight Arch Distro, packed with stuff compiled from source, mostly engineering apps...Is this "Mission Impossible", or Just "Mission difficult"...Tried to use Knoppix for that... there are rather well detailed Howtos in Google... but, as I was trying to set up the environment to build my own stuff from source, the libs and all, Synaptic said some of them were not Installable... although it installed some stuff ...I was using the LiveCD... to start from a minimal base... is this a LiceCD issue, or is it to be expected in the LiveDVD also... ? Happened with the 6.3 Knoppix... So I wanna try Arch...Shylock made a nice Live distro, ArchBang, but it cannot be remastered and rebuilt so as to create an Iso and burn it into a CD (DVD ) with all the stuff that I want to put in there... can it...? Think of it as my "Lightweight" B-52, ROFL , as ArchBang would be a sort of Lightweight F23 Raptor... BRGDS Alex', 2, 0);
INSERT INTO Forumreply 
 VALUES('elena@yahoo.com', CURRENT TIMESTAMP, 'violeta@yahoo.com', CURRENT TIMESTAMP, 'simeon@yahoo.com', CURRENT TIMESTAMP, 'Problems after changing controlling boot distro', 'Hello, I have 2 500gb drives. Arch used to be /dev/sda1 with /home on /dev/sda6. I have decided to hook up both my drives and now I have PClinux on /dev/sda1 with the home on /dev/sda6. I setup grub on PClinux to boot Arch on /dev/sdb1 without issue. Now the problem I have is when I boot Arch everything goes fine until I login as user. It gives some sort of cant find HOME= defaulting to default (home is on /dev/sdb6). I cant start X or anything. Anyone have any ideas without doing a re-install?', 3, 2);
INSERT INTO Forumreply 
 VALUES('petkan@abv.bg', CURRENT TIMESTAMP, 'valentin@yahoo.com', CURRENT TIMESTAMP, 'ilian@yahoo.com', CURRENT TIMESTAMP, 'Im thinking I am having permission problems with oblogout and openbox in arch.', 'I am currently running Arch with openbox. I have setup oblogout, but the only buttons that work are Logout and cancel. I cant get shutdown, reboot, suspend, or lock to work. Any ideas?', 5, 9);
INSERT INTO Forumthread (a,b,c,e,f)
 VALUES(CURRENT TIMESTAMP, 'Not Classical Logics For Artificial Intelligence', 2010, 'Test title of thread', 'Test body of thread');
INSERT INTO Forumthread (a,b,c,e,f)
 VALUES(CURRENT TIMESTAMP, 'Not Classical Logics For Artificial Intelligence', 2010, 'Test title of thread 2', 'Test body of thread 2');
INSERT INTO Forumthread (a,b,c,e,f)
 VALUES(CURRENT TIMESTAMP, 'Python', 2009, 'Test title of thread 3', 'Test body of thread 3');
INSERT INTO Forumthread (a,b,c)
 VALUES(CURRENT TIMESTAMP, 'Set Theory', 2010);
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
