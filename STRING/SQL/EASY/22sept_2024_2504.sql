-- 2504. Concatenate the Name and the Profession
-- Description
-- Table: Person
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | person_id   | int     |
-- | name        | varchar |
-- | profession  | ENUM    |
-- +-------------+---------+
-- person_id is the primary key for this table.
-- Each row in this table contains a person's ID, name, and profession.
-- The profession column is an enum of the type ('Doctor', 'Singer', 'Actor', 'Player', 'Engineer', or 'Lawyer').
-- Write an SQL query to report each person's name followed by the first letter of their profession
-- enclosed in parentheses.
-- Return the result table ordered by person_id in descending order.
-- Person table:
-- +-----------+-------+------------+
-- | person_id | name  | profession |
-- +-----------+-------+------------+
-- | 1         | Alex  | Singer     |
-- | 3         | Alice | Actor      |
-- | 2         | Bob   | Player     |
-- | 4         | Messi | Doctor     |
-- | 6         | Tyson | Engineer   |
-- | 5         | Meir  | Lawyer     |
-- +-----------+-------+------------+
-- Output:
-- +-----------+----------+
-- | person_id | name     |
-- +-----------+----------+
-- | 6         | Tyson(E) |
-- | 5         | Meir(L)  |
-- | 4         | Messi(D) |
-- | 3         | Alice(A) |
-- | 2         | Bob(P)   |
-- | 1         | Alex(S)  |
-- +-----------+----------+

Create table If Not Exists Person (person_id int, name varchar(30), profession ENUM('Doctor','Singer','Actor','Player','Engineer','Lawyer'));
Truncate table Person;
insert into Person (person_id, name, profession) values ('1', 'Alex', 'Singer');
insert into Person (person_id, name, profession) values ('3', 'Alice', 'Actor');
insert into Person (person_id, name, profession) values ('2', 'Bob', 'Player');
insert into Person (person_id, name, profession) values ('4', 'Messi', 'Doctor');
insert into Person (person_id, name, profession) values ('6', 'Tyson', 'Engineer');
insert into Person (person_id, name, profession) values ('5', 'Meir', 'Lawyer');

SELECT person_id, CONCAT(name, '(', LEFT(profession, 1), ')') AS name
FROM Person
ORDER BY 1 DESC;
