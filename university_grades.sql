-- university_grades database
-- AUTHOR: Przemyslaw Zgudka

DROP DATABASE IF EXISTS `university_grades`;
CREATE DATABASE `university_grades`; 
USE `university_grades`;

SET NAMES UTF8MB4;
SET character_set_client = utf8mb4 ;

-- ----------------------------------------------------------------------------------------------------
-- course_types table [contains data on university course types assigned to each course in `course` table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `course_types` (
  `course_type_id` tinyint NOT NULL,
  `course_type` varchar(30) NOT NULL,
  PRIMARY KEY (`course_type_id`),
  UNIQUE KEY `type_id_UNIQUE` (`course_type_id`)
) ENGINE=InnoDB;

INSERT INTO `course_types` VALUES 
(1,'lecture'),
(2,'practical'),
(3,'language class');

-- ----------------------------------------------------------------------------------------------------
-- degrees table [contains data on university degrees assigned to each studies in `studies` table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `degrees` (
  `degree_id` tinyint NOT NULL,
  `degree` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`degree_id`),
  UNIQUE KEY `degree_id_UNIQUE` (`degree_id`)
) ENGINE=InnoDB;

INSERT INTO `degrees` VALUES 
(1,'bachelors'),
(2,'masters'),
(3,'uniform masters'),
(4,'phd');

-- ----------------------------------------------------------------------------------------------------
-- faculties table [contains data on faculties assigned to each studies in `studies` table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `faculties` (
  `faculty_id` tinyint NOT NULL,
  `faculty` varchar(100) NOT NULL,
  PRIMARY KEY (`faculty_id`),
  UNIQUE KEY `faculty_id_UNIQUE` (`faculty_id`)
) ENGINE=InnoDB;

INSERT INTO `faculties` VALUES 
(1,'political science and international studies'),
(2,'mathematics, informatics and mechanics');

-- ----------------------------------------------------------------------------------------------------
-- majors table [contains data on majors assigned to each studies in `studies` table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `majors` (
  `major_id` tinyint NOT NULL,
  `major` varchar(75) NOT NULL,
  PRIMARY KEY (`major_id`),
  UNIQUE KEY `major_id_UNIQUE` (`major_id`)
) ENGINE=InnoDB;

INSERT INTO `majors` VALUES (1,'political science'),(2,'international relations'),(3,'computer science'),(4,'bioinformatics');

-- ----------------------------------------------------------------------------------------------------
-- modes table [contains data on modes assigned to each studies in `studies` table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `modes` (
  `mode_id` tinyint NOT NULL,
  `mode` varchar(30) NOT NULL,
  PRIMARY KEY (`mode_id`),
  UNIQUE KEY `mode_id_UNIQUE` (`mode_id`)
) ENGINE=InnoDB;

INSERT INTO `modes` VALUES (1,'full time'),(2,'part time'),(3,'extramural');

-- ----------------------------------------------------------------------------------------------------
-- studies table [contains data on studies]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `studies` (
  `studies_id` tinyint NOT NULL,
  `major_id` tinyint NOT NULL,
  `mode_id` tinyint NOT NULL,
  `degree_id` tinyint NOT NULL,
  `faculty_id` tinyint NOT NULL,
  PRIMARY KEY (`studies_id`),
  UNIQUE KEY `studies_id_UNIQUE` (`studies_id`),
  KEY `fk_studies_major_id` (`major_id`),
  KEY `fk_majors_faculty_id_idx` (`faculty_id`),
  KEY `fk_majors_degrees_id_idx` (`degree_id`),
  KEY `fk_studies_mode_id_idx` (`mode_id`),
  KEY `idx_studies_major_degree_mode_faculty_id` (`studies_id`,`major_id`,`degree_id`,`mode_id`,`faculty_id`),
  CONSTRAINT `fk_studies_degrees_id` FOREIGN KEY (`degree_id`) REFERENCES `degrees` (`degree_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_studies_faculty_id` FOREIGN KEY (`faculty_id`) REFERENCES `faculties` (`faculty_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_studies_major_id` FOREIGN KEY (`major_id`) REFERENCES `majors` (`major_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_studies_mode_id` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`mode_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `studies` VALUES (1,1,1,1,1),(2,1,1,2,1),(3,1,2,1,1),(4,1,2,2,1),(5,1,3,1,1),(6,1,3,2,1),(7,2,1,4,1),(8,2,3,4,1),(9,3,1,1,2),(10,3,1,2,2),(11,3,2,1,2),(12,3,2,2,2),(13,3,3,1,2),(14,3,3,2,2),(15,4,1,3,2),(16,4,2,3,2),(17,4,3,3,2);

-- ----------------------------------------------------------------------------------------------------
-- indxs table [contains data on indexes with details regarding students]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `indxs` (
  `index_id` mediumint NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `index_no` int NOT NULL,
  `studies_id` tinyint NOT NULL,
  `academic_year` smallint NOT NULL,
  PRIMARY KEY (`index_id`),
  UNIQUE KEY `index_no_UNIQUE` (`index_no`),
  UNIQUE KEY `index_id_UNIQUE` (`index_id`),
  KEY `fk_indexes_studies_id_idx` (`studies_id`),
  KEY `idx_index_no_last_name_studies_id_academic_year` (`index_no`,`last_name`,`studies_id`,`academic_year`),
  CONSTRAINT `fk_indexes_studies_id` FOREIGN KEY (`studies_id`) REFERENCES `studies` (`studies_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `indxs` VALUES (1,'Krystyna','Baran',198803,1,1),(2,'Karolina','Maciejewska',105289,1,1),(3,'Wiktoria','Kazmierczak',146682,1,1),(4,'Cezary','Cieslak',170377,1,1),(5,'Maria','Rutkowska',111797,1,1),(6,'Konstanty','Kowal',189860,1,1),(7,'Seweryn','Dziedzic',199739,1,2),(8,'Irena','Orzechowska',198655,1,2),(9,'Leon','Adamski',193468,1,2),(10,'Andrzej','Wesolowski',107044,1,2),(11,'Alojzy','Tomczak',127894,1,2),(12,'Stefan','Wysocki',151187,1,2),(13,'Slawomir','Sokolowski',101304,1,3),(14,'Sandra','Sokolowska',188299,1,3),(15,'Justyna','Krajewska',194731,1,3),(16,'Wiktor','Gajewski',134922,1,3),(17,'Dagmara','Madej',155348,1,3),(18,'Marta','Lukasik',139631,1,3),(19,'Iwona','Swiatek',127383,3,1),(20,'Wincenty','Kruk',121414,3,1),(21,'Tomasz','Wieczorek',140529,3,1),(22,'Weronika','Leszczynska',128984,3,1),(23,'Aleksandra','Bak',177143,3,1),(24,'Bogumil','Gajda',148509,3,1),(25,'Bernard','Nowacki',149246,3,2),(26,'Katarzyna','Blaszczyk',111457,3,2),(27,'Lucja','Domanska',114152,3,2),(28,'Roksana','Milewska',177573,3,2),(29,'Oliwia','Gorecka',184964,3,2),(30,'Olga','Matuszewska',124895,3,2),(31,'Bogdan','Laskowski',146850,3,3),(32,'Agnieszka','Dziedzic',107019,3,3),(33,'Barbara','Tomaszewska',151920,3,3),(34,'Sylwester','Koziol',174229,3,3),(35,'Anna','Walczak',128075,3,3),(36,'Renata','Sikorska',158978,3,3),(37,'Malwina','Majchrzak',145217,5,1),(38,'Mikolaj','Jastrzebski',140497,5,1),(39,'Katarzyna','Stankiewicz',129936,5,1),(40,'Marian','Baran',170526,5,1),(41,'Dominik','Ziolkowski',121536,5,1),(42,'Zuzanna','Michalik',141740,5,1),(43,'Katarzyna','Szewczyk',113995,5,2),(44,'Paulina','Urbanska',171740,5,2),(45,'Nikodem','Zieba',165999,5,2),(46,'Klaudia','Janicka',104885,5,2),(47,'Danuta','Wilk',170814,5,2),(48,'Mariusz','Ostrowski',198674,5,2),(49,'Wiktor','Urbaniak',108803,5,3),(50,'Sara','Jozwiak',102199,5,3),(51,'Nadia','Urbaniak',138765,5,3),(52,'Edmund','Kowalewski',127194,5,3),(53,'Sandra','Kruk',177998,5,3),(54,'Kacper','Wlodarczyk',186621,5,3),(55,'Wanda','Kurowska',193027,2,1),(56,'Jadwiga','Sadowska',169378,2,1),(57,'Anna','Dobrowolska',165030,2,1),(58,'Kajetan','Bielecki',132235,2,1),(59,'Adrian','Wasilewski',195086,2,1),(60,'Feliks','Kowalik',154580,2,1),(61,'Sabina','Pawlik',172713,2,2),(62,'Ryszard','Walczak',136534,2,2),(63,'Katarzyna','Gajda',154524,2,2),(64,'Zuzanna','Stasiak',188308,2,2),(65,'Anna','Wesolowska',109350,2,2),(66,'Renata','Markowska',160645,2,2),(67,'Bartlomiej','Szulc',179633,7,1),(68,'Gabriel','Kolodziejczyk',126036,7,1),(69,'Przemyslaw','Konieczny',186778,7,1),(70,'Grzegorz','Adamczyk',145700,7,1),(71,'Halina','Kolodziejczyk',126550,7,1),(72,'Honorata','Skiba',160097,7,1),(73,'Wladyslaw','Luczak',124348,7,2),(74,'Wieslaw','Sawicki',118926,7,2),(75,'Radoslaw','Kaczmarczyk',179745,7,2),(76,'Anna','Wrona',135832,7,2),(77,'Julian','Lipinski',182435,7,2),(78,'Oskar','Chojnacki',184682,7,2),(79,'Kamil','Bak',159535,7,3),(80,'Lucjan','Piatek',134003,7,3),(81,'Urszula','Glowacka',116346,7,3),(82,'Miroslaw','Jakubowski',198567,7,3),(83,'Kazimierz','Sikora',156138,7,3),(84,'Jozef','Wrobel',152397,7,3),(85,'Julia','Kucharska',167265,7,4),(86,'Izabela','Kurek',116959,7,4),(87,'Izabela','Baranowska',104217,7,4),(88,'Patrycja','Przybylska',102655,7,4),(89,'Nina','Czajkowska',109014,7,4),(90,'Arkadiusz','Krajewski',142171,7,4),(91,'Monika','Borkowska',131678,8,1),(92,'Bronislaw','Baranowski',178775,8,1),(93,'Amelia','Mikolajczyk',136833,8,1),(94,'Katarzyna','Ratajczak',192942,8,1),(95,'Jakub','Malinowski',150154,8,1),(96,'Lena','Kozak',111945,8,1),(97,'Ignacy','Andrzejewski',162826,8,2),(98,'Bogdan','Skiba',188092,8,2),(99,'Daniel','Sobczak',181651,8,2),(100,'Magda','Bielecka',181567,8,2),(101,'Ewelina','Polak',116499,8,2),(102,'Anna','Szulc',101646,8,2),(103,'Gerard','Stankiewicz',170149,8,3),(104,'Jerzy','Bednarek',154954,8,3),(105,'Marcelina','Piasecka',105333,8,3),(106,'Rafal','Jasinski',113746,8,3),(107,'Cecylia','Piatek',167342,8,3),(108,'Magdalena','Zawadzka',171677,8,3),(109,'Damian','Wolski',183291,8,4),(110,'Weronika','Szymczak',126966,8,4),(111,'Dorota','Mazurek',113284,8,4),(112,'Waclaw','Przybylski',139345,8,4),(113,'Wioletta','Orlowska',182229,8,4),(114,'Kinga','Lipinska',194813,8,4),(115,'Wioleta','Sosnowska',109688,4,1),(116,'Halina','Szczepanska',181668,4,1),(117,'Bartosz','Kucharski',199151,4,1),(118,'Emilia','Wasilewska',121659,4,1),(119,'Daria','Nowacka',140786,4,1),(120,'Jan','Grabowski',134838,4,1),(121,'Dawid','Duda',123276,4,2),(122,'Filip','Urbanski',130057,4,2),(123,'Hubert','Kozak',127151,4,2),(124,'Marcel','Mucha',167316,4,2),(125,'Angelika','Wojtowicz',166481,4,2),(126,'Ewelina','Borowska',114307,4,2),(127,'Aleksander','Nawrocki',170634,6,1),(128,'Mariola','Brzozowska',128060,6,1),(129,'Blazej','Domanski',196156,6,1),(130,'Ireneusz','Szczepaniak',154528,6,1),(131,'Jolanta','Kolodziej',151482,6,1),(132,'Agnieszka','Romanowska',193016,6,1),(133,'Sebastian','Kolodziej',108158,6,2),(134,'Malgorzata','Ostrowska',124549,6,2),(135,'Ilona','Kot',110671,6,2),(136,'Aleksandra','Brzezinska',131162,6,2),(137,'Norbert','Musial',130945,6,2),(138,'Marzena','Musial',121847,6,2),(139,'Olga','Bukowska',202203,9,1),(140,'Irena','Chmielewska',225762,9,1),(141,'Klaudia','Szczepaniak',261946,9,1),(142,'Jacek','Marciniak',286483,9,1),(143,'Hanna','Zakrzewska',266093,9,1),(144,'Witold','Borowski',293823,9,1),(145,'Eliza','Urban',244112,9,2),(146,'Agnieszka','Zalewska',225047,9,2),(147,'Agata','Ziolkowska',284203,9,2),(148,'Ewa','Markiewicz',292713,9,2),(149,'Tymoteusz','Ciesielski',266865,9,2),(150,'Remigiusz','Sowa',250979,9,2),(151,'Maja','Kaczmarczyk',259517,9,3),(152,'Helena','Marciniak',224010,9,3),(153,'Anna','Maj',213755,9,3),(154,'Edyta','Kowalewska',214642,9,3),(155,'Lena','Marek',286546,9,3),(156,'Boleslaw','Szymczak',236775,9,3),(157,'Milena','Tomczak',257210,11,1),(158,'Michal','Nowakowski',223423,11,1),(159,'Wojciech','Witkowski',298465,11,1),(160,'Jerzy','Jaworski',219576,11,1),(161,'Andrzej','Krol',220852,11,1),(162,'Beata','Mucha',299006,11,1),(163,'Piotr','Pawlowski',295922,11,2),(164,'Franciszek','Tomaszewski',223961,11,2),(165,'Waleria','Socha',211444,11,2),(166,'Iwona','Czarnecka',297256,11,2),(167,'Marianna','Wlodarczyk',282078,11,2),(168,'Alicja','Wysocka',256566,11,2),(169,'Eryk','Orlowski',212704,11,3),(170,'Oliwier','Mikolajczyk',274361,11,3),(171,'Elzbieta','Jasinska',238606,11,3),(172,'Beata','Kalinowska',226286,11,3),(173,'Stanislaw','Zajac',291317,11,3),(174,'Zofia','Michalak',213311,11,3),(175,'Janusz','Sadowski',299846,13,1),(176,'Diana','Mazurkiewicz',201587,13,1),(177,'Kaja','Kasprzak',291534,13,1),(178,'Marta','Sawicka',220280,13,1),(179,'Ivan','Markiewicz',209173,13,1),(180,'Tadeusz','Olszewski',251865,13,1),(181,'Lucyna','Cieslak',225971,13,2),(182,'Danuta','Olejniczak',227168,13,2),(183,'Milosz','Czerwinski',244026,13,2),(184,'Grazyna','Kubiak',253423,13,2),(185,'Szczepan','Polak',245587,13,2),(186,'Magda','Lesniak',270486,13,2),(187,'Zuzanna','Krupa',250287,13,3),(188,'Karolina','Wawrzyniak',275084,13,3),(189,'Gabriela','Janik',299865,13,3),(190,'Aleksandra','Jarosz',294819,13,3),(191,'Anna','Sobolewska',223095,13,3),(192,'Zygmunt','Glowacki',207829,13,3),(193,'Henryk','Gorski',282666,10,1),(194,'Jagoda','Nawrocka',249298,10,1),(195,'Matylda','Owczarek',230976,10,1),(196,'Bozena','Sobczak',249222,10,1),(197,'Marcin','Dudek',248639,10,1),(198,'Maciej','Pietrzak',222446,10,1),(199,'Robert','Milewski',200142,10,2),(200,'Andrzej','Kurek',225721,10,2),(201,'Lidia','Koziol',240813,10,2),(202,'Jaroslaw','Szczepanski',287081,10,2),(203,'Anita','Karpinska',232438,10,2),(204,'Emil','Brzozowski',257789,10,2),(205,'Maksymilian','Leszczynski',237202,12,1),(206,'Magda','Olejnik',209339,12,1),(207,'Igor','Klimek',203700,12,1),(208,'Roman','Kot',238712,12,1),(209,'Aneta','Adamska',263611,12,1),(210,'Alfred','Wojtowicz',217940,12,1),(211,'Tymon','Wawrzyniak',253979,12,2),(212,'Szymon','Wilk',296072,12,2),(213,'Natalia','Lis',239689,12,2),(214,'Aleksander','Maciejewski',243735,12,2),(215,'Iga','Kowalik',275863,12,2),(216,'Joanna','Duda',279238,12,2),(217,'Liliana','Luczak',244107,14,1),(218,'Joachim','Janicki',259580,14,1),(219,'Maksym','Stefanski',294313,14,1),(220,'Iga','Wierzbicka',205832,14,1),(221,'Marlena','Jastrzebska',262000,14,1),(222,'Wojciech','Witkowski',246339,14,1),(223,'Michal','Nowakowski',286594,14,2),(224,'Mikolaj','Sikorski',265885,14,2),(225,'Beata','Bednarczyk',204013,14,2),(226,'Zbigniew','Pawlak',290348,14,2),(227,'Joanna','Pietrzak',254412,14,2),(228,'Borys','Wierzbicki',275584,14,2),(229,'Antoni','Zalewski',252023,15,1),(230,'Krzysztof','Michalski',258546,15,1),(231,'Boguslaw','Janik',277173,15,1),(232,'Olga','Ciesielska',209930,15,1),(233,'Dominika','Chojnacka',276038,15,1),(234,'Lech','Kopec',216706,15,1),(235,'Marzena','Czerwinska',229759,15,2),(236,'Irena','Chmielewska',215554,15,2),(237,'Zaneta','Sliwinska',215540,15,2),(238,'Ewa','Wroblewska',237706,15,2),(239,'Boleslaw','Sosnowski',299487,15,2),(240,'Ludwik','Markowski',277420,15,2),(241,'Wlodzimierz','Tomczyk',209461,15,3),(242,'Szymon','Zak',293053,15,3),(243,'Marta','Malecka',238026,15,3),(244,'Paulina','Bednarek',253079,15,3),(245,'Konrad','Brzezinski',229302,15,3),(246,'Eugeniusz','Krupa',207334,15,3),(247,'Albert','Madej',237060,15,4),(248,'Stefania','Makowska',269822,15,4),(249,'Martyna','Kania',279421,15,4),(250,'Bozena','Wolska',229246,15,4),(251,'Marianna','Kopec',201330,15,4),(252,'Karol','Kubiak',253021,15,4),(253,'Czeslaw','Lis',232636,15,5),(254,'Lukasz','Nowicki',264618,15,5),(255,'Igor','Gorecki',292574,15,5),(256,'Zenon','Kania',253625,15,5),(257,'Anna','Konieczna',294348,15,5),(258,'Marek','Stepien',289655,15,5),(259,'Robert','Wroblewski',216902,16,1),(260,'Fabian','Pawlik',265512,16,1),(261,'Adam','Majewski',216170,16,1),(262,'Bozena','Zak',244143,16,1),(263,'Kamila','Andrzejewska',237033,16,1),(264,'Julianna','Kowal',276340,16,1),(265,'Mieczyslaw','Borkowski',206883,16,2),(266,'Wladyslaw','Szewczyk',256651,16,2),(267,'Adrianna','Stefanska',294753,16,2),(268,'Zdzislaw','Kalinowski',279972,16,2),(269,'Teodor','Piasecki',274496,16,2),(270,'Felicja','Grzelak',246855,16,2),(271,'Patryk','Czarnecki',239927,16,3),(272,'Wlodzimierz','Blaszczyk',264011,16,3),(273,'Natalia','Domagala',239825,16,3),(274,'Weronika','Gajewska',281103,16,3),(275,'Ksawery','Stasiak',219306,16,3),(276,'Anastazja','Klimek',273279,16,3),(277,'Artur','Mazurek',244949,16,4),(278,'Danuta','Zieba',248313,16,4),(279,'Roman','Zawadzki',240678,16,4),(280,'Anna','Pajak',211904,16,4),(281,'Kornelia','Sowa',263005,16,4),(282,'Damian','Kazmierczak',241821,16,4),(283,'Krystian','Makowski',235199,16,5),(284,'Wanda','Laskowska',253995,16,5),(285,'Leonard','Czajkowski',281373,16,5),(286,'Sylwia','Mroz',203701,16,5),(287,'Waldemar','Zakrzewski',228575,16,5),(288,'Edward','Chmielewski',204854,16,5),(289,'Mateusz','Rutkowski',264481,17,1),(290,'Leszek','Mroz',217423,17,1),(291,'Julia','Wilczynska',210955,17,1),(292,'Nikodem','Karpinski',223375,17,1),(293,'Natalia','Tomczyk',243032,17,1),(294,'Dariusz','Michalak',224170,17,1),(295,'Czeslaw','Orlowski',218399,17,2),(296,'Natalia','Stepien',266815,17,2),(297,'Robert','Piasecki',200238,17,2),(298,'Marianna','Witkowska',296231,17,2),(299,'Anna','Pawlik',222470,17,2),(300,'Ivan','Gajewski',219477,17,2),(301,'Michal','Socha',228027,17,3),(302,'Martyna','Sowa',289814,17,3),(303,'Marta','Kalinowska',255490,17,3),(304,'Boleslaw','Sawicki',207480,17,3),(305,'Dominika','Andrzejewska',266019,17,3),(306,'Teodor','Wroblewski',230005,17,3),(307,'Marcin','Milewski',251998,17,4),(308,'Robert','Krupa',210885,17,4),(309,'Alfred','Kowal',279832,17,4),(310,'Eliza','Madej',299587,17,4),(311,'Iga','Glowacka',232924,17,4),(312,'Liliana','Wierzbicka',211006,17,4),(313,'Waleria','Sobolewska',276476,17,5),(314,'Natalia','Gorska',217107,17,5),(315,'Jagoda','Witkowska',203046,17,5),(316,'Anastazja','Markowska',276899,17,5),(317,'Boleslaw','Chmielewski',281437,17,5),(318,'Andrzej','Andrzejewski',275481,17,5);

-- ----------------------------------------------------------------------------------------------------
-- courses table [contains data on courses with details regarding courses affiliation to exact studies and course types]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `courses` (
  `course_id` smallint NOT NULL,
  `course` varchar(100) NOT NULL,
  `course_year` tinyint NOT NULL DEFAULT '1',
  `course_type_id` tinyint DEFAULT NULL,
  `studies_id` tinyint NOT NULL,
  PRIMARY KEY (`course_id`,`studies_id`),
  UNIQUE KEY `course_id_UNIQUE` (`course_id`),
  KEY `fk_courses_studies_id_idx` (`studies_id`),
  KEY `idx_course_id_course_studies_id_course_year_course_type_id` (`course_id`,`course`,`studies_id`,`course_year`,`course_type_id`),
  CONSTRAINT `fk_courses_studies_id` FOREIGN KEY (`studies_id`) REFERENCES `studies` (`studies_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `courses` VALUES (1,'introduction to sociology',1,1,1),(2,'introduction to sociology',1,1,3),(3,'introduction to sociology',1,1,5),(4,'modern political history of poland',1,2,1),(5,'modern political history of poland',1,2,3),(6,'modern political history of poland',1,2,5),(7,'english a1',1,3,1),(8,'english a1',1,3,3),(9,'english a1',1,3,5),(10,'modern political systems',2,1,1),(11,'modern political systems',2,1,3),(12,'modern political systems',2,1,5),(13,'political system of poland',2,2,1),(14,'political system of poland',2,2,3),(15,'political system of poland',2,2,5),(16,'english a2',2,3,1),(17,'english a2',2,3,3),(18,'english a2',2,3,5),(19,'history of political thought',3,1,1),(20,'history of political thought',3,1,3),(21,'history of political thought',3,1,5),(22,'techniques of political manipulation',3,2,1),(23,'techniques of political manipulation',3,2,3),(24,'techniques of political manipulation',3,2,5),(25,'english b1',3,3,1),(26,'english b1',3,3,3),(27,'english b1',3,3,5),(28,'theory of politics',1,1,2),(29,'theory of politics',1,1,4),(30,'theory of politics',1,1,6),(31,'social and cultural identities',1,2,2),(32,'social and cultural identities',1,2,4),(33,'social and cultural identities',1,2,6),(34,'english b2',1,3,2),(35,'english b2',1,3,4),(36,'english b2',1,3,6),(37,'media in the public sphere',2,1,2),(38,'media in the public sphere',2,1,4),(39,'media in the public sphere',2,1,6),(40,'political communication',2,2,2),(41,'political communication',2,2,4),(42,'political communication',2,2,6),(43,'english c1',2,3,2),(44,'english c1',2,3,4),(45,'english c1',2,3,6),(46,'political conflicts in africa',1,1,7),(47,'political conflicts in africa',1,1,8),(48,'english c2',1,3,7),(49,'english c2',1,3,8),(50,'political conflicts in south asia',2,1,7),(51,'political conflicts in south asia',2,1,8),(52,'russian b2',2,3,7),(53,'russian b2',2,3,8),(54,'paradigms in international relations',3,1,7),(55,'paradigms in international relations',3,1,8),(56,'russian c1',3,3,7),(57,'russian c1',3,3,8),(58,'intelligence services in international relations',4,1,7),(59,'intelligence services in international relations',4,1,8),(60,'russian c2',4,3,7),(61,'russian c2',4,3,8),(62,'introduction to programming languages',1,1,9),(63,'introduction to programming languages',1,1,11),(64,'introduction to programming languages',1,1,13),(65,'programming in python - basic level',1,2,9),(66,'programming in python - basic level',1,2,11),(67,'programming in python - basic level',1,2,13),(68,'english a1',1,3,9),(69,'english a1',1,3,11),(70,'english a1',1,3,13),(71,'relational databases and data analysis',2,1,9),(72,'relational databases and data analysis',2,1,11),(73,'relational databases and data analysis',2,1,13),(74,'programming in java - basic level',2,2,9),(75,'programming in java - basic level',2,2,11),(76,'programming in java - basic level',2,2,13),(77,'english a2',2,3,9),(78,'english a2',2,3,11),(79,'english a2',2,3,13),(80,'system integration',3,1,9),(81,'system integration',3,1,11),(82,'system integration',3,1,13),(83,'programming in c - basic level',3,2,9),(84,'programming in c - basic level',3,2,11),(85,'programming in c - basic level',3,2,13),(86,'english b1',3,3,9),(87,'english b1',3,3,11),(88,'english b1',3,3,13),(89,'introduction to agile software development',1,1,10),(90,'introduction to agile software development',1,1,12),(91,'introduction to agile software development',1,1,14),(92,'programming in python - advanced level',1,2,10),(93,'programming in python - advanced level',1,2,12),(94,'programming in python - advanced level',1,2,14),(95,'english b2',1,3,10),(96,'english b2',1,3,12),(97,'english b2',1,3,14),(98,'big data',2,1,10),(99,'big data',2,1,12),(100,'big data',2,1,14),(101,'programming in java - advanced level',2,2,10),(102,'programming in java - advanced level',2,2,12),(103,'programming in java - advanced level',2,2,14),(104,'english c1',2,3,10),(105,'english c1',2,3,12),(106,'english c1',2,3,14),(107,'introduction to bioinformatics',1,1,15),(108,'introduction to bioinformatics',1,1,16),(109,'introduction to bioinformatics',1,1,17),(110,'basic chemistry',1,2,15),(111,'basic chemistry',1,2,16),(112,'basic chemistry',1,2,17),(113,'english a1',1,3,15),(114,'english a1',1,3,16),(115,'english a1',1,3,17),(116,'cell biology',2,1,15),(117,'cell biology',2,1,16),(118,'cell biology',2,1,17),(119,'object-oriented programming',2,2,15),(120,'object-oriented programming',2,2,16),(121,'object-oriented programming',2,2,17),(122,'english a2',2,3,15),(123,'english a2',2,3,16),(124,'english a2',2,3,17),(125,'ecology',3,1,15),(126,'ecology',3,1,16),(127,'ecology',3,1,17),(128,'game theory',3,2,15),(129,'game theory',3,2,16),(130,'game theory',3,2,17),(131,'english b1',3,3,15),(132,'english b1',3,3,16),(133,'english b1',3,3,17),(134,'molecular biology',4,1,15),(135,'molecular biology',4,1,16),(136,'molecular biology',4,1,17),(137,'comparative genomics',4,2,15),(138,'comparative genomics',4,2,16),(139,'comparative genomics',4,2,17),(140,'english b2',4,3,15),(141,'english b2',4,3,16),(142,'english b2',4,3,17),(143,'stochastic simulations',5,1,15),(144,'stochastic simulations',5,1,16),(145,'stochastic simulations',5,1,17),(146,'data visualisation',5,2,15),(147,'data visualisation',5,2,16),(148,'data visualisation',5,2,17),(149,'english c1',5,3,15),(150,'english c1',5,3,16),(151,'english c1',5,3,17);

-- ----------------------------------------------------------------------------------------------------
-- evaluation_cards table [contains data on grades assigned to each student attending particular courses]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `evaluation_cards` (
  `index_id` mediumint NOT NULL,
  `course_id` smallint NOT NULL,
  `grade` tinyint DEFAULT NULL,
  PRIMARY KEY (`index_id`,`course_id`),
  KEY `fk_evaluation_cards_indexes1_idx` (`index_id`),
  KEY `fk_evaluation_cards_course_id_idx` (`course_id`),
  KEY `idx_index_id_course_id_grade` (`index_id`,`course_id`,`grade`),
  CONSTRAINT `fk_evaluation_cards_index_id` FOREIGN KEY (`index_id`) REFERENCES `indxs` (`index_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `evaluation_cards` VALUES 
(1,1,3),(1,4,4),(1,7,5),(2,1,2),(2,4,4),(2,7,3),(3,1,4),(3,4,3),(3,7,5),(4,1,3),(4,4,2),(4,7,3),(5,1,4),(5,4,4),(5,7,3),(6,1,4),(6,4,3),(6,7,5),(7,10,3),(7,13,3),(7,16,4),(8,10,5),(8,13,5),(8,16,4),(9,10,4),(9,13,4),(9,16,5),(10,10,4),(10,13,4),(10,16,3),(11,10,4),(11,13,5),(11,16,4),(12,10,4),(12,13,4),(12,16,5),(13,19,3),(13,22,5),(13,25,5),(14,19,4),(14,22,3),(14,25,3),(15,19,3),(15,22,4),(15,25,3),(16,19,4),(16,22,4),(16,25,5),(17,19,3),(17,22,3),(17,25,4),(18,19,5),(18,22,5),(18,25,4),(19,2,5),(19,5,5),(19,8,3),(20,2,5),(20,5,3),(20,8,3),(21,2,5),(21,5,4),(21,8,3),(22,2,3),(22,5,4),(22,8,3),(23,2,5),(23,5,3),(23,8,4),(24,2,3),(24,5,5),(24,8,4),(25,11,3),(25,14,5),(25,17,3),(26,11,3),(26,14,3),(26,17,5),(27,11,4),(27,14,3),(27,17,5),(28,11,4),(28,14,3),(28,17,3),(29,11,4),(29,14,4),(29,17,5),(30,11,5),(30,14,5),(30,17,5),(31,20,5),(31,23,5),(31,26,3),(32,20,4),(32,23,4),(32,26,5),(33,20,3),(33,23,3),(33,26,3),(34,20,4),(34,23,3),(34,26,5),(35,20,4),(35,23,5),(35,26,3),(36,20,3),(36,23,5),(36,26,4),(37,3,3),(37,6,3),(37,9,5),(38,3,5),(38,6,5),(38,9,4),(39,3,5),(39,6,3),(39,9,4),(40,3,5),(40,6,3),(40,9,5),(41,3,4),(41,6,5),(41,9,5),(42,3,5),(42,6,5),(42,9,3),(43,12,5),(43,15,4),(43,18,4),(44,12,5),(44,15,3),(44,18,4),(45,12,3),(45,15,4),(45,18,5),(46,12,3),(46,15,2),(46,18,3),(47,12,5),(47,15,4),(47,18,5),(48,12,3),(48,15,2),(48,18,4),(49,21,5),(49,24,5),(49,27,5),(50,21,5),(50,24,3),(50,27,3),(51,21,3),(51,24,3),(51,27,2),(52,21,5),(52,24,4),(52,27,3),(53,21,3),(53,24,4),(53,27,3),(54,21,4),(54,24,5),(54,27,3),(55,28,4),(55,31,3),(55,34,3),(56,28,4),(56,31,5),(56,34,3),(57,28,4),(57,31,3),(57,34,3),(58,28,3),(58,31,4),(58,34,5),(59,28,4),(59,31,5),(59,34,4),(60,28,4),(60,31,4),(60,34,3),(61,37,4),(61,40,5),(61,43,4),(62,37,5),(62,40,5),(62,43,5),(63,37,5),(63,40,4),(63,43,3),(64,37,5),(64,40,4),(64,43,4),(65,37,3),(65,40,3),(65,43,4),(66,37,5),(66,40,4),(66,43,5),(67,46,4),(67,48,5),(68,46,5),(68,48,5),(69,46,5),(69,48,4),(70,46,3),(70,48,5),(71,46,4),(71,48,4),(72,46,3),(72,48,4),(73,50,3),(73,52,4),(74,50,4),(74,52,4),(75,50,4),(75,52,3),(76,50,5),(76,52,5),(77,50,3),(77,52,3),(78,50,5),(78,52,4),(79,54,4),(79,56,5),(80,54,3),(80,56,4),(81,54,4),(81,56,4),(82,54,3),(82,56,5),(83,54,5),(83,56,3),(84,54,5),(84,56,5),(85,58,4),(85,60,5),(86,58,4),(86,60,5),(87,58,5),(87,60,4),(88,58,3),(88,60,4),(89,58,4),(89,60,5),(90,58,3),(90,60,3),(91,47,5),(91,49,5),(92,47,4),(92,49,3),(93,47,3),(93,49,4),(94,47,4),(94,49,5),(95,47,5),(95,49,3),(96,47,4),(96,49,5),(97,51,5),(97,53,5),(98,51,4),(98,53,5),(99,51,4),(99,53,4),(100,51,4),(100,53,3),(101,51,5),(101,53,5),(102,51,4),(102,53,5),(103,55,4),(103,57,3),(104,55,3),(104,57,4),(105,55,3),(105,57,3),(106,55,5),(106,57,3),(107,55,3),(107,57,3),(108,55,3),(108,57,4),(109,59,4),(109,61,4),(110,59,5),(110,61,3),(111,59,5),(111,61,5),(112,59,4),(112,61,5),(113,59,3),(113,61,4),(114,59,3),(114,61,3),(115,29,5),(115,32,5),(115,35,4),(116,29,4),(116,32,3),(116,35,4),(117,29,4),(117,32,3),(117,35,3),(118,29,4),(118,32,4),(118,35,4),(119,29,3),(119,32,3),(119,35,5),(120,29,3),(120,32,5),(120,35,5),(121,38,4),(121,41,3),(121,44,5),(122,38,5),(122,41,3),(122,44,5),(123,38,5),(123,41,3),(123,44,4),(124,38,4),(124,41,4),(124,44,3),(125,38,3),(125,41,3),(125,44,4),(126,38,4),(126,41,5),(126,44,5),(127,30,5),(127,33,5),(127,36,5),(128,30,4),(128,33,5),(128,36,5),(129,30,5),(129,33,5),(129,36,4),(130,30,4),(130,33,3),(130,36,5),(131,30,4),(131,33,4),(131,36,3),(132,30,5),(132,33,4),(132,36,5),(133,39,5),(133,42,4),(133,45,3),(134,39,3),(134,42,5),(134,45,4),(135,39,5),(135,42,3),(135,45,3),(136,39,3),(136,42,3),(136,45,5),(137,39,5),(137,42,5),(137,45,5),(138,39,4),(138,42,4),(138,45,3),(139,62,5),(139,65,3),(139,68,4),(140,62,2),(140,65,3),(140,68,3),(141,62,3),(141,65,4),(141,68,5),(142,62,5),(142,65,4),(142,68,4),(143,62,5),(143,65,3),(143,68,4),(144,62,4),(144,65,5),(144,71,5),(145,71,5),(145,74,3),(145,77,4),(146,71,2),(146,74,2),(146,77,2),(147,71,3),(147,74,5),(147,77,4),(148,71,4),(148,74,5),(148,77,5),(149,71,4),(149,74,4),(149,77,5),(150,71,3),(150,74,4),(150,77,4),(151,80,3),(151,83,3),(151,86,5),(152,80,5),(152,83,3),(152,86,3),(153,80,5),(153,83,5),(153,86,4),(154,80,4),(154,83,4),(154,86,3),(155,80,3),(155,83,3),(155,86,3),(156,80,5),(156,83,4),(156,86,3),(157,63,3),(157,66,5),(157,69,4),(158,63,5),(158,66,5),(158,69,3),(159,63,3),(159,66,4),(159,69,3),(160,63,4),(160,66,4),(160,69,3),(161,63,3),(161,66,4),(161,69,3),(162,63,3),(162,66,4),(162,69,4),(163,72,4),(163,75,3),(163,78,3),(164,72,3),(164,75,4),(164,78,3),(165,72,4),(165,75,3),(165,78,5),(166,72,5),(166,75,5),(166,78,3),(167,72,5),(167,75,4),(167,78,5),(168,72,5),(168,75,5),(168,78,5),(169,81,5),(169,84,4),(169,87,5),(170,81,4),(170,84,5),(170,87,3),(171,81,3),(171,84,3),(171,87,4),(172,81,4),(172,84,5),(172,87,5),(173,81,3),(173,84,3),(173,87,4),(174,81,3),(174,84,4),(174,87,3),(175,64,4),(175,67,4),(175,70,5),(176,64,5),(176,67,4),(176,70,4),(177,64,4),(177,67,4),(177,70,4),(178,64,3),(178,67,3),(178,70,5),(179,64,5),(179,67,4),(179,70,4),(180,64,5),(180,67,3),(180,70,3),(181,73,4),(181,76,4),(181,79,4),(182,73,5),(182,76,4),(182,79,5),(183,73,5),(183,76,4),(183,79,4),(184,73,4),(184,76,3),(184,79,4),(185,73,4),(185,76,5),(185,79,5),(186,73,4),(186,76,4),(186,79,3),(187,82,5),(187,85,4),(187,88,3),(188,91,3),(188,94,3),(188,97,4),(189,100,3),(189,103,3),(189,106,5),(190,109,4),(190,112,4),(190,115,5),(191,118,3),(191,121,4),(191,124,5),(192,127,3),(192,130,5),(192,133,5),(193,89,5),(193,92,3),(193,95,4),(194,89,4),(194,92,4),(194,95,3),(195,89,5),(195,92,5),(195,95,3),(196,89,4),(196,92,5),(196,95,3),(197,89,5),(197,92,3),(197,95,3),(198,89,5),(198,92,4),(198,95,5),(199,98,3),(199,101,5),(199,104,5),(200,98,3),(200,101,3),(200,104,5),(201,98,4),(201,101,5),(201,104,3),(202,98,4),(202,101,5),(202,104,5),(203,98,3),(203,101,4),(203,104,3),(204,98,5),(204,101,4),(204,104,3),(205,90,4),(205,93,5),(205,96,4),(206,90,3),(206,93,4),(206,96,5),(207,90,4),(207,93,5),(207,96,5),(208,90,5),(208,93,5),(208,96,4),(209,90,5),(209,93,3),(209,96,5),(210,90,3),(210,93,4),(210,96,4),(211,99,3),(211,102,3),(211,105,4),(212,99,5),(212,102,4),(212,105,5),(213,99,4),(213,102,5),(213,105,4),(214,99,5),(214,102,5),(214,105,4),(215,99,3),(215,102,5),(215,105,3),(216,99,3),(216,102,4),(216,105,5),(217,91,3),(217,94,3),(217,97,3),(218,91,4),(218,94,5),(218,97,4),(219,91,3),(219,94,3),(219,97,3),(220,91,5),(220,94,3),(220,97,5),(221,91,3),(221,94,4),(221,97,4),(222,91,4),(222,94,4),(222,97,5),(223,100,4),(223,103,3),(223,106,5),(224,100,4),(224,103,4),(224,106,4),(225,100,3),(225,103,5),(225,106,5),(226,100,4),(226,103,5),(226,106,4),(227,100,4),(227,103,5),(227,106,5),(228,100,5),(228,103,3),(228,106,3),(229,107,3),(229,110,4),(229,113,3),(230,107,5),(230,110,5),(230,113,4),(231,107,5),(231,110,3),(231,113,4),(232,107,4),(232,110,5),(232,113,3),(233,107,3),(233,110,3),(233,113,3),(234,107,3),(234,110,5),(234,113,5),(235,116,3),(235,119,4),(235,122,5),(236,116,3),(236,119,5),(236,122,5),(237,116,5),(237,119,3),(237,122,4),(238,116,3),(238,119,3),(238,122,3),(239,116,4),(239,119,3),(239,122,5),(240,116,5),(240,119,4),(240,122,3),(241,125,5),(241,128,5),(241,131,5),(242,125,3),(242,128,3),(242,131,5),(243,125,3),(243,128,4),(243,131,4),(244,125,5),(244,128,3),(244,131,4),(245,125,4),(245,128,3),(245,131,5),(246,125,4),(246,128,5),(246,131,5),(247,134,4),(247,137,5),(247,140,3),(248,134,3),(248,137,5),(248,140,4),(249,134,4),(249,137,5),(249,140,5),(250,134,3),(250,137,3),(250,140,5),(251,134,3),(251,137,3),(251,140,3),(252,134,3),(252,137,3),(252,140,3),(253,143,4),(253,146,4),(253,149,5),(254,143,3),(254,146,4),(254,149,4),(255,143,3),(255,146,4),(255,149,4),(256,143,4),(256,146,5),(256,149,4),(257,143,3),(257,146,5),(257,149,5),(258,143,3),(258,146,4),(258,149,4),(259,108,4),(259,111,4),(259,114,5),(260,108,3),(260,111,4),(260,114,5),(261,108,5),(261,111,4),(261,114,5),(262,108,3),(262,111,5),(262,114,4),(263,108,5),(263,111,4),(263,114,3),(264,108,4),(264,111,5),(264,114,4),(265,117,3),(265,120,3),(265,123,5),(266,117,5),(266,120,4),(266,123,5),(267,117,3),(267,120,5),(267,123,3),(268,117,4),(268,120,5),(268,123,4),(269,117,5),(269,120,3),(269,123,5),(270,117,5),(270,120,5),(270,123,4),(271,126,4),(271,129,3),(271,132,3),(272,126,3),(272,129,4),(272,132,5),(273,126,5),(273,129,3),(273,132,4),(274,126,3),(274,129,4),(274,132,4),(275,126,5),(275,129,5),(275,132,5),(276,126,3),(276,129,4),(276,132,3),(277,135,5),(277,138,4),(277,141,3),(278,135,3),(278,138,5),(278,141,5),(279,135,5),(279,138,3),(279,141,5),(280,135,4),(280,138,5),(280,141,3),(281,135,4),(281,138,5),(281,141,3),(282,135,3),(282,138,3),(282,141,5),(283,144,3),(283,147,3),(283,150,4),(284,144,3),(284,147,4),(284,150,5),(285,144,4),(285,147,4),(285,150,3),(286,144,4),(286,147,4),(286,150,3),(287,144,5),(287,147,5),(287,150,3),(288,144,4),(288,147,3),(288,150,3),(289,109,5),(289,112,3),(289,115,3),(290,109,4),(290,112,4),(290,115,3),(291,109,4),(291,112,5),(291,115,3),(292,109,5),(292,112,3),(292,115,3),(293,109,5),(293,112,5),(293,115,4),(294,109,4),(294,112,4),(294,115,5),(295,118,3),(295,121,4),(295,124,3),(296,118,5),(296,121,3),(296,124,5),(297,118,3),(297,121,5),(297,124,5),(298,118,3),(298,121,3),(298,124,4),(299,118,4),(299,121,3),(299,124,4),(300,118,3),(300,121,5),(300,124,4),(301,127,4),(301,130,3),(301,133,3),(302,127,4),(302,130,3),(302,133,5),(303,127,4),(303,130,4),(303,133,3),(304,127,5),(304,130,5),(304,133,5),(305,127,4),(305,130,3),(305,133,3),(306,127,4),(306,130,5),(306,133,4),(307,136,3),(307,139,4),(307,142,3),(308,136,5),(308,139,4),(308,142,3),(309,136,5),(309,139,4),(309,142,3),(310,136,5),(310,139,3),(310,142,5),(311,136,4),(311,139,4),(311,142,4),(312,136,4),(312,139,5),(312,142,3),(313,145,5),(313,148,4),(313,151,3),(314,145,3),(314,148,3),(314,151,5),(315,145,4),(315,148,5),(315,151,5),(316,145,3),(316,148,3),(316,151,3),(317,145,4),(317,148,5),(317,151,3),(318,145,4),(318,148,3),(318,151,4);

-- CREATE TRIGGER ON evaluation_cards [contains 2 triggers which prevent from inserting/updating `grade` column with invalid grades]

DELIMITER $$
CREATE TRIGGER invalid_grade_insert
BEFORE INSERT ON evaluation_cards
FOR EACH ROW
BEGIN
IF(NEW.grade <2 OR NEW.grade >5) THEN
	SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 'Invalid grade inserted';
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER invalid_grade_update
BEFORE UPDATE ON evaluation_cards
FOR EACH ROW
BEGIN
IF(NEW.grade <2 OR NEW.grade >5) THEN
	SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 'Invalid grade inserted';
	END IF;
END $$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------
-- lecturers table [contains data on lecturers with details regarding lecturers]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `lecturers` (
  `lecturer_id` smallint NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `faculty_id` tinyint NOT NULL,
  PRIMARY KEY (`lecturer_id`),
  UNIQUE KEY `lecturer_id_UNIQUE` (`lecturer_id`),
  KEY `fk_lecturers_faculty_id_idx` (`faculty_id`),
  KEY `idx_last_name_faculty_id` (`last_name`,`faculty_id`)
) ENGINE=InnoDB;

INSERT INTO `lecturers` VALUES (1,'Gabriel','Swietlik',1),(2,'Przemyslaw','Homa',1),(3,'Jacek','Zon',1),(4,'Dariusz','Grzechnik',1),(5,'Miroslaw','Smiechowski',1),(6,'Grzegorz','Ledwon',1),(7,'Tadeusz','Janosz',1),(8,'Kamila','Kalinowska',1),(9,'Karol','Rusnak',1),(10,'Dawid','Stepaniuk',1),(11,'Robert','Kobylecki',1),(12,'Jakub','Malanowski',1),(13,'Emilia','Walczak',1),(14,'Kinga','Szczepanska',1),(15,'Angelika','Kaczmarczyk',1),(16,'Leon','Wodecki',1),(17,'Boguslaw','Wawrzynczak',1),(18,'Aleksandra','Krawczyk',1),(19,'Dorota','Nowakowska',1),(20,'Henryka','Glowacka',1),(21,'Hanna','Sikora',1),(22,'Zenon','Kosiorowski',1),(23,'Wladyslawa','Marciniak',1),(24,'Paulina','Stepien',1),(25,'Jadwiga','Jankowska',1),(26,'Piotr','Krasniewski',1),(27,'Oskar','Krzyzowski',1),(28,'Gabriela','Chmielewska',1),(29,'Lukasz','Bargiel',1),(30,'Malgorzata','Wojcik',1),(31,'Henryk','Skubisz',1),(32,'Kazimierz','Dettlaff',1),(33,'Barbara','Kaminska',1),(34,'Bronislawa','Mazurek',1),(35,'Laura','Adamska',1),(36,'Sylwia','Ostrowska',1),(37,'Jolanta','Adamczyk',1),(38,'Janusz','Kura',1),(39,'Lena','Lis',1),(40,'Krzysztof','Mlynek',1),(41,'Marianna','Wojciechowska',1),(42,'Filip','Szeremeta',1),(43,'Franciszek','Hirsz',1),(44,'Maksymilian','Schab',1),(45,'Jozef','Koscinski',1),(46,'Roman','Sobol',2),(47,'Krystyna','Kowalczyk',2),(48,'Zbigniew','Wyrwa',2),(49,'Kacper','Swies',2),(50,'Mieczyslaw','Ociepka',2),(51,'Ludwik','Koscielski',2),(52,'Teresa','Kozlowska',2),(53,'Andrzej','Latocha',2),(54,'Maja','Jasinska',2),(55,'Marzena','Wilk',2),(56,'Lidia','Czarnecka',2),(57,'Damian','Dwojak',2),(58,'Marta','Krol',2),(59,'Eugenia','Baranowska',2),(60,'Mikolaj','Karasek',2),(61,'Maciej','Pamula',2),(62,'Stefan','Maryniak',2),(63,'Amelia','Maciejewska',2),(64,'Stanislawa','Pawlowska',2),(65,'Aniela','Kucharska',2),(66,'Iwona','Jaworska',2),(67,'Wanda','Michalak',2),(68,'Joanna','Kwiatkowska',2),(69,'Irena','Kaczmarek',2),(70,'Krystian','Sulkowski',2),(71,'Leszek','Leczycki',2),(72,'Ignacy','Budziak',2),(73,'Wioletta','Wasilewska',2),(74,'Danuta','Grabowska',2),(75,'Stanislaw','Bijak',2),(76,'Radoslaw','Dembski',2),(77,'Bogdan','Golba',2),(78,'Nikola','Ziolkowska',2),(79,'Helena','Wozniak',2),(80,'Alina','Kubiak',2),(81,'Sandra','Borowska',2),(82,'Patrycja','Pietrzak',2),(83,'Wieslawa','Borkowska',2),(84,'Franciszka','Przybylska',2),(85,'Edward','Juskowiak',2),(86,'Sabina','Zakrzewska',2),(87,'Aleksander','Glazewski',2),(88,'Gertruda','Kania',2),(89,'Oliwia','Duda',2),(90,'Artur','Rasinski',2),(91,'Daria','Laskowska',2),(92,'Rozalia','Szymczak',2),(93,'Arkadiusz','Polishchuk',2),(94,'Wojciech','Gadzinski',2),(95,'Zuzanna','Witkowska',2);

-- ----------------------------------------------------------------------------------------------------
-- grps table [contains data on groups assigned to courses & lecturers]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `grps` (
  `group_id` smallint NOT NULL,
  `lecturer_id` smallint DEFAULT NULL,
  `course_id` smallint NOT NULL,
  `group_no` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `group_id_UNIQUE` (`group_id`),
  KEY `fk_grps_lecturer_id_idx` (`lecturer_id`),
  KEY `fk_grps_course_id_idx` (`course_id`),
  CONSTRAINT `fk_grps_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_grps_lecturer_id` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`lecturer_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `grps` VALUES 
(1,35,1,1),(2,35,2,1),(3,35,3,1),(4,6,4,1),(5,28,4,2),(6,9,5,1),(7,34,5,2),(8,24,6,1),(9,14,6,2),(10,8,7,1),(11,44,7,2),(12,42,8,1),(13,12,8,2),(14,23,9,1),(15,29,9,2),(16,33,10,1),(17,33,11,1),(18,33,12,1),(19,27,13,1),(20,17,13,2),(21,20,14,1),(22,22,14,2),(23,25,15,1),(24,32,15,2),(25,12,16,1),(26,23,16,2),(27,29,17,1),(28,8,17,2),(29,44,18,1),(30,42,18,2),(31,31,19,1),(32,31,20,1),(33,31,21,1),(34,21,22,1),(35,15,22,2),(36,18,23,1),(37,39,23,2),(38,26,24,1),(39,11,24,2),(40,12,25,1),(41,29,25,2),(42,44,26,1),(43,23,26,2),(44,8,27,1),(45,42,27,2),(46,37,28,1),(47,37,29,1),(48,37,30,1),(49,30,31,1),(50,19,31,2),(51,40,32,1),(52,10,32,2),(53,1,33,1),(54,45,33,2),(55,12,34,1),(56,29,34,2),(57,8,35,1),(58,42,35,2),(59,44,36,1),(60,23,36,2),(61,2,37,1),(62,2,38,1),(63,2,39,1),(64,3,40,1),(65,43,40,2),(66,4,41,1),(67,41,41,2),(68,5,42,1),(69,38,42,2),(70,23,43,1),(71,44,43,2),(72,42,44,1),(73,8,44,2),(74,29,45,1),(75,12,45,2),(76,7,46,1),(77,7,47,1),(78,42,48,1),(79,44,49,1),(80,36,50,1),(81,36,51,1),(82,23,52,1),(83,8,53,1),(84,13,54,1),(85,13,55,1),(86,23,56,1),(87,44,57,1),(88,16,58,1),(89,16,59,1),(90,44,60,1),(91,23,61,1),(100,56,62,1),(101,56,63,1),(102,56,64,1),(103,75,65,1),(104,48,65,2),(105,74,66,1),(106,53,66,2),(107,94,67,1),(108,82,67,2),(109,46,68,1),(110,69,68,2),(111,84,69,1),(112,87,69,2),(113,52,70,1),(114,92,70,2),(115,54,71,1),(116,54,72,1),(117,54,73,1),(118,86,74,1),(119,76,74,2),(120,65,75,1),(121,91,75,2),(122,90,76,1),(123,59,76,2),(124,87,77,1),(125,84,77,2),(126,69,78,1),(127,46,78,2),(128,92,79,1),(129,52,79,2),(130,95,80,1),(131,95,81,1),(132,95,82,1),(133,71,83,1),(134,83,83,2),(135,55,84,1),(136,50,84,2),(137,81,85,1),(138,89,85,2),(139,52,86,1),(140,92,86,2),(141,46,87,1),(142,69,87,2),(143,84,88,1),(144,87,88,2),(145,93,89,1),(146,93,90,1),(147,93,91,1),(148,85,92,1),(149,88,92,2),(150,62,93,1),(151,73,93,2),(152,47,94,1),(153,80,94,2),(154,46,95,1),(155,69,95,2),(156,52,96,1),(157,92,96,2),(158,84,97,1),(159,87,97,2),(160,49,98,1),(161,49,99,1),(162,49,100,1),(163,79,101,1),(164,51,101,2),(165,78,102,1),(166,57,102,2),(167,77,103,1),(168,58,103,2),(169,87,104,1),(170,46,104,2),(171,84,105,1),(172,69,105,2),(173,92,106,1),(174,52,106,2),(175,60,107,1),(176,60,108,1),(177,60,109,1),(178,72,110,1),(179,61,110,2),(180,70,111,1),(181,63,111,2),(182,68,112,1),(183,64,112,2),(184,52,113,1),(185,46,113,2),(186,92,114,1),(187,84,114,2),(188,87,115,1),(189,69,115,2),(190,66,116,1),(191,66,117,1),(192,66,118,1),(193,67,119,1),(194,74,119,2),(195,53,120,1),(196,70,120,2),(197,50,121,1),(198,72,121,2),(199,69,122,1),(200,46,122,2),(201,92,123,1),(202,84,123,2),(203,87,124,1),(204,52,124,2),(205,56,125,1),(206,56,126,1),(207,56,127,1),(208,74,128,1),(209,62,128,2),(210,78,129,1),(211,82,129,2),(212,58,130,1),(213,76,130,2),(214,84,131,1),(215,87,131,2),(216,52,132,1),(217,69,132,2),(218,46,133,1),(219,92,133,2),(220,60,134,1),(221,60,135,1),(222,60,136,1),(223,77,137,1),(224,48,137,2),(225,55,138,1),(226,47,138,2),(227,63,139,1),(228,83,139,2),(229,46,140,1),(230,92,140,2),(231,84,141,1),(232,87,141,2),(233,69,142,1),(234,52,142,2),(235,54,143,1),(236,54,144,1),(237,54,145,1),(238,86,146,1),(239,78,146,2),(240,72,147,1),(241,68,147,2),(242,89,148,1),(243,59,148,2),(244,92,149,1),(245,69,149,2),(246,52,150,1),(247,46,150,2),(248,84,151,1),(249,87,151,2);

-- ----------------------------------------------------------------------------------------------------
-- grps_participants table [contains data on students assigned to groups which they are attending]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE `grps_participants` (
  `index_id` mediumint NOT NULL,
  `group_id` smallint NOT NULL,
  PRIMARY KEY (`index_id`,`group_id`),
  KEY `fk_grps_has_indexes_indexes1_idx` (`index_id`),
  KEY `fk_groupds_participants_group_id_idx` (`group_id`),
  CONSTRAINT `fk_grps_participants_index_id` FOREIGN KEY (`index_id`) REFERENCES `indxs` (`index_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `grps_participants` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(19,2),(20,2),(21,2),(22,2),(23,2),(24,2),(37,3),(38,3),(39,3),(40,3),(41,3),(42,3),(1,4),(2,4),(5,4),(3,5),(4,5),(6,5),(19,6),(20,6),(21,6),(22,7),(23,7),(24,7),(37,8),(39,8),(41,8),(38,9),(40,9),(42,9),(1,10),(2,10),(6,10),(3,11),(4,11),(5,11),(19,12),(21,12),(24,12),(20,13),(22,13),(23,13),(38,14),(39,14),(42,14),(37,15),(40,15),(41,15),(7,16),(8,16),(9,16),(10,16),(11,16),(12,16),(25,17),(26,17),(27,17),(28,17),(29,17),(30,17),(43,18),(44,18),(45,18),(46,18),(47,18),(48,18),(8,19),(10,19),(12,19),(7,20),(9,20),(11,20),(28,21),(29,21),(30,21),(25,22),(26,22),(27,22),(43,23),(44,23),(46,23),(45,24),(47,24),(48,24),(9,25),(11,25),(12,25),(7,26),(8,26),(10,26),(28,27),(29,27),(30,27),(25,28),(26,28),(27,28),(43,29),(44,29),(45,29),(46,30),(47,30),(48,30),(13,31),(14,31),(15,31),(16,31),(17,31),(18,31),(31,32),(32,32),(33,32),(34,32),(35,32),(36,32),(49,33),(50,33),(51,33),(52,33),(53,33),(54,33),(13,34),(14,34),(16,34),(15,35),(17,35),(18,35),(31,36),(32,36),(33,36),(34,37),(35,37),(36,37),(49,38),(50,38),(53,38),(51,39),(52,39),(54,39),(14,40),(15,40),(18,40),(13,41),(16,41),(17,41),(34,42),(35,42),(36,42),(31,43),(32,43),(33,43),(52,44),(53,44),(54,44),(49,45),(50,45),(51,45),(55,46),(56,46),(57,46),(58,46),(59,46),(60,46),(115,47),(116,47),(117,47),(118,47),(119,47),(120,47),(127,48),(128,48),(129,48),(130,48),(131,48),(132,48),(55,49),(57,49),(59,49),(56,50),(58,50),(60,50),(115,51),(116,51),(117,51),(118,52),(119,52),(120,52),(127,53),(128,53),(129,53),(130,54),(131,54),(132,54),(56,55),(57,55),(58,55),(55,56),(59,56),(60,56),(115,57),(117,57),(119,57),(116,58),(118,58),(120,58),(130,59),(131,59),(132,59),(127,60),(128,60),(129,60),(61,61),(62,61),(63,61),(64,61),(65,61),(66,61),(121,62),(122,62),(123,62),(124,62),(125,62),(126,62),(133,63),(134,63),(135,63),(136,63),(137,63),(138,63),(61,64),(62,64),(63,64),(64,65),(65,65),(66,65),(124,66),(125,66),(126,66),(121,67),(122,67),(123,67),(134,68),(136,68),(138,68),(133,69),(135,69),(137,69),(64,70),(65,70),(66,70),(61,71),(62,71),(63,71),(121,72),(123,72),(124,72),(122,73),(125,73),(126,73),(134,74),(136,74),(137,74),(133,75),(135,75),(138,75),(67,76),(68,76),(69,76),(70,76),(71,76),(72,76),(91,77),(92,77),(93,77),(94,77),(95,77),(96,77),(67,78),(68,78),(69,78),(70,78),(71,78),(72,78),(91,79),(92,79),(93,79),(94,79),(95,79),(96,79),(73,80),(74,80),(75,80),(76,80),(77,80),(78,80),(97,81),(98,81),(99,81),(100,81),(101,81),(102,81),(73,82),(74,82),(75,82),(76,82),(77,82),(78,82),(97,83),(98,83),(99,83),(100,83),(101,83),(102,83),(79,84),(80,84),(81,84),(82,84),(83,84),(84,84),(103,85),(104,85),(105,85),(106,85),(107,85),(108,85),(79,86),(80,86),(81,86),(82,86),(83,86),(84,86),(103,87),(104,87),(105,87),(106,87),(107,87),(108,87),(85,88),(86,88),(87,88),(88,88),(89,88),(90,88),(109,89),(110,89),(111,89),(112,89),(113,89),(114,89),(85,90),(86,90),(87,90),(88,90),(89,90),(90,90),(109,91),(110,91),(111,91),(112,91),(113,91),(114,91),(139,100),(140,100),(141,100),(142,100),(143,100),(144,100),(157,101),(158,101),(159,101),(160,101),(161,101),(162,101),(175,102),(176,102),(177,102),(178,102),(179,102),(180,102),(139,103),(140,103),(141,103),(142,104),(143,104),(144,104),(160,105),(161,105),(162,105),(157,106),(158,106),(159,106),(175,107),(177,107),(179,107),(176,108),(178,108),(180,108),(139,109),(141,109),(143,109),(140,110),(142,110),(144,110),(157,111),(158,111),(162,111),(159,112),(160,112),(161,112),(175,113),(177,113),(179,113),(176,114),(178,114),(180,114),(145,115),(146,115),(147,115),(148,115),(149,115),(150,115),(163,116),(164,116),(165,116),(166,116),(167,116),(168,116),(181,117),(182,117),(183,117),(184,117),(185,117),(186,117),(145,118),(146,118),(147,118),(148,119),(149,119),(150,119),(166,120),(167,120),(168,120),(163,121),(164,121),(165,121),(181,122),(183,122),(185,122),(182,123),(184,123),(186,123),(145,124),(147,124),(149,124),(146,125),(148,125),(150,125),(163,126),(164,126),(168,126),(165,127),(166,127),(167,127),(181,128),(183,128),(185,128),(182,129),(184,129),(186,129),(151,130),(152,130),(153,130),(154,130),(155,130),(156,130),(169,131),(170,131),(171,131),(172,131),(173,131),(174,131),(187,132),(188,132),(189,132),(190,132),(191,132),(192,132),(151,133),(152,133),(153,133),(154,134),(155,134),(156,134),(172,135),(173,135),(174,135),(169,136),(170,136),(171,136),(187,137),(189,137),(191,137),(188,138),(190,138),(192,138),(151,139),(153,139),(155,139),(152,140),(154,140),(156,140),(169,141),(170,141),(174,141),(171,142),(172,142),(173,142),(187,143),(189,143),(191,143),(188,144),(190,144),(192,144),(193,145),(194,145),(195,145),(196,145),(197,145),(198,145),(205,146),(206,146),(207,146),(208,146),(209,146),(210,146),(217,147),(218,147),(219,147),(220,147),(221,147),(222,147),(193,148),(194,148),(197,148),(195,149),(196,149),(198,149),(206,150),(208,150),(209,150),(205,151),(207,151),(210,151),(217,152),(219,152),(221,152),(218,153),(220,153),(222,153),(193,154),(195,154),(198,154),(194,155),(196,155),(197,155),(208,156),(209,156),(210,156),(205,157),(206,157),(207,157),(220,158),(221,158),(222,158),(217,159),(218,159),(219,159),(199,160),(200,160),(201,160),(202,160),(203,160),(204,160),(211,161),(212,161),(213,161),(214,161),(215,161),(216,161),(223,162),(224,162),(225,162),(226,162),(227,162),(228,162),(199,163),(200,163),(203,163),(201,164),(202,164),(204,164),(212,165),(214,165),(215,165),(211,166),(213,166),(216,166),(223,167),(225,167),(227,167),(224,168),(226,168),(228,168),(199,169),(201,169),(204,169),(200,170),(202,170),(203,170),(214,171),(215,171),(216,171),(211,172),(212,172),(213,172),(226,173),(227,173),(228,173),(223,174),(224,174),(225,174),(229,175),(230,175),(231,175),(232,175),(233,175),(234,175),(259,176),(260,176),(261,176),(262,176),(263,176),(264,176),(289,177),(290,177),(291,177),(292,177),(293,177),(294,177),(229,178),(230,178),(233,178),(231,179),(232,179),(234,179),(262,180),(263,180),(264,180),(259,181),(260,181),(261,181),(289,182),(291,182),(293,182),(290,183),(292,183),(294,183),(232,184),(233,184),(234,184),(229,185),(230,185),(231,185),(259,186),(260,186),(261,186),(262,187),(263,187),(264,187),(290,188),(292,188),(294,188),(289,189),(291,189),(293,189),(235,190),(236,190),(237,190),(238,190),(239,190),(240,190),(265,191),(266,191),(267,191),(268,191),(269,191),(270,191),(295,192),(296,192),(297,192),(298,192),(299,192),(300,192),(235,193),(236,193),(239,193),(237,194),(238,194),(240,194),(268,195),(269,195),(270,195),(265,196),(266,196),(267,196),(295,197),(297,197),(299,197),(296,198),(298,198),(300,198),(238,199),(239,199),(240,199),(235,200),(236,200),(237,200),(265,201),(266,201),(267,201),(268,202),(269,202),(270,202),(296,203),(298,203),(300,203),(295,204),(297,204),(299,204),(241,205),(242,205),(243,205),(244,205),(245,205),(246,205),(271,206),(272,206),(273,206),(274,206),(275,206),(276,206),(301,207),(302,207),(303,207),(304,207),(305,207),(306,207),(241,208),(242,208),(245,208),(243,209),(244,209),(246,209),(274,210),(275,210),(276,210),(271,211),(272,211),(273,211),(301,212),(303,212),(305,212),(302,213),(304,213),(306,213),(244,214),(245,214),(246,214),(241,215),(242,215),(243,215),(271,216),(272,216),(273,216),(274,217),(275,217),(276,217),(302,218),(304,218),(306,218),(301,219),(303,219),(305,219),(247,220),(248,220),(249,220),(250,220),(251,220),(252,220),(277,221),(278,221),(279,221),(280,221),(281,221),(282,221),(307,222),(308,222),(309,222),(310,222),(311,222),(312,222),(247,223),(248,223),(251,223),(249,224),(250,224),(252,224),(280,225),(281,225),(282,225),(277,226),(278,226),(279,226),(307,227),(309,227),(311,227),(308,228),(310,228),(312,228),(250,229),(251,229),(252,229),(247,230),(248,230),(249,230),(277,231),(278,231),(279,231),(280,232),(281,232),(282,232),(308,233),(310,233),(312,233),(307,234),(309,234),(311,234),(253,235),(254,235),(255,235),(256,235),(257,235),(258,235),(283,236),(284,236),(285,236),(286,236),(287,236),(288,236),(313,237),(314,237),(315,237),(316,237),(317,237),(318,237),(253,238),(254,238),(257,238),(255,239),(256,239),(258,239),(286,240),(287,240),(288,240),(283,241),(284,241),(285,241),(313,242),(315,242),(317,242),(314,243),(316,243),(318,243),(256,244),(257,244),(258,244),(253,245),(254,245),(255,245),(283,246),(284,246),(285,246),(286,247),(287,247),(288,247),(314,248),(316,248),(318,248),(313,249),(315,249),(317,249);

-- ----------------------------------------------------------------------------------------------------
-- university_grades views [contains 2 exemplary views which display groups assigned to a particular lecturer, including details regarding groups' affiliation + extra column containing info about each group's number of attendees]
-- ----------------------------------------------------------------------------------------------------

-- CREATE VIEW view_grps_of_lecturer_1

CREATE VIEW view_grps_of_lecturer_1 AS
SELECT group_id, course, major, degree, university_grades.modes.mode, faculty, course_year, COUNT(university_grades.grps.lecturer_id) AS no_of_students
FROM university_grades.grps_participants gp
JOIN university_grades.grps USING (group_id)
JOIN university_grades.courses USING (course_id)
JOIN university_grades.course_types USING (course_type_id)
JOIN university_grades.studies USING (studies_id)
JOIN university_grades.majors USING (major_id)
JOIN university_grades.degrees USING (degree_id)
JOIN university_grades.modes USING (mode_id)
JOIN university_grades.faculties USING (faculty_id)
WHERE university_grades.grps.lecturer_id = 1
GROUP BY gp.group_id;

-- CREATE VIEW view_grps_of_lecturer_69

CREATE VIEW view_grps_of_lecturer_69 AS
SELECT group_id, course, major, degree, university_grades.modes.mode, faculty, course_year, COUNT(university_grades.grps.lecturer_id) AS no_of_students
FROM university_grades.grps_participants gp
JOIN university_grades.grps USING (group_id)
JOIN university_grades.courses USING (course_id)
JOIN university_grades.course_types USING (course_type_id)
JOIN university_grades.studies USING (studies_id)
JOIN university_grades.majors USING (major_id)
JOIN university_grades.degrees USING (degree_id)
JOIN university_grades.modes USING (mode_id)
JOIN university_grades.faculties USING (faculty_id)
WHERE university_grades.grps.lecturer_id = 69
GROUP BY gp.group_id;

-- ----------------------------------------------------------------------------------------------------
-- university_grades procedures
-- ----------------------------------------------------------------------------------------------------

-- CREATE PROCEDURE get_average_grades_by_studies_year [returns list containing average grades of students from selected studies by year; parameters: studies_id, academic_year]

DELIMITER $$
CREATE PROCEDURE `get_average_grades_by_studies_year`(PARstudies tinyint, PARyear tinyint)
BEGIN
SELECT 	ec.index_id, i.first_name, i.last_name, 
		ROUND(AVG(grade), 2) AS average_grade, 
        CONCAT_WS(", ", major, degree, mo.mode) AS studies, academic_year 
        FROM evaluation_cards ec

JOIN university_grades.indxs i USING (index_id)
JOIN courses c USING (course_id)
JOIN studies s ON c.studies_id = s.studies_id
JOIN faculties f USING (faculty_id)
JOIN majors ma USING (major_id)
JOIN degrees d USING (degree_id)
JOIN modes mo USING (mode_id)
WHERE s.studies_id = PARstudies AND academic_year = PARyear AND grade IS NOT NULL
GROUP BY index_id;
END $$
DELIMITER ;

-- CREATE PROCEDURE get_failed_courses [returns list containing students which received 2 grade on one or more courses, including data on courses and details regarding courses affiliation to exact studies; parameters: studies_id, academic_year]

DELIMITER $$
CREATE PROCEDURE `get_failed_courses`(PARstudies tinyint, PARyear tinyint)
BEGIN
SELECT 	index_id, 
		CONCAT_WS(" ", first_name, last_name) AS student, 
        CONCAT_WS(", ", course, course_type) AS course, 
        CONCAT_WS(", ", major, degree, mode) AS studies, 
        academic_year 
        FROM evaluation_cards

JOIN university_grades.indxs USING (index_id)
JOIN courses c USING (course_id)
JOIN course_types USING (course_type_id)
JOIN studies s ON c.studies_id = s.studies_id
JOIN majors USING (major_id)
JOIN degrees USING (degree_id)
JOIN modes USING (mode_id)

WHERE grade = 2
AND s.studies_id = PARstudies
AND academic_year = PARyear;
END $$
DELIMITER ;

-- CREATE PROCEDURE get_group_participants [returns list containing detailed info on participants of selected group, including details regarding group affiliation to exact course; parameters: group_id]

DELIMITER $$
CREATE PROCEDURE `get_group_participants`(PARgroup smallint)
BEGIN
SELECT 	group_id, index_id, 
        CONCAT_WS(" ", i.first_name, i.last_name) AS name, 
        CONCAT_WS(", ", course, course_type) AS course, 
        group_no, 
        CONCAT_WS(", ", major, degree, mode) AS studies, 
        academic_year 
        FROM university_grades.grps_participants

JOIN university_grades.indxs i USING (index_id)
JOIN university_grades.grps USING (group_id)
JOIN university_grades.courses c USING (course_id)
JOIN university_grades.course_types USING (course_type_id)
JOIN university_grades.studies s ON s.studies_id = c.studies_id
JOIN university_grades.majors USING (major_id)
JOIN university_grades.degrees USING (degree_id)
JOIN university_grades.modes USING (mode_id)
WHERE group_id = PARgroup;
END $$
DELIMITER ;

-- CREATE PROCEDURE get_scholarship_candidates [returns list containing 3 students with highest average grade for selected studies by year; parameters: studies_id, academic_year]

DELIMITER $$
CREATE PROCEDURE `get_scholarship_candidates`(PARstudies_id TINYINT, PARacademic_year TINYINT)
BEGIN
SELECT index_id, first_name, last_name, AVG(grade) AS average_grade, CONCAT_WS(", ", major, degree, mode) AS studies, academic_year FROM evaluation_cards
JOIN university_grades.indxs USING (index_id)
JOIN studies USING (studies_id)
JOIN majors USING (major_id)
JOIN degrees USING (degree_id)
JOIN modes USING (mode_id)
WHERE grade > (SELECT AVG(grade) FROM evaluation_cards WHERE studies_id = PARstudies_id AND academic_year = PARacademic_year AND grade IS NOT NULL)
AND studies_id = PARstudies_id
AND academic_year = PARacademic_year
GROUP BY index_id
ORDER BY AVG(grade) DESC
LIMIT 3;
END $$
DELIMITER ;