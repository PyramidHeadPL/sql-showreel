-- university_grades database (Users)

-- ----------------------------------------------------------------------------------------------------
-- administrators
-- ----------------------------------------------------------------------------------------------------

CREATE USER admin IDENTIFIED BY 'haslo';
GRANT ALL
ON university_grades.*
TO admin;

CREATE USER junior_admin IDENTIFIED BY 'haslo';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE
ON university_grades.*
TO junior_admin

-- ----------------------------------------------------------------------------------------------------
-- lecturers
-- ----------------------------------------------------------------------------------------------------

CREATE USER lecturer_1 IDENTIFIED BY 'haslo';
GRANT SELECT, INSERT (grade), UPDATE (grade) 
ON university_grades.view_students_of_lecturer_1
TO lecturer_1;

CREATE USER lecturer_69 IDENTIFIED BY 'haslo';
GRANT SELECT, INSERT (grade), UPDATE (grade) 
ON university_grades.view_students_of_lecturer_69
TO lecturer_69;