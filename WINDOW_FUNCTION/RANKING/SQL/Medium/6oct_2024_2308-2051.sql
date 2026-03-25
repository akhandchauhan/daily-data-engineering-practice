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




