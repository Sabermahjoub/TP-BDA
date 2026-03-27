
-- 1. Département avec le plus grand budget

SELECT dept_name
FROM department
WHERE budget = (SELECT MAX(budget) FROM department);

-- 2. Enseignants avec salaire > moyenne

SELECT name, salary
FROM teacher
WHERE salary > (SELECT AVG(salary) FROM teacher);

-- 3. Étudiants ayant suivi ≥ 2 cours avec un enseignant (HAVING)

SELECT teacher.name, student.name, COUNT(*)
FROM teacher, student, takes, teaches
WHERE teacher.id = teaches.id
AND student.id = takes.id
AND (takes.course_id, takes.sec_id, takes.semester, takes.year) =
    (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
GROUP BY teacher.name, student.name
HAVING COUNT(*) >= 2;


-- 4. Même question sans HAVING

SELECT *
FROM (
    SELECT teacher.name AS teachername,
           student.name AS studentname,
           COUNT(*) AS totalcount
    FROM teacher, student, takes, teaches
    WHERE teacher.id = teaches.id
    AND student.id = takes.id
    AND (takes.course_id, takes.sec_id, takes.semester, takes.year) =
        (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
    GROUP BY teacher.name, student.name
) T
WHERE totalcount >= 2;




-- 5. Étudiants n’ayant pas suivi de cours avant 2010

SELECT id, name FROM student
EXCEPT
SELECT student.id, student.name
FROM student, takes
WHERE student.id = takes.id
AND takes.year < 2010;

-- 6. Enseignants dont le nom commence par E

SELECT *
FROM teacher
WHERE name LIKE 'E%';

-- 7. 4ème salaire le plus élevé

SELECT name
FROM teacher T1
WHERE 3 = (
    SELECT COUNT(DISTINCT T2.salary)
    FROM teacher T2
    WHERE T2.salary > T1.salary
);


-- 8. 3 plus petits salaires

SELECT name, salary
FROM teacher T1
WHERE 2 >= (
    SELECT COUNT(DISTINCT T2.salary)
    FROM teacher T2
    WHERE T2.salary < T1.salary
)
ORDER BY salary ASC;




-- 9. Étudiants ayant suivi un cours en Fall 2009 (IN)

SELECT name
FROM student S
WHERE ('Fall', 2009) IN (
    SELECT semester, year
    FROM takes
    WHERE takes.id = S.id
);


-- Avec SOME

SELECT name
FROM student S
WHERE ('Fall', 2009) = SOME (
    SELECT semester, year
    FROM takes
    WHERE takes.id = S.id
);



-- 11. Avec NATURAL JOIN

SELECT DISTINCT name
FROM student NATURAL JOIN takes
WHERE semester = 'Fall' AND year = 2009;


-- 12. Avec EXISTS

SELECT name
FROM student
WHERE EXISTS (
    SELECT *
    FROM takes
    WHERE takes.id = student.id
    AND semester = 'Fall'
    AND year = 2009
);


-- 13. Paires d’étudiants ayant suivi un cours ensemble

SELECT A.name, B.name
FROM (
    SELECT *
    FROM student NATURAL JOIN takes
) A,
(
    SELECT *
    FROM student NATURAL JOIN takes
) B
WHERE A.course_id = B.course_id
AND A.sec_id = B.sec_id
AND A.semester = B.semester
AND A.year = B.year
AND A.id < B.id;


-- 14. Nombre d’étudiants par enseignant (ayant enseigné)

SELECT teacher.name, COUNT(*)
FROM takes
JOIN teaches USING (course_id, sec_id, semester, year)
JOIN teacher ON teaches.id = teacher.id
GROUP BY teacher.name
ORDER BY COUNT(*) DESC;


-- 15. Même chose avec enseignants sans cours

SELECT teacher.name, COUNT(course_id)
FROM teacher
LEFT JOIN teaches ON teacher.id = teaches.id
LEFT JOIN takes USING (course_id, sec_id, semester, year)
GROUP BY teacher.name
ORDER BY COUNT(course_id) DESC;


-- 16. Nombre de notes A par enseignant

WITH mytakes AS (
    SELECT *
    FROM takes
    WHERE grade = 'A'
)
SELECT teacher.name, COUNT(course_id)
FROM mytakes
JOIN teaches USING (course_id, sec_id, semester, year)
RIGHT JOIN teacher ON teaches.id = teacher.id
GROUP BY teacher.name
ORDER BY COUNT(course_id) DESC;


-- 17. Paires enseignant–étudiant + nombre de cours


SELECT teacher.name, student.name, COUNT(*)
FROM (teacher NATURAL JOIN teaches)
JOIN (takes NATURAL JOIN student)
USING (course_id, sec_id, semester, year)
GROUP BY teacher.name, student.name;


-- 18. Paires avec au moins 2 cours

SELECT *
FROM (
    SELECT teacher.name AS tn,
           student.name AS sn,
           COUNT(*) AS tc
    FROM (teacher NATURAL JOIN teaches)
    JOIN (takes NATURAL JOIN student)
    USING (course_id, sec_id, semester, year)
    GROUP BY teacher.name, student.name
) T
WHERE tc >= 2;





