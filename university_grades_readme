# UNIVERSITY GRADES
## OVERVIEW
university_grades is a relational database created using SQL.  It stores data constituting fictional university which was created using entities. 
The main entities which constitute the relational database are: 
* Faculty – with assigned studies and lecturers.
* Studies – defined by: major, mode, degree; assigned to a particular faculty.
* Course – defined by: course name, academic year, course type; assigned to particular studies.
* Course group – assigned to particular course; incorporates 1 lecturer and >1 participants.
* Lecturer – teaches a course group.
* Index – basic data carrier of course participant within the database.
* Evaluation card – stores the data regarding grades received by the student from particular courses.

The database have two categories of users:
* **Administrators** – they manage and maintain the database. They are divided into 2 types:
 1. admin – they have all the privileges for managing the database (privileges: **ALL**),
 2. junior admin – they can manage all the tables’ data but cannot interfere into database’s structure (privileges: **SELECT**, **INSERT**, **UPDATE**, **DELETE**, **EXECUTE**).
  
* **Lecturers** – users without administrative privileges. They can browse the database’s contents only using views. Each lecturer has one view assigned (more info in [VIEWS](#VIEWS) subsection).

By using this database lecturers can quickly give grades to students they are teaching or change them in case of retakes. Administrators can update the data according to changes within the university (i.e. adding new studies, deleting students who graduated or resigned, adding new lecturers etc.).

To make the handling of the database simpler, triggers and stored procedures were implemented.

## PROGRAMS USED
* **MySQL Workbench** – designing the database,
* **Microsoft Excel** – creating and managing the data inserted into the database,
* **Microsoft Visio** – planning the database’s structure and relationships.

## HOW TO RUN
Execute the script in RDBMS which supports SQL (tested on: MySQL, HeidiSQL, Dbeaver) after establishing a connection with the server.

You can create this database by:
* executing *university_grades_tables.sql* and *university_grades_data.sql* consecutively or
* executing *university_grades.sql*.

To test users’ privileges:
1. after creating the database, execute *university_grades_users.sql*,
2. create new connection(s) using username(s) listed in the script (*admin*, *junior_admin*, *lecturer_1*, *lecturer_69*),
3. log in via credentials given in the *university_grades_users.sql*.

## TABLES
### MAIN TABLES

**courses** – contains a collection of course IDs (*course_id*) with assigned data:
* name of the course (*course_name*),
* studies’ academic year (*course_year*),
* course’s type ID (*course_type_id*),
* studies’ ID (*studies_id*).

**evaluation_cards** – contains a collection of index IDs (*index_id*) with assigned data:  
* course ID (*course_id*) – for the course which is attended by the index’s holder. For one index ID there may be many courses’ IDs,
* grades received by index’s holder (*grade*) – each grade is assigned to a particular course. The university uses a rating scale from 2 (lowest grade) to 5 (highest grade).

**grps** – contains  a collection of group IDs (*group_id*) with assigned data: 
* ID of the group’s lecturer (*lecturer_id*),
* ID of the course to which the group is assigned (*course_id*),
* number of the particular course’s group – 1 or 2 (*group_no*). 

**grps_participants** – contains a collection of index IDs (*index_id*) which are assigned to particular group IDs (*group_id*) with following relationship types: 
* one group ID may have few index IDs attributed,  
* one index ID may be assigned to few group IDs.

**indxs** – contains a collection of index IDs (*index_id*) with assigned data: 
* index's holder first name (*first_name*),
* index's holder last name (*last_name*),
* unique 6-digit index number (*index_no*), 
* ID of studies which are attended by index's holder (*studies_id*), 
* studies’ academic year (*academic_year*).

**lecturers** – contains a collection of lecturer IDs (*lecturer_id*) with assigned data:
* lecturer’s first name (*first_name*),
* lecturer’s last name (*last_name*),
* ID of faculty to which the lecturer is assigned (*faculty_id*).

**studies** – contains a collection of studies IDs (*studies_id*) with assigned data: 
* studies major’s ID (*major_id*),
* studies mode’s ID (*mode_id*), 
* studies degree’s ID (*degree_id*), 
* faculty’s ID (*faculty_id*). 

### SUPPLEMENTARY TABLES
**course_types** – contains a list of course types with assigned IDs,

**degrees** – contains a list of studies’ degrees with assigned IDs,

**faculties** – contains a list of faculties with assigned IDs, 

**majors** – contains a list of studies’ majors with assigned IDs,

**modes** – contains a list of studies’ modes with assigned IDs.

## VIEWS, STORED PROCEDURES & TRIGGERS
### VIEWS
**view_students_of_lecturer_[lecturer ID]** – views are intended for the users without administrative privileges. The particular view contains data regarding students who are participants of the groups taught by the lecturer with ID assigned to this view. The information include:
* index IDs of group’s participant (index_id),
* last name and first name of group’s participant (student),
* name of the course to which the group is assigned (course),
* ID of the course to which the group is assigned (course_id),
* group ID (group_id),
* studies’ major, degree and mode (studies),
* grade received by the student from the course he attends as a participant of the particular group (grade).

Main purposes of the views are:
* giving the lecturer access to data regarding students who are participants of his groups,
* managing grades (**INSERT**, **UPDATE**) given to students who are participants of lecturer’s groups.

Access to contents which are outside of the assigned view is prohibited. Manipulating the data other than grade column within the view is also prohibited.

For demonstrational purposes two views (assigned to lecturer’s ID 1 and 69) were created.

### STORED PROCEDURES
**get_failed_courses** (parameters: studies ID, academic year) – returns a list of students who received one or more 2 grades, attributed to selected studies and academic year with information regarding: index’s ID; last name and first name of index’s holder (**CONCAT_WS**); course name and course type (**CONCAT_WS**); studies’ major, degree and mode (**CONCAT_WS**).

**get_group_participants** (parameters: group ID) – returns a list of students who are participants of a chosen group with information regarding: index’s ID; last name and first name and of index’s holder (**CONCAT_WS**); course name and course type (**CONCAT_WS**); group number; studies’ major, degree and mode (**CONCAT_WS**); academic year to which the group is assigned.

**get_scholarship_candidates** (parameters: studies ID, academic year) – returns a list of 3 indexes whose holders received highest GPA's within selected academic year of chosen studies with information regarding: last name and first name and of index’s holder (**CONCAT_WS**); studies’ major, degree and mode (**CONCAT_WS**).

### TRIGGERS
The database contains following triggers:

**invalid_grade_insert**  – prevents from inserting grade with the <2 or >5 value into *evaluation_cards* table  – the **INSERT** query is aborted and message regarding inserting invalid grade is displayed in the output window.

**invalid_grade_update** – prevents from updating grade with the <2 or >5 value in *evaluation_cards* table  – the **UPDATE** query is aborted and message regarding inserting invalid grade is displayed in the output window.

## CHANGELOG

**v1.0** – the database university_grades was created.

**v2.0** – removed *get_average_grades_by_studies_year* procedure (procedure redundant); updated views; created users with appropriate privileges (stored in *university_grades_users.sql*); added missing constraints; minor cosmetic changes to the code.

## SCHEMA
![university_grades_schema](https://github.com/PyramidHeadPL/sql-showreel/blob/master/university_grades_schema.jpg)
