-- 3328. Find Cities in Each State II
-- Description
-- Table: cities
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | state       | varchar |
-- | city        | varchar |
-- +-------------+---------+
-- (state, city) is the combination of columns with unique values for this table.
-- Write a solution to find all the cities in each state and analyze them based on:
-- Combine all cities into a comma-separated string for each state.
-- Only include states that have at least 3 cities.
-- Only include states where at least one city starts with the same letter as the state name.
-- Return the result table ordered by matching_letter_count descending, then state name ascending.
-- Example:
-- Input:
-- cities table:
-- +--------------+---------------+
-- | state        | city          |
-- +--------------+---------------+
-- | New York     | New York City |
-- | New York     | Newark        |
-- | New York     | Buffalo       |
-- | New York     | Rochester     |
-- | California   | San Francisco |
-- | California   | Sacramento    |
-- | California   | San Diego     |
-- | California   | Los Angeles   |
-- | Texas        | Tyler         |
-- | Texas        | Temple        |
-- | Texas        | Taylor        |
-- | Texas        | Dallas        |
-- | Pennsylvania | Philadelphia  |
-- | Pennsylvania | Pittsburgh    |
-- | Pennsylvania | Pottstown     |
-- +--------------+---------------+
-- Output:
-- +--------------+-------------------------------------------+-----------------------+
-- | state        | cities                                    | matching_letter_count |
-- +--------------+-------------------------------------------+-----------------------+
-- | Pennsylvania | Philadelphia, Pittsburgh, Pottstown       | 3                     |
-- | Texas        | Dallas, Taylor, Temple, Tyler             | 3                     |
-- | New York     | Buffalo, Newark, New York City, Rochester | 2                     |
-- +--------------+-------------------------------------------+-----------------------+

DROP TABLE cities;
Create table if not exists cities( state varchar(100),city varchar(100));
Truncate table cities;
insert into cities (state, city) values ('New York', 'New York City');
insert into cities (state, city) values ('New York', 'Newark');
insert into cities (state, city) values ('New York', 'Buffalo');
insert into cities (state, city) values ('New York', 'Rochester');
insert into cities (state, city) values ('California', 'San Francisco');
insert into cities (state, city) values ('California', 'Sacramento');
insert into cities (state, city) values ('California', 'San Diego');
insert into cities (state, city) values ('California', 'Los Angeles');
insert into cities (state, city) values ('Texas', 'Tyler');
insert into cities (state, city) values ('Texas', 'Temple');
insert into cities (state, city) values ('Texas', 'Taylor');
insert into cities (state, city) values ('Texas', 'Dallas');
insert into cities (state, city) values ('Pennsylvania', 'Philadelphia');
insert into cities (state, city) values ('Pennsylvania', 'Pittsburgh');
insert into cities (state, city) values ('Pennsylvania', 'Pottstown');

SELECT state,
    GROUP_CONCAT(city ORDER BY city SEPARATOR ', ') AS cities,
    COUNT(CASE WHEN LEFT(city, 1) = LEFT(state, 1) THEN 1 END) AS matching_letter_count
FROM cities
GROUP BY 1
HAVING COUNT(city) >= 3 AND matching_letter_count > 0
ORDER BY 3 DESC, 1;
