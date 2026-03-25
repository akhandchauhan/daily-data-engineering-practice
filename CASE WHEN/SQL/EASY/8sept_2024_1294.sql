-- 1294. Weather Type in Each Country
-- Description
-- Table: Countries
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | country_id    | int     |
-- | country_name  | varchar |
-- +---------------+---------+
-- country_id is the primary key (column with unique values) for this table.
-- Each row of this table contains the ID and the name of one country.
-- Table: Weather
-- +---------------+------+
-- | Column Name   | Type |
-- +---------------+------+
-- | country_id    | int  |
-- | weather_state | int  |
-- | day           | date |
-- +---------------+------+
-- (country_id, day) is the primary key (combination of columns with unique values) for this table.
-- Each row of this table indicates the weather state in a country for one day.
-- Write a solution to find the type of weather in each country for November 2019.
-- The type of weather is:
-- Cold if the average weather_state is less than or equal 15,
-- Hot if the average weather_state is greater than or equal to 25, and
-- Warm otherwise.
-- Return the result table in any order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Countries table:
-- +------------+--------------+
-- | country_id | country_name |
-- +------------+--------------+
-- | 2          | USA          |
-- | 3          | Australia    |
-- | 7          | Peru         |
-- | 5          | China        |
-- | 8          | Morocco      |
-- | 9          | Spain        |
-- +------------+--------------+
-- Weather table:
-- +------------+---------------+------------+
-- | country_id | weather_state | day        |
-- +------------+---------------+------------+
-- | 2          | 15            | 2019-11-01 |
-- | 2          | 12            | 2019-10-28 |
-- | 2          | 12            | 2019-10-27 |
-- | 3          | -2            | 2019-11-10 |
-- | 3          | 0             | 2019-11-11 |
-- | 3          | 3             | 2019-11-12 |
-- | 5          | 16            | 2019-11-07 |
-- | 5          | 18            | 2019-11-09 |
-- | 5          | 21            | 2019-11-23 |
-- | 7          | 25            | 2019-11-28 |
-- | 7          | 22            | 2019-12-01 |
-- | 7          | 20            | 2019-12-02 |
-- | 8          | 25            | 2019-11-05 |
-- | 8          | 27            | 2019-11-15 |
-- | 8          | 31            | 2019-11-25 |
-- | 9          | 7             | 2019-10-23 |
-- | 9         6 | 3             | 2019-12-23 |
-- +------------+---------------+------------+

-- Output: 
-- +--------------+--------------+
-- | country_name | weather_type |
-- +--------------+--------------+
-- | USA          | Cold         |
-- | Australia    | Cold         |
-- | Peru         | Hot          |
-- | Morocco      | Hot          |
-- | China        | Warm         |
-- +--------------+--------------+
-- Explanation: 
-- Average weather_state in USA in November is (15) / 1 = 15 so weather type is Cold.
-- Average weather_state in Austraila in November is (-2 + 0 + 3) / 3 = 0.333 so weather type is Cold.
-- Average weather_state in Peru in November is (25) / 1 = 25 so the weather type is Hot.
-- Average weather_state in China in November is (16 + 18 + 21) / 3 = 18.333 so weather type is Warm.
-- Average weather_state in Morocco in November is (25 + 27 + 31) / 3 = 27.667 so weather type is Hot.
-- We know nothing about the average weather_state in Spain in November so we do not include it in the result table.


DROP TABLE Countries;
DROP TABLE Weather;
-- Create Countries table
CREATE TABLE Countries (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(50)
);

-- Create Weather table
CREATE TABLE Weather (
    country_id INT,
    weather_state INT,
    day DATE,
    PRIMARY KEY (country_id, day)
);

-- Insert data into Countries table
INSERT INTO Countries (country_id, country_name) VALUES
(2, 'USA'),
(3, 'Australia'),
(7, 'Peru'),
(5, 'China'),
(8, 'Morocco'),
(9, 'Spain');

-- Insert data into Weather table
INSERT INTO Weather (country_id, weather_state, day) VALUES
(2, 15, '2019-11-01'),
(2, 12, '2019-10-28'),
(2, 12, '2019-10-27'),
(3, -2, '2019-11-10'),
(3, 0, '2019-11-11'),
(3, 3, '2019-11-12'),
(5, 16, '2019-11-07'),
(5, 18, '2019-11-09'),
(5, 21, '2019-11-23'),
(7, 25, '2019-11-28'),
(7, 22, '2019-12-01'),
(7, 20, '2019-12-02'),
(8, 25, '2019-11-05'),
(8, 27, '2019-11-15'),
(8, 31, '2019-11-25'),
(9, 7, '2019-10-23'),
(9, 3, '2019-12-23');

SELECT c.country_name,CASE WHEN AVG(weather_state)<=15 THEN 'Cold' 
WHEN AVG(weather_state)>=25 THEN 'Hot' 
ELSE 'Warm' END as weather_type 
FROM Weather w
LEFT JOIN Countries c
USING (country_id)
WHERE YEAR(day)=2019 and month(day)=11
GROUP BY c.country_name;

-- m2 
----------------------------------------------------------------------------------------------------------------------------------

WITH country_weather_info as (
    SELECT c.country_name,
        AVG(weather_state) as avg_weather_state
    FROM countries c 
    LEFT JOIN weather w
    ON c.country_id = w.country_id
    WHERE MONTH(w.day) = 11
    AND YEAR(w.day) = 2019
    GROUP BY c.country_name
)
SELECT country_name,
       CASE WHEN avg_weather_state <= 15 THEN 'cold'
       WHEN avg_weather_state >= 25 THEN 'Hot'
       ELSE 'warm'
       END AS weather_type
FROM country_weather_info;
----------------------------------------------------------------------------------------------------------------------------------
-- m3 
SELECT c.country_name,
       CASE WHEN AVG(w.weather_state) <= 15 THEN 'Cold'
       WHEN AVG(w.weather_state) >= 25 THEN 'Hot'
       ELSE 'Warm' END AS weather_type
FROM Countries c 
LEFT JOIN Weather w 
ON c.country_id = w.country_id
WHERE DATE_FORMAT(w.day,'%Y-%m') = '2019-11'
GROUP BY c.country_name;


