-- 1623. All Valid Triplets That Can Represent a Country
-- SQL Schema 
-- Table: SchoolA
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | student_id    | int     |
-- | student_name  | varchar |
-- +---------------+---------+
-- student_id is the primary key for this table.
-- Each row of this table contains the name and the id of a student in school A.
-- All student_name are distinct.

-- Table: SchoolB

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | student_id    | int     |
-- | student_name  | varchar |
-- +---------------+---------+
-- student_id is the primary key for this table.
-- Each row of this table contains the name and the id of a student in school B.
-- All student_name are distinct.

-- Table: SchoolC

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | student_id    | int     |
-- | student_name  | varchar |
-- +---------------+---------+
-- student_id is the primary key for this table.
-- Each row of this table contains the name and the id of a student in school C.
-- All student_name are distinct.

-- There is a country with three schools, where each student is enrolled in 
-- exactly one school. The country is joining a competition and wants to 
-- select one student from each school to represent the country such that:

-- member_A is selected from SchoolA,
-- member_B is selected from SchoolB,
-- member_C is selected from SchoolC, and
-- The selected students' names and IDs are pairwise distinct (i.e. no 
-- two students share the same name, and no two students share the same ID).

-- Write an  SQL query to find all the possible triplets representing the 
-- country under the given constraints.


-- SchoolA table:
-- +------------+--------------+
-- | student_id | student_name |
-- +------------+--------------+
-- | 1          | Alice        |
-- | 2          | Bob          |
-- +------------+--------------+

-- SchoolB table:
-- +------------+--------------+
-- | student_id | student_name |
-- +------------+--------------+
-- | 3          | Tom          |
-- +------------+--------------+

-- SchoolC table:
-- +------------+--------------+
-- | student_id | student_name |
-- +------------+--------------+
-- | 3          | Tom          |
-- | 2          | Jerry        |
-- | 10         | Alice        |
-- +------------+--------------+

-- Result table:
-- +----------+----------+----------+
-- | member_A | member_B | member_C |
-- +----------+----------+----------+
-- | Alice    | Tom      | Jerry    |
-- | Bob      | Tom      | Alice    |
-- +----------+----------+----------+
-- Let us see all the possible triplets.
-- - (Alice, Tom, Tom) --> Rejected because member_B and member_C have the same 
-- name and the same ID.
-- - (Alice, Tom, Jerry) --> Valid triplet.
-- - (Alice, Tom, Alice) --> Rejected because member_A and member_C have the same name.
-- - (Bob, Tom, Tom) --> Rejected because member_B and member_C have the same name 
-- and the same ID.
-- - (Bob, Tom, Jerry) --> Rejected because member_A and member_C have the same ID.
-- - (Bob, Tom, Alice) --> Valid triplet.

Create table If Not Exists SchoolA (student_id int, student_name varchar(20));
Create table If Not Exists SchoolB (student_id int, student_name varchar(20));
Create table If Not Exists SchoolC (student_id int, student_name varchar(20));
Truncate table SchoolA;
insert into SchoolA (student_id, student_name) values ('1', 'Alice'), ('2', 'Bob');
Truncate table SchoolB;
insert into SchoolB (student_id, student_name) values ('3', 'Tom');
Truncate table SchoolC;
insert into SchoolC (student_id, student_name) values ('3', 'Tom'), ('2', 'Jerry'), ('10', 'Alice');

-- m1
SELECT 
    sa.student_name AS member_A,
    sb.student_name AS member_B,
    sc.student_name AS member_C
FROM SchoolA sa
CROSS JOIN SchoolB sb
CROSS JOIN SchoolC sc 
WHERE (sa.student_id <> sb.student_id and sa.student_name <> sb.student_name)
AND (sc.student_id <> sb.student_id and sc.student_name <> sb.student_name)
AND (sa.student_id <> sc.student_id and sa.student_name <> sc.student_name);

---------------------------------------------------------------------------------------
-- m2 JOIN condition = inequality condition
-- This is conceptually wrong.
SELECT 
    s1.student_name AS member_A,
    s2.student_name AS member_B,
    s3.student_name AS member_C
FROM SchoolA AS s1
INNER JOIN SchoolB AS s2
    ON s1.student_id <> s2.student_id
    AND s1.student_name <> s2.student_name
INNER JOIN SchoolC AS s3
    ON s2.student_id <> s3.student_id
    AND s2.student_name <> s3.student_name
    AND s1.student_id <> s3.student_id
    AND s1.student_name <> s3.student_name;