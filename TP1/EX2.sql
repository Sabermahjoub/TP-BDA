-- ============================================================
-- EXERCICE 2 
-- ============================================================

DESC section;

SELECT * FROM section;

SELECT * FROM course;

SELECT title, dept_name
FROM course;

SELECT dept_name, budget
FROM department;

SELECT name, dept_name
FROM teacher;

SELECT name
FROM teacher
WHERE salary > 65000;

SELECT name
FROM teacher
WHERE salary BETWEEN 55000 AND 85000;

SELECT DISTINCT dept_name
FROM teacher;

-- Fixed: typo dep_name -> dept_name, added quotes around string literal
SELECT name
FROM teacher
WHERE salary > 65000
  AND dept_name = 'Comp. Sci.';

SELECT *
FROM section
WHERE semester = 'Spring';

-- Fixed: credit -> credits, added quotes around string literal
SELECT title
FROM course
WHERE dept_name = 'Comp. Sci.'
  AND credits > 3;

SELECT teacher.name, teacher.dept_name, department.building
FROM teacher, department
WHERE teacher.dept_name = department.dept_name;

-- Fixed: added quotes around 'Comp. Sci.'
SELECT DISTINCT student.name
FROM student, takes, course
WHERE student.id = takes.id
  AND takes.course_id = course.course_id
  AND course.dept_name = 'Comp. Sci.';

-- Fixed: added quotes around 'Einstein'
SELECT DISTINCT student.name
FROM student, teacher, takes, teaches
WHERE student.id = takes.id
  AND takes.course_id = teaches.course_id
  AND takes.sec_id = teaches.sec_id
  AND takes.semester = teaches.semester
  AND takes.year = teaches.year
  AND teaches.id = teacher.id
  AND teacher.name = 'Einstein';

SELECT name, course_id
FROM teacher, teaches
WHERE teacher.id = teaches.id;

-- Fixed: added quotes around 'Spring'
SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, COUNT(*)
FROM takes
WHERE takes.semester = 'Spring'
  AND takes.year = 2010
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;

SELECT dept_name, MAX(salary)
FROM teacher
GROUP BY dept_name;

SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, COUNT(*)
FROM takes
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;

-- Fixed: added quotes around 'Fall' and 'Spring'
SELECT building, COUNT(*)
FROM section
WHERE (semester = 'Fall' AND year = 2009)
   OR (semester = 'Spring' AND year = 2010)
GROUP BY building;

SELECT department.dept_name, COUNT(*)
FROM section, department, teacher, teaches
WHERE (section.course_id, section.sec_id, section.semester, section.year)
    = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
  AND teaches.id = teacher.id
  AND teacher.dept_name = department.dept_name
  AND department.building = section.building
GROUP BY department.dept_name;

SELECT course.title, teacher.name
FROM section, teacher, teaches, course
WHERE (section.course_id, section.sec_id, section.semester, section.year)
    = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
  AND teaches.id = teacher.id
  AND section.course_id = course.course_id
ORDER BY course.title;

SELECT section.semester, COUNT(*)
FROM section
GROUP BY section.semester;

SELECT student.name, SUM(course.credits)
FROM student, course, takes
WHERE student.id = takes.id
  AND takes.course_id = course.course_id
  AND student.dept_name != course.dept_name
GROUP BY student.name;

SELECT section.building, SUM(course.credits)
FROM section, course
WHERE section.course_id = course.course_id
GROUP BY section.building;