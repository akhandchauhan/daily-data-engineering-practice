-- 2308. Arrange Table by Gender
-- Description
-- Table: Genders
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | gender      | varchar |
-- +-------------+---------+
-- user_id is the primary key for this table.
-- gender is ENUM of type 'female', 'male', or 'other'.
-- Each row in this table contains the ID of a user and their gender.
-- The table has an equal number of 'female', 'male', and 'other'.
-- Write an  SQL query to rearrange the Genders table such that the rows alternate between '
-- female', 'other', and 'male' in order. The table should be rearranged such that the IDs
-- of each gender are sorted in ascending order.
-- Return the result table in the mentioned order.
-- The query result format is shown in the following example.
-- Example 1:
-- Input: 
-- Genders table:
-- +---------+--------+
-- | user_id | gender |
-- +---------+--------+
-- | 4       | male   |
-- | 7       | female |
-- | 2       | other  |
-- | 5       | male   |
-- | 3       | female |
-- | 8       | male   |
-- | 6       | other  |
-- | 1       | other  |
-- | 9       | female |
-- +---------+--------+
-- Output: 
-- +---------+--------+
-- | user_id | gender |
-- +---------+--------+
-- | 3       | female |
-- | 1       | other  |
-- | 4       | male   |
-- | 7       | female |
-- | 2       | other  |
-- | 5       | male   |
-- | 9       | female |
-- | 6       | other  |
-- | 8       | male   |
-- +---------+--------+
-- Explanation: 
-- Female gender: IDs 3, 7, and 9.
-- Other gender: IDs 1, 2, and 6.
-- Male gender: IDs 4, 5, and 8.
-- We arrange the table alternating between 'female', 'other', and 'male'.
-- Note that the IDs of each gender are sorted in ascending order.

DROP TABLE IF EXISTS Genders;
CREATE TABLE Genders (
    user_id INT PRIMARY KEY,
    gender ENUM('female', 'male', 'other')
);
INSERT INTO Genders (user_id, gender)
VALUES 
(4, 'male'),
(7, 'female'),
(2, 'other'),
(5, 'male'),
(3, 'female'),
(8, 'male'),
(6, 'other'),
(1, 'other'),
(9, 'female');

-- m1 not working
SELECT 
        user_id,
        gender,
        ROW_NUMBER() OVER( ORDER BY CASE WHEN gender = 'female' THEN 1 
             WHEN gender = 'other' THEN 2
             ELSE 3 end) as gender_sequence,
        ROW_NUMBER() OVER(PARTITION BY gender ORDER BY user_id) as user_rank
FROM Genders ;
-----------------------------------------------------------------------------------------------------
-- m2
WITH cte as(
	SELECT user_id,
           gender,
           ROW_NUMBER() OVER(PARTITION BY gender ORDER BY user_id) as rnk1,
           CASE 
                WHEN gender='female' THEN 1 
                WHEN gender='other' THEN 2 
                ELSE 3 
           END AS rnk2 
    FROM Genders
)
SELECT user_id,
       gender
FROM cte
ORDER BY rnk1,
         rnk2;


-- 2051. The Category of Each Member in the Store
-- Description
-- Table: Members
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | member_id   | int     |
-- | name        | varchar |
-- +-------------+---------+
-- member_id is the primary key column for this table.
-- Each row of this table indicates the name and the ID of a member.
-- Table: Visits
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | visit_id    | int  |
-- | member_id   | int  |
-- | visit_date  | date |
-- +-------------+------+
-- visit_id is the primary key column for this table.
-- member_id is a foreign key to member_id from the Members table.
-- Each row of this table contains information about the date of a visit to the store
-- and the member who visited it.
-- Table: Purchases
-- +----------------+------+
-- | Column Name    | Type |
-- +----------------+------+
-- | visit_id       | int  |
-- | charged_amount | int  |
-- +----------------+------+
-- visit_id is the primary key column for this table.
-- visit_id is a foreign key to visit_id from the Visits table.
-- Each row of this table contains information about the amount charged in a visit to the store.
-- A store wants to categorize its members. There are three tiers:

-- "Diamond": if the conversion rate is greater than or equal to 80.
-- "Gold": if the conversion rate is greater than or equal to 50 and less than 80.
-- "Silver": if the conversion rate is less than 50.
-- "Bronze": if the member never visited the store.
-- The conversion rate of a member is 
--(100 * total number of purchases for the member) / total number of visits for the member.
-- Write an  SQL query to report the id, the name, and the category of each member.
-- Return the result table in any order.
-- The query result format is in the following example.
-- Example 1:
-- Input: 
-- Members table:
-- +-----------+---------+
-- | member_id | name    |
-- +-----------+---------+
-- | 9         | Alice   |
-- | 11        | Bob     |
-- | 3         | Winston |
-- | 8         | Hercy   |
-- | 1         | Narihan |
-- +-----------+---------+
-- Visits table:
-- +----------+-----------+------------+
-- | visit_id | member_id | visit_date |
-- +----------+-----------+------------+
-- | 22       | 11        | 2021-10-28 |
-- | 16       | 11        | 2021-01-12 |
-- | 18       | 9         | 2021-12-10 |
-- | 19       | 3         | 2021-10-19 |
-- | 12       | 11        | 2021-03-01 |
-- | 17       | 8         | 2021-05-07 |
-- | 21       | 9         | 2021-05-12 |
-- +----------+-----------+------------+
-- Purchases table:
-- +----------+----------------+
-- | visit_id | charged_amount |
-- +----------+----------------+
-- | 12       | 2000           |
-- | 18       | 9000           |
-- | 17       | 7000           |
-- +----------+----------------+
-- Output: 
-- +-----------+---------+----------+
-- | member_id | name    | category |
-- +-----------+---------+----------+
-- | 1         | Narihan | Bronze   |
-- | 3         | Winston | Silver   |
-- | 8         | Hercy   | Diamond  |
-- | 9         | Alice   | Gold     |
-- | 11        | Bob     | Silver   |
-- +-----------+---------+----------+
-- Explanation: 
-- - User Narihan with id = 1 did not make any visits to the store. She gets a Bronze category.
-- - User Winston with id = 3 visited the store one time and did not purchase anything.
-- The conversion rate = (100 * 0) / 1 = 0. He gets a Silver category.
-- - User Hercy with id = 8 visited the store one time and purchased one time. 
--The conversion rate = (100 * 1) / 1 = 1. He gets a Diamond category.
-- - User Alice with id = 9 visited the store two times and purchased one time.
-- The conversion rate = (100 * 1) / 2 = 50. She gets a Gold category.
-- - User Bob with id = 11 visited the store three times and purchased one time.
-- The conversion rate = (100 * 1

-- "Diamond": if the conversion rate is greater than or equal to 80.
-- "Gold": if the conversion rate is greater than or equal to 50 and less than 80.
-- "Silver": if the conversion rate is less than 50.
-- "Bronze": if the member never visited the store.

DROP TABLE Purchases;
DROP TABLE Visits;
DROP TABLE Members;
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE Visits (
    visit_id INT PRIMARY KEY,
    member_id INT,
    visit_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);
CREATE TABLE Purchases (
    visit_id INT PRIMARY KEY,
    charged_amount INT,
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);
INSERT INTO Members (member_id, name)
VALUES 
(9, 'Alice'),
(11, 'Bob'),
(3, 'Winston'),
(8, 'Hercy'),
(1, 'Narihan');
INSERT INTO Visits (visit_id, member_id, visit_date)
VALUES 
(22, 11, '2021-10-28'),
(16, 11, '2021-01-12'),
(18, 9, '2021-12-10'),
(19, 3, '2021-10-19'),
(12, 11, '2021-03-01'),
(17, 8, '2021-05-07'),
(21, 9, '2021-05-12');
INSERT INTO Purchases (visit_id, charged_amount)
VALUES 
(12, 2000),
(18, 9000),
(17, 7000);

-- not working
WITH cte as(
SELECT  m.member_id,name,SUM(CASE WHEN v.visit_id  IS NOT NULL THEN 1 ELSE 0 END) AS total_visit,
SUM(CASE WHEN  p.visit_id IS NOT NULL THEN 1 ELSE 0 END) AS purchase_visit
FROM Members m
LEFT JOIN Visits v
ON m.member_id=v.member_id
LEFT JOIN Purchases p
ON v.visit_id=p.visit_id
GROUP BY m.member_id,name
)
SELECT member_id,name,CASE WHEN total_visit=0 THEN 'Bronze' WHEN COUNT(total_visit)>=1 AND purchase_visit=0 THEN 'Silver' 
WHEN (100 * purchase_visit)/total_visit>=50 and (100 * purchase_visit)/total_visit <80 THEN 'Gold' 
WHEN (100 * purchase_visit)/total_visit>80 THEN 'Diamond' end as Category
FROM cte
GROUP BY 1,2;

-- METHOD 2 WHICH IS WORKING

WITH cte AS (
    SELECT  m.member_id,m.name, COUNT(v.visit_id) AS total_visit, 
        COUNT(p.visit_id) AS purchase_visit
    FROM Members m
    LEFT JOIN Visits v ON m.member_id = v.member_id
    LEFT JOIN Purchases p ON v.visit_id = p.visit_id
    GROUP BY m.member_id, m.name
)
SELECT 
    member_id,
    name,
    CASE 
        WHEN total_visit = 0 THEN 'Bronze'
        WHEN (100 * purchase_visit) / total_visit >= 80 THEN 'Diamond'
        WHEN (100 * purchase_visit) / total_visit >= 50 THEN 'Gold'
        ELSE 'Silver'
    END AS Category
FROM cte;


-- m3
WITH cte as(
SELECT m.member_id,m.name,COUNT(charged_amount) as purchase_cnt, COUNT(v.visit_id) as visit_cnt
FROM  Members as m
LEFT JOIN Visits as v
ON m.member_id = v.member_id
LEFT JOIN Purchases as p
ON p.visit_id = v.visit_id
GROUP BY 1
)
SELECT member_id,name,
CASE  WHEN visit_cnt = 0 THEN 'Bronze'
    WHEN (100*purchase_cnt)/visit_cnt >= 80 THEN 'Diamond'
    WHEN (100*purchase_cnt)/visit_cnt < 80 and (100*purchase_cnt)/visit_cnt >= 50 THEN 'Gold'
    WHEN (100*purchase_cnt)/visit_cnt < 50 THEN 'Silver'
END AS category
FROM cte;

-- m4 
WITH member_info as (
SELECT 
       m.member_id,
       name,
       COUNT(p.visit_id) as purchase_cnt,
       COUNT(v.visit_id) as visit_cnt,
       COUNT(p.visit_id)/COUNT(v.visit_id) as conversion
FROM members m 
LEFT JOIN visits v 
ON m.member_id = v.member_id 
LEFT JOIN purchases p 
ON p.visit_id = v.visit_id
GROUP BY m.member_id,
         name
)
SELECT member_id,
       name,
       CASE
    WHEN visit_cnt = 0 THEN 'bronze'
    WHEN conversion >= 0.80 THEN 'Diamond'
    WHEN conversion >= 0.50 THEN 'Gold'
    ELSE 'Silver'
END AS category

FROM member_info;

-- 1875. Group Employees of the Same Salary
-- Level
-- Medium
-- Description
-- Table: Employees
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | employee_id | int     |
-- | name        | varchar |
-- | salary      | int     |
-- +-------------+---------+
-- employee_id is the primary key for this table.
-- Each row of this table indicates the employee ID, employee name, and salary.
-- A company wants to divide the employees into teams such that all the members on each team
-- have the same salary. The teams should follow these criteria:
-- Each team should consist of at least two employees.
-- All the employees on a team should have the same salary.
-- All the employees of the same salary should be assigned to the same team.
-- If the salary of an employee is unique, we do not assign this employee to any team.
-- A team’s ID is assigned based on the rank of the team’s salary relative to the other teams’ salaries,
-- where the team with the lowest salary has team_id = 1. Note that the salaries for employees 
--not on a team are not included in this ranking.
-- Write an  SQL query to get the team_id of each employee that is in a team.

-- Return the result table ordered by team_id in ascending order. In case of a tie, order
-- it by employee_id in ascending order.
-- The query result format is in the following example:
-- Employees table:
-- +-------------+---------+--------+
-- | employee_id | name    | salary |
-- +-------------+---------+--------+
-- | 2           | Meir    | 3000   |
-- | 3           | Michael | 3000   |
-- | 7           | Addilyn | 7400   |
-- | 8           | Juan    | 6100   |
-- | 9           | Kannon  | 7400   |
-- +-------------+---------+--------+
-- Result table:
-- +-------------+---------+--------+---------+
-- | employee_id | name    | salary | team_id |
-- +-------------+---------+--------+---------+
-- | 2           | Meir    | 3000   | 1       |
-- | 3           | Michael | 3000   | 1       |
-- | 7           | Addilyn | 7400   | 2       |
-- | 9           | Kannon  | 7400   | 2       |
-- +-------------+---------+--------+---------+

-- Meir (employee_id=2) and Michael (employee_id=3) are in the same team because they have the same salary of 3000.
-- Addilyn (employee_id=7) and Kannon (employee_id=9) are in the same team because they have the same salary of 7400.
-- Juan (employee_id=8) is not included in any team because their salary of 6100 is unique (i.e. no other employee has the same salary).
-- The team IDs are assigned as follows (based on salary ranking, lowest first):
-- - team_id=1: Meir and Michael, salary of 3000
-- - team_id=2: Addilyn and Kannon, salary of 7400
-- Juan's salary of 6100 is not included in the ranking because they are not on a team.

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary INT
);
INSERT INTO Employees (employee_id, name, salary) 
VALUES 
(2, 'Meir', 3000),
(3, 'Michael', 3000),
(7, 'Addilyn', 7400),
(8, 'Juan', 6100),
(9, 'Kannon', 7400);

WITH cte AS (
	SELECT *, COUNT(employee_id) OVER (PARTITION BY salary) AS num_of_emp_in_that_group 
    FROM Employees
)
SELECT employee_id, name, salary, DENSE_RANK() OVER (ORDER BY salary) AS team_id
FROM cte
WHERE num_of_emp_in_that_group >= 2 
ORDER BY team_id, employee_id;

-- 2314. The First Day of the Maximum Recorded Degree in Each City
-- Description
-- Table: Weather
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | city_id     | int  |
-- | day         | date |
-- | degree      | int  |
-- +-------------+------+
-- (city_id, day) is the primary key for this table.
-- Each row in this table contains the degree of the weather of a city on a certain day.
-- All the degrees are recorded in the year 2022.
-- Write an  SQL query to report the day that has the maximum recorded degree in each city.
--  If the maximum degree was recorded for the same city multiple times, return the earliest day among them.
-- Return the result table ordered by city_id in ascending order.
-- The query result format is shown in the following example.
-- Example 1:
-- Input: 
-- Weather table:
-- +---------+------------+--------+
-- | city_id | day        | degree |
-- +---------+------------+--------+
-- | 1       | 2022-01-07 | -12    |
-- | 1       | 2022-03-07 | 5      |
-- | 1       | 2022-07-07 | 24     |
-- | 2       | 2022-08-07 | 37     |
-- | 2       | 2022-08-17 | 37     |
-- | 3       | 2022-02-07 | -7     |
-- | 3       | 2022-12-07 | -6     |
-- +---------+------------+--------+
-- Output: 
-- +---------+------------+--------+
-- | city_id | day        | degree |
-- +---------+------------+--------+
-- | 1       | 2022-07-07 | 24     |
-- | 2       | 2022-08-07 | 37     |
-- | 3       | 2022-12-07 | -6     |
-- +---------+------------+--------+
-- Explanation: 
-- For city 1, the maximum degree was recorded on 2022-07-07 with 24 degrees.
-- For city 1, the maximum degree was recorded on 2022-08-07 and 2022-08-17 with 37 degrees.
-- We choose the earlier date (2022-08-07).
-- For city 3, the maximum degree was recorded on 2022-12-07 with -6 degrees.

DROP TABLE IF EXISTS Weather;

CREATE TABLE Weather (
    city_id INT,
    day DATE,
    degree INT,
    PRIMARY KEY (city_id, day)
);
INSERT INTO Weather (city_id, day, degree)
VALUES
(1, '2022-01-07', -12),
(1, '2022-03-07', 5),
(1, '2022-07-07', 24),
(2, '2022-08-07', 37),
(2, '2022-08-17', 37),
(3, '2022-02-07', -7),
(3, '2022-12-07', -6);

SELECT DISTINCT city_id,FIRST_VALUE(day) OVER(partition by city_id ORDER BY degree desc) as day,
FIRST_VALUE(degree) OVER(partition by city_id ORDER BY degree desc) as degree
FROM Weather
ORDER BY 1;

-- m2
WITH cte as(
SELECT *,ROW_NUMBER() OVER(PARTITION BY city_id ORDER BY degree DESC,day) AS RNK
FROM Weather
)
SELECT city_id, day,degree
FROM cte
WHERE rnk = 1;
