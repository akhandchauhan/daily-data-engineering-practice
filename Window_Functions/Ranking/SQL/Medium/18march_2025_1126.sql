-- 1126. Active Businesses
-- Table: Events
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | business_id   | int     |
-- | event_type    | varchar |
-- | occurences    | int     |
-- +---------------+---------+
-- (business_id, event_type) is the primary key of this table.
-- Each row in the table logs the info that an event of some type occured at some business for
-- a number of times.
-- Write an  SQL query to find all active businesses.
-- An active business is a business that has more than one event type with occurences greater 
--than the average occurences of that event type among all businesses.
-- Events table:
-- +-------------+------------+------------+
-- | business_id | event_type | occurences |
-- +-------------+------------+------------+
-- | 1           | reviews    | 7          |
-- | 3           | reviews    | 3          |
-- | 1           | ads        | 11         |
-- | 2           | ads        | 7          |
-- | 3           | ads        | 6          |
-- | 1           | page views | 3          |
-- | 2           | page views | 12         |
-- +-------------+------------+------------+
-- Result table:
-- +-------------+
-- | business_id |
-- +-------------+
-- | 1           |
-- +-------------+
-- Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
-- Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an 
--active business.
DROP TABLE IF EXISTS Events;
CREATE TABLE Events (
    business_id INT,
    event_type VARCHAR(255),
    occurences INT,
    PRIMARY KEY (business_id, event_type)
);

INSERT INTO Events (business_id, event_type, occurences) VALUES
(1, 'reviews', 7),
(3, 'reviews', 3),
(1, 'ads', 11),
(2, 'ads', 7),
(3, 'ads', 6),
(1, 'page views', 3),
(2, 'page views', 12);

-- m1
WITH cte as(
SELECT *, AVG(occurences) OVER(PARTITION BY event_type) as avg_occ
FROM Events
)
SELECT business_id
FROM cte
WHERE occurences > avg_occ
GROUP BY business_id
HAVING COUNT(DISTINCT event_type) > 1;


----------------------------------------------------------------------------------------------------------
--m2 Wrong 

WITH average_occurence_info AS (
    SELECT 
        event_type,
        AVG(occurences) AS average_occurences
    FROM Events 
    GROUP BY event_type
), 
-- event_type average_occurences
-- ads	8
-- page views	7.5
-- reviews	5
events_frequency AS (
    SELECT 
        business_id,
        COUNT(DISTINCT event_type) AS event_type_count
    FROM Events 
    GROUP BY business_id
)
-- business_id event_type_count
-- 1	3
-- 2	2
-- 3	2
-- An active business is a business that has more than one event type with occurences greater 
-- than the average occurences of that event type among all businesses.
SELECT 
        e.business_id
FROM Events e 
JOIN average_occurence_info aoi 
ON e.event_type = aoi.event_type
JOIN events_frequency ef 
ON ef.business_id = e.business_id
AND aoi.average_occurences < e.occurences
AND ef.event_type_count > 1;



----------------------------------------------------------------------------------------------------------

--m3

SELECT business_id
FROM (
    SELECT
        business_id,
        event_type,
        occurences,
        AVG(occurences) OVER (PARTITION BY event_type) AS avg_occ
    FROM Events
) t
WHERE occurences > avg_occ
GROUP BY business_id
HAVING COUNT(*) > 1;