-- university_grades database (tables, views, stored procedures & triggers)
-- AUTHOR: Przemyslaw Zgudka

DROP DATABASE IF EXISTS university_grades;
CREATE DATABASE university_grades; 
USE university_grades;

SET NAMES UTF8MB4;
SET character_set_client = utf8mb4 ;

-- ----------------------------------------------------------------------------------------------------
-- course_types table [contains data on university course types assigned to each course in course table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE course_types (
  course_type_id tinyint NOT NULL,
  course_type varchar(30) NOT NULL,
  PRIMARY KEY (course_type_id),
  UNIQUE KEY type_id_UNIQUE (course_type_id)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- degrees table [contains data on university degrees assigned to each studies in studies table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE degrees (
  degree_id tinyint NOT NULL,
  degree varchar(30) DEFAULT NULL,
  PRIMARY KEY (degree_id),
  UNIQUE KEY degree_id_UNIQUE (degree_id)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- faculties table [contains data on faculties assigned to each studies in studies table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE faculties (
  faculty_id tinyint NOT NULL,
  faculty varchar(100) NOT NULL,
  PRIMARY KEY (faculty_id),
  UNIQUE KEY faculty_id_UNIQUE (faculty_id)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- majors table [contains data on majors assigned to each studies in studies table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE majors (
  major_id tinyint NOT NULL,
  major varchar(75) NOT NULL,
  PRIMARY KEY (major_id),
  UNIQUE KEY major_id_UNIQUE (major_id)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- modes table [contains data on modes assigned to each studies in studies table]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE modes (
  mode_id tinyint NOT NULL,
  mode varchar(30) NOT NULL,
  PRIMARY KEY (mode_id),
  UNIQUE KEY mode_id_UNIQUE (mode_id)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- studies table [contains data on studies]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE studies (
  studies_id tinyint NOT NULL,
  major_id tinyint NOT NULL,
  mode_id tinyint NOT NULL,
  degree_id tinyint NOT NULL,
  faculty_id tinyint NOT NULL,
  PRIMARY KEY (studies_id),
  UNIQUE KEY studies_id_UNIQUE (studies_id),
  KEY fk_studies_major_id (major_id),
  KEY fk_majors_faculty_id_idx (faculty_id),
  KEY fk_majors_degrees_id_idx (degree_id),
  KEY fk_studies_mode_id_idx (mode_id),
  KEY idx_studies_major_degree_mode_faculty_id (studies_id,major_id,degree_id,mode_id,faculty_id),
  CONSTRAINT fk_studies_degrees_id FOREIGN KEY (degree_id) REFERENCES degrees (degree_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_studies_faculty_id FOREIGN KEY (faculty_id) REFERENCES faculties (faculty_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_studies_major_id FOREIGN KEY (major_id) REFERENCES majors (major_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_studies_mode_id FOREIGN KEY (mode_id) REFERENCES modes (mode_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- indxs table [contains data on indexes with details regarding students]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE indxs (
  index_id mediumint NOT NULL,
  first_name varchar(50) DEFAULT NULL,
  last_name varchar(50) DEFAULT NULL,
  index_no int NOT NULL,
  studies_id tinyint NOT NULL,
  academic_year smallint NOT NULL,
  PRIMARY KEY (index_id),
  UNIQUE KEY index_no_UNIQUE (index_no),
  UNIQUE KEY index_id_UNIQUE (index_id),
  KEY fk_indexes_studies_id_idx (studies_id),
  KEY idx_index_no_last_name_studies_id_academic_year (index_no,last_name,studies_id,academic_year),
  CONSTRAINT fk_indexes_studies_id FOREIGN KEY (studies_id) REFERENCES studies (studies_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- courses table [contains data on courses with details regarding courses affiliation to exact studies and course types]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE courses (
  course_id smallint NOT NULL,
  course varchar(100) NOT NULL,
  course_year tinyint NOT NULL DEFAULT '1',
  course_type_id tinyint DEFAULT NULL,
  studies_id tinyint NOT NULL,
  PRIMARY KEY (course_id),
  UNIQUE KEY course_id_UNIQUE (course_id),
  KEY fk_courses_studies_id_idx (studies_id),
  KEY idx_course_id_course_studies_id_course_year_course_type_id (course_id,course,studies_id,course_year,course_type_id),
  CONSTRAINT fk_courses_studies_id FOREIGN KEY (studies_id) REFERENCES studies (studies_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_courses_course_type_id FOREIGN KEY (course_type_id) REFERENCES course_types (course_type_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- evaluation_cards table [contains data on grades assigned to each student attending particular courses]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE evaluation_cards (
  index_id mediumint NOT NULL,
  course_id smallint NOT NULL,
  grade tinyint DEFAULT NULL,
  PRIMARY KEY (index_id,course_id),
  KEY fk_evaluation_cards_indexes1_idx (index_id),
  KEY fk_evaluation_cards_course_id_idx (course_id),
  KEY idx_index_id_course_id_grade (index_id,course_id,grade),
  CONSTRAINT fk_evaluation_cards_index_id FOREIGN KEY (index_id) REFERENCES indxs (index_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_evaluation_cards_course_id FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- CREATE TRIGGER ON evaluation_cards [contains 2 triggers which prevent from inserting/updating grade column with invalid grades]

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

CREATE TABLE lecturers (
  lecturer_id smallint NOT NULL,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL,
  faculty_id tinyint NOT NULL,
  PRIMARY KEY (lecturer_id),
  UNIQUE KEY lecturer_id_UNIQUE (lecturer_id),
  KEY fk_lecturers_faculty_id_idx (faculty_id),
  KEY idx_last_name_faculty_id (last_name,faculty_id),
CONSTRAINT fk_lecturers_faculty_id FOREIGN KEY (faculty_id) REFERENCES faculties(faculty_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- grps table [contains data on groups assigned to courses & lecturers]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE grps (
  group_id smallint NOT NULL,
  lecturer_id smallint DEFAULT NULL,
  course_id smallint NOT NULL,
  group_no tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (group_id),
  UNIQUE KEY group_id_UNIQUE (group_id),
  KEY fk_grps_lecturer_id_idx (lecturer_id),
  KEY fk_grps_course_id_idx (course_id),
  CONSTRAINT fk_grps_course_id FOREIGN KEY (course_id) REFERENCES courses (course_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_grps_lecturer_id FOREIGN KEY (lecturer_id) REFERENCES lecturers (lecturer_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- grps_participants table [contains data on students assigned to groups which they are attending]
-- ----------------------------------------------------------------------------------------------------

CREATE TABLE grps_participants (
  index_id mediumint NOT NULL,
  group_id smallint NOT NULL,
  PRIMARY KEY (index_id,group_id),
  KEY fk_grps_has_indexes_indexes1_idx (index_id),
  KEY fk_groupds_participants_group_id_idx (group_id),
  CONSTRAINT fk_grps_participants_index_id FOREIGN KEY (index_id) REFERENCES indxs (index_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_grps_participants_group_id FOREIGN KEY (group_id) REFERENCES grps(group_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------------------------------
-- university_grades views [contains 2 exemplary views which display students assigned to a particular lecturer. Each view is assigned to the particular lecturer]
-- ----------------------------------------------------------------------------------------------------

CREATE VIEW view_students_of_lecturer_1 AS
SELECT i.index_id, CONCAT_WS (' ', last_name, first_name) AS student, CONCAT_WS(', ', course, course_type) AS course, course_id, g.group_id, 
CONCAT(major, ', ', degree, ', ', mode, ', ' 'year ', academic_year) AS studies, grade FROM evaluation_cards
JOIN indxs i USING (index_id)
JOIN courses c USING (course_id)
JOIN course_types ct USING (course_type_id)
JOIN grps g USING (course_id)
JOIN studies s ON c.studies_id = s.studies_id
JOIN majors m USING (major_id)
JOIN degrees USING (degree_id)
JOIN modes USING (mode_id)
WHERE lecturer_id = 1;

CREATE VIEW view_students_of_lecturer_69 AS
SELECT i.index_id, CONCAT_WS (' ', last_name, first_name) AS student, CONCAT_WS(', ', course, course_type) AS course, course_id, g.group_id, 
CONCAT(major, ', ', degree, ', ', mode, ', ' 'year ', academic_year) AS studies, grade FROM evaluation_cards
JOIN indxs i USING (index_id)
JOIN courses c USING (course_id)
JOIN course_types ct USING (course_type_id)
JOIN grps g USING (course_id)
JOIN studies s ON c.studies_id = s.studies_id
JOIN majors m USING (major_id)
JOIN degrees USING (degree_id)
JOIN modes USING (mode_id)
WHERE lecturer_id = 69;

-- ----------------------------------------------------------------------------------------------------
-- university_grades procedures
-- ----------------------------------------------------------------------------------------------------

-- CREATE PROCEDURE get_failed_courses [returns list containing students which received 2 grade on one or more courses, including data on courses and details regarding courses affiliation to exact studies; parameters: studies_id, academic_year]

DELIMITER $$
CREATE PROCEDURE get_failed_courses(PARstudies tinyint, PARyear tinyint)
BEGIN
SELECT 	index_id, 
		CONCAT_WS(" ", last_name, first_name) AS student, 
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
CREATE PROCEDURE get_group_participants(PARgroup smallint)
BEGIN
SELECT 	group_id, index_id, 
        CONCAT_WS(" ", i.last_name, i.first_name) AS name, 
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
CREATE PROCEDURE get_scholarship_candidates(PARstudies_id TINYINT, PARacademic_year TINYINT)
BEGIN
SELECT index_id, CONCAT_WS(" ", i.last_name, i.first_name) AS name, AVG(grade) AS average_grade, CONCAT_WS(", ", major, degree, mode) AS studies, academic_year FROM evaluation_cards
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