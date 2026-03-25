# -- 1988. Find Cutoff Score for Each School
# -- Level
# -- Medium
# -- Description
# -- Table: Schools
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | school_id   | int  |
# -- | capacity    | int  |
# -- +-------------+------+
# -- school_id is the primary key for this table.
# -- This table contains information about the capacity of some schools. The capacity is the maximum number 
# --of students the school can accept.
# -- Table: Exam
# -- +---------------+------+
# -- | Column Name   | Type |
# -- +---------------+------+
# -- | score         | int  |
# -- | student_count | int  |
# -- +---------------+------+
# -- score is the primary key for this table.
# -- Each row in this table indicates that there are student_count students that got at least score points
# -- in the exam.
# -- The data in this table will be logically correct, meaning a row recording a higher score will have 
# --the same or smaller 
# -- student_count compared to a row recording a lower score. More formally, for every two rows i and j
# -- in the table, if scorei > scorej then student_counti <= student_countj.
# -- Every year, each school announces a minimum score requirement that a student needs to apply to it.
# -- The school chooses 
# -- the minimum score requirement based on the exam results of all the students:

# -- They want to ensure that even if every student meeting the requirement applies,
# -- the school can accept everyone.
# -- They also want to maximize the possible number of students that can apply.
# -- They must use a score that is in the Exam table.
# -- Write an  SQL query to report the minimum score requirement for each school.
# -- If there are multiple score values 
# -- satisfying the above conditions, choose the smallest one. If the input data is not 
# -- enough to determine the score, report -1.
# -- Return the result table in any order.
# -- The query result format is in the following example.
# -- Example 1:
# -- Input:
# -- Schools table:
# -- +-----------+----------+
# -- | school_id | capacity |
# -- +-----------+----------+
# -- | 11        | 151      |
# -- | 5         | 48       |
# -- | 9         | 9        |
# -- | 10        | 99       |
# -- +-----------+----------+
# -- Exam table:
# -- +-------+---------------+
# -- | score | student_count |
# -- +-------+---------------+
# -- | 975   | 10            |
# -- | 966   | 60            |
# -- | 844   | 76            |
# -- | 749   | 76            |
# -- | 744   | 100           |
# -- +-------+---------------+
# -- Output:
# -- +-----------+-------+
# -- | school_id | score |
# -- +-----------+-------+
# -- | 5         | 975   |
# -- | 9         | -1    |
# -- | 10        | 749   |
# -- | 11        | 744   |
# -- +-----------+-------+

# -- Explanation: 
# -- - School 5: The school's capacity is 48. Choosing 975 as the min score requirement, 
# --the school will get at most 10 applications, which is within capacity.
# -- - School 10: The school's capacity is 99. Choosing 844 or 749 as the min score requirement,
# -- the school will get at most 76 applications, 
# -- which is within capacity. We choose the smallest of them, which is 749.
# -- - School 11: The school's capacity is 151. Choosing 744 as the min score requirement,
# -- the school will get at most 100 applications, which is within capacity.
# -- - School 9: The data given is not enough to determine the min score requirement. Choosing 975 as the m

import pandas as pd
import numpy as np

schools_data = {
    'school_id': [11, 5, 9, 10],
    'capacity': [151, 48, 9, 99]
}

exam_data = {
    'score': [975, 966, 844, 749, 744],
    'student_count': [10, 60, 76, 76, 100]
}



# -- m2 
# WITH cte as(
#     SELECT *,ROW_NUMBER() OVER(PARTITION BY school_id ORDER BY score) as rnk
#     FROM Schools s 
#     LEFT JOIN exam e
#     ON s.capacity >= e.student_count
# )
# SELECT school_id, IFNULL(score,-1) as score
# FROM cte
# WHERE rnk = 1;

# -- 1501. Countries You Can Safely Invest In
# -- Description
# -- Table Person:
# -- +----------------+---------+
# -- | Column Name    | Type    |
# -- +----------------+---------+
# -- | id             | int     |
# -- | name           | varchar |
# -- | phone_number   | varchar |
# -- +----------------+---------+
# -- id is the column of unique values for this table.
# -- Each row of this table contains the name of a person and their phone number.
# -- Phone number will be in the form 'xxx-yyyyyyy' where xxx is the country code (3 characters) 
# -- and yyyyyyy is the phone number (7 characters) where x and y are digits. Both can contain leading zeros.
# -- Table Country:
# -- +----------------+---------+
# -- | Column Name    | Type    |
# -- +----------------+---------+
# -- | name           | varchar |
# -- | country_code   | varchar |
# -- +----------------+---------+
# -- country_code is the column of unique values for this table.
# -- Each row of this table contains the country name and its code. 
# --country_code will be in the form 'xxx' where x is digits.
# -- Table Calls:
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | caller_id   | int  |
# -- | callee_id   | int  |
# -- | duration    | int  |
# -- +-------------+------+
# -- This table may contain duplicate rows.
# -- Each row of this table contains the caller id, callee id and the 
# --duration of the call in minutes. caller_id != callee_id
# -- A telecommunications company wants to invest in new countries. 
# --The company intends to invest in the countries where the 
# -- average call duration of the calls in this country is strictly 
# --greater than the global average call duration.
# -- Write a solution to find the countries where this company can invest.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Person table:
# -- +----+----------+--------------+
# -- | id | name     | phone_number |
# -- +----+----------+--------------+
# -- | 3  | Jonathan | 051-1234567  |
# -- | 12 | Elvis    | 051-7654321  |
# -- | 1  | Moncef   | 212-1234567  |
# -- | 2  | Maroua   | 212-6523651  |
# -- | 7  | Meir     | 972-1234567  |
# -- | 9  | Rachel   | 972-0011100  |
# -- +----+----------+--------------+
# -- Country table:
# -- +----------+--------------+
# -- | name     | country_code |
# -- +----------+--------------+
# -- | Peru     | 051          |
# -- | Israel   | 972          |
# -- | Morocco  | 212          |
# -- | Germany  | 049          |
# -- | Ethiopia | 251          |
# -- +----------+--------------+
# -- Calls table:
# -- +-----------+-----------+----------+
# -- | caller_id | callee_id | duration |
# -- +-----------+-----------+----------+
# -- | 1         | 9         | 33       |
# -- | 2         | 9         | 4        |
# -- | 1         | 2         | 59       |
# -- | 3         | 12        | 102      |
# -- | 3         | 12        | 330      |
# -- | 12        | 3         | 5        |
# -- | 7         | 9         | 13       |
# -- | 7         | 1         | 3        |
# -- | 9         | 7         | 1        |
# -- | 1         | 7         | 7        |
# -- +-----------+-----------+----------+
# -- Output: 
# -- +----------+
# -- | country  |
# -- +----------+
# -- | Peru     |
# -- +----------+
# -- Explanation: 
# -- The average call duration for Peru is (102 + 102 + 330 + 330 + 5 + 5) / 6 = 145.666667
# -- The average call duration for Israel is (33 + 4 + 13 + 13 + 3 + 1 + 1 + 7) / 8 = 9.37500
# -- The average call duration for Morocco is (33 + 4 + 59 + 59 + 3 + 7) / 6 = 27.5000 
# -- Global call duration average = (2 * (33 + 4 + 59 + 102 + 330 + 5 + 13 + 3 + 1 + 7)) / 20 = 55.70000
# -- Since Peru is the only country where the average call duration is greater than the global average, it is the only

# DROP TABLE IF EXISTS Person;
# DROP TABLE IF EXISTS Country;
# DROP TABLE IF EXISTS Calls;


# CREATE TABLE Person (
#     id INT PRIMARY KEY,
#     name VARCHAR(100),
#     phone_number VARCHAR(11)
# );

# CREATE TABLE Country (
#     name VARCHAR(100),
#     country_code VARCHAR(3) PRIMARY KEY
# );

# CREATE TABLE Calls (
#     caller_id INT,
#     callee_id INT,
#     duration INT
# );

# INSERT INTO Person (id, name, phone_number)
# VALUES
# (3, 'Jonathan', '051-1234567'),
# (12, 'Elvis', '051-7654321'),
# (1, 'Moncef', '212-1234567'),
# (2, 'Maroua', '212-6523651'),
# (7, 'Meir', '972-1234567'),
# (9, 'Rachel', '972-0011100');

# INSERT INTO Country (name, country_code)
# VALUES
# ('Peru', '051'),
# ('Israel', '972'),
# ('Morocco', '212'),
# ('Germany', '049'),
# ('Ethiopia', '251');

# INSERT INTO Calls (caller_id, callee_id, duration)
# VALUES
# (1, 9, 33),
# (2, 9, 4),
# (1, 2, 59),
# (3, 12, 102),
# (3, 12, 330),
# (12, 3, 5),
# (7, 9, 13),
# (7, 1, 3),
# (9, 7, 1),
# (1, 7, 7);

# SELECT c.name AS country
# FROM Country c
# JOIN Person p 
# ON SUBSTRING(p.phone_number, 1, 3) COLLATE utf8mb4_general_ci = CAST(c.country_code AS CHAR) COLLATE utf8mb4_general_ci
# LEFT JOIN Calls ca 
# ON p.id = ca.caller_id OR p.id = ca.callee_id
# GROUP BY c.name
# HAVING AVG(duration) > (SELECT 2 * AVG(duration) FROM Calls);


