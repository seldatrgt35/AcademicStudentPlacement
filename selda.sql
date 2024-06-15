
CREATE TABLE University (
    university_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    e_mail VARCHAR(100),
    city VARCHAR(100),
    type VARCHAR(50),
    f_year INT
);


CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    e_mail VARCHAR(100),
    university_id INT,
    FOREIGN KEY (university_id) REFERENCES University(university_id)
);


CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    e_mail VARCHAR(100),
    lang VARCHAR(50),
    ed_type VARCHAR(50),
    quota INT,
    top_quota INT,
    period INT,
    min_score_24 INT,
    min_order_24 INT,
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);


CREATE TABLE Student (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    score INT,
    rank INT,
    top VARCHAR(3),
    pref1 INT,
    pref2 INT,
    pref3 INT,
    FOREIGN KEY (pref1) REFERENCES Department(department_id),
    FOREIGN KEY (pref2) REFERENCES Department(department_id),
    FOREIGN KEY (pref3) REFERENCES Department(department_id)
);

INSERT INTO University (university_id, name, address, e_mail, city, type, f_year) VALUES
(1, 'Ankara University', 'Ulus', 'info@au.edu', 'Ankara', 'state', 1988),
(2, 'Bilkent University', 'Keçiören', 'info@bilkent.edu', 'Ankara', 'private', 2010),
(3, 'Dokuz Eylul University', 'Buca', 'info@deu.edu', 'İzmir', 'state', 1990),
(4, 'Izmir Technical University', 'Karaburun', 'info@itu.edu', 'İzmir', 'state', 2020),
(5, 'Izmir University', 'Balçova', 'info@iu.edu', 'İzmir', 'private', 2015);


INSERT INTO Faculty (faculty_id, name, e_mail, university_id) VALUES
(9, 'Law', 'info@mus.uni.edu', 3),
(8, 'Engineering', 'info@mus.uni.edu', 3),
(7, 'Engineering', 'info@mus.uni.edu', 5),
(1, 'Engineering', 'info@eng.uni.edu', 1),
(2, 'Medicine', 'info@med.uni.edu', 2),
(3, 'Management', 'info@man.uni.edu', 3),
(4, 'Architecture', 'info@arc.uni.edu', 4),
(5, 'Pharmacy', 'info@pha.uni.edu', 5),
(6, 'Music', 'info@mus.uni.edu', 5);


INSERT INTO Department (department_id, name, e_mail, lang, ed_type, quota, top_quota, period, min_score_24, min_order_24, faculty_id) VALUES
(7, 'Law', 'info@law.edu', 'Turkish', 'fe', 500, 50, 5, 50000, 4000, 9),
(1, 'Computer Engineering', 'info@ce.uni.edu', 'English', 'ee', 100, 5, 4, 100000, 1120, 1),
(2, 'Neurology', 'info@neu.uni.edu', 'Turkish', 'fe', 20, 2, 6, 120000, 1010, 2),
(3, 'Space Engineering', 'info@spc.uni.edu', 'English', 'ee', 120, 10, 4, 95000, 1250, 1),
(4, 'International Relations', 'info@ir.uni.edu', 'English', 'fe', 200, 20, 5, 75000, 2000, 3),
(5, 'Voice', 'info@vc.uni.edu', 'Turkish', 'fe', 150, 10, 4, 60000, 3000, 6),
(6, 'Law', 'info@law.edu', 'Turkish', 'fe', 500, 50, 5, 50000, 4000, 5);

INSERT INTO Student (id, name, surname, score, rank, top, pref1, pref2, pref3) VALUES
(1, 'Ayşe', 'Gaye', 150000, 1000, 'yes', 2, 1, 3),
(2, 'Ali', 'Veli', 90000, 1200, 'no', 1, 3, 6),
(3, 'Fatma', 'Ayşe', 100000, 1100, 'yes', 2, 1, 3),
(4, 'Veli', 'Ali', 80000, 1500, 'no', 4, 5, 6),
(5, 'Aylin', 'Ceylin', 120000, 1050, 'yes', 2, 1, 3),
(6, 'Ahmet', 'Mehmet', 84000, 1400, 'no', 2, 4, 5);

SELECT name
FROM University
WHERE city LIKE 'A%' AND f_year > 1990;

SELECT u.name
FROM University u
JOIN Faculty f ON u.university_id = f.university_id
WHERE f.name IN ('Engineering','Medicine');


SELECT u.type, COUNT(f.faculty_id) AS faculty_count
FROM University u
JOIN Faculty f ON u.university_id = f.university_id
GROUP BY u.type;

SELECT name
FROM Department
WHERE name ILIKE '%engineering%' AND ed_type = 'ee';

SELECT name
FROM Department
ORDER BY period DESC, min_score_24 DESC
LIMIT 5;

SELECT d.name, COUNT(*) AS preference_count
FROM Student s
JOIN Department d ON (s.pref1 = d.department_id OR s.pref2 = d.department_id OR s.pref3 = d.department_id)
WHERE d.period = 4
GROUP BY d.name
ORDER BY preference_count DESC;

SELECT s.id, s.name, s.surname, s.score
FROM Student s
JOIN Department d ON s.pref1 = d.department_id
WHERE d.name = 'Computer Engineering'
ORDER BY s.score DESC;

UPDATE Faculty
SET university_id = (SELECT university_id FROM University WHERE name = 'Izmir Technical University')
WHERE name = 'Engineering' AND university_id = (SELECT university_id FROM University WHERE name = 'Dokuz Eylul University');

UPDATE Department
SET period = period + 1
WHERE faculty_id = (SELECT faculty_id FROM Faculty WHERE name = 'Law');


UPDATE student
SET pref1 = NULL
WHERE pref1 IN (SELECT faculty_id FROM Faculty WHERE university_id = (SELECT university_id FROM University WHERE name = 'Izmir University'));

UPDATE student
SET pref2 = NULL
WHERE pref2 IN (SELECT faculty_id FROM Faculty WHERE university_id = (SELECT university_id FROM University WHERE name = 'Izmir University'));


UPDATE student
SET pref3 = NULL
WHERE pref3 IN (SELECT faculty_id FROM Faculty WHERE university_id = (SELECT university_id FROM University WHERE name = 'Izmir University'));

DELETE FROM Department
WHERE faculty_id IN (SELECT faculty_id FROM Faculty WHERE university_id = (SELECT university_id FROM University WHERE name = 'Izmir University'));

DELETE FROM Faculty
WHERE university_id = (SELECT university_id FROM University WHERE name = 'Izmir University');
																		   