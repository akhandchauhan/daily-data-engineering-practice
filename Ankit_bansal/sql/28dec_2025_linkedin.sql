-- There is a table of employee location information called emp_details.
-- Each record contains a person's name and the city where they live.

-- Write a query to return a list of teams.

-- Team formation rules:
-- 1. Team members must live in the city they represent.
-- 2. For each city, create teams of 3 until fewer than 3 people remain unassigned.
-- 3. When fewer than 3 people are unassigned in a city, they form a team.

-- Report requirements:
-- 1. Output 3 columns: city name, a comma-delimited list of up to 3 players, and the team name.
-- 2. Cities should be ordered alphabetically.
-- 3. Players are selected in the order they occur in the table.
-- 4. Player names must be ordered alphabetically within the comma-delimited list.
-- 5. Team names should be 'Team' plus a number (Team1, Team2, …).
--    Only show the first 20 rows.

DROP TABLE emp_details;

-- Create the table
CREATE TABLE emp_details (
    emp_name VARCHAR(10),
    city VARCHAR(15)
);

-- Insert sample data
INSERT INTO emp_details (emp_name, city) VALUES
('Sam', 'New York'),
('David', 'New York'),
('Peter', 'New York'),
('Chris', 'New York'),
('John', 'New York'),
('Steve', 'San Francisco'),
('Rachel', 'San Francisco'),
('Robert', 'Los Angeles');


-------------------------------------------------------------------------------------------------------------------------------
-- m1

WITH base AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY city ORDER BY city) AS rn
    FROM emp_details
),
grouped AS (
    SELECT *,
           CEIL(rn/3.0) AS hint
    FROM base
)
SELECT 
    city,
    GROUP_CONCAT(emp_name ORDER BY emp_name ASC) AS team_group,
    CONCAT('Team', ROW_NUMBER() OVER(ORDER BY city, hint)) AS team_name
FROM grouped
GROUP BY city, hint
ORDER BY city ASC, hint ASC;
