-- 1990. Count the Number of Experiments
-- Level
-- Description
-- Table: Experiments
-- +-----------------+------+
-- | Column Name     | Type |
-- +-----------------+------+
-- | experiment_id   | int  |
-- | platform        | enum |
-- | experiment_name | enum |
-- +-----------------+------+
-- experiment_id is the primary key for this table.
-- platform is an enum with one of the values ('Android', 'IOS', 'Web').
-- experiment_name is an enum with one of the values ('Reading', 'Sports', 'Programming').
-- This table contains information about the ID of an experiment done with a random person,
-- the platform used to do the experiment, and the name of the experiment.
-- Write an  SQL query to report the number of experiments done on each of the three
-- platforms for each of the three given experiments. 
-- Notice that all the pairs of (platform, experiment) should be included in the output
-- including the pairs with zero experiments.
-- Return the result table in any order.
-- The query result format is in the following example.
-- Example 1:
-- Input:
-- Experiments table:
-- +---------------+----------+-----------------+
-- | experiment_id | platform | experiment_name |
-- +---------------+----------+-----------------+
-- | 4             | IOS      | Programming     |
-- | 13            | IOS      | Sports          |
-- | 14            | Android  | Reading         |
-- | 8             | Web      | Reading         |
-- | 12            | Web      | Reading         |
-- | 18            | Web      | Programming     |
-- +---------------+----------+-----------------+
-- Output: 
-- +----------+-----------------+-----------------+
-- | platform | experiment_name | num_experiments |
-- +----------+-----------------+-----------------+
-- | Android  | Reading         | 1               |
-- | Android  | Sports          | 0               |
-- | Android  | Programming     | 0               |
-- | IOS      | Reading         | 0               |
-- | IOS      | Sports          | 1               |
-- | IOS      | Programming     | 1               |
-- | Web      | Reading         | 2               |
-- | Web      | Sports          | 0               |
-- | Web      | Programming     | 1               |
-- +----------+-----------------+-----------------+
-- Explanation: 
-- On the platform "Android", we had only one "Reading" experiment.
-- On the platform "IOS", we had one "Sports" experiment and one "Programming" experiment.
-- On the platform "Web", we had two "Reading" experiments and one "Programming" experiment.
DROP TABLE experiments;
CREATE TABLE Experiments (
    experiment_id INT PRIMARY KEY,
    platform ENUM('Android', 'IOS', 'Web'),
    experiment_name ENUM('Reading', 'Sports', 'Programming')
);
INSERT INTO Experiments (experiment_id, platform, experiment_name)
VALUES
(4, 'IOS', 'Programming'),
(13, 'IOS', 'Sports'),
(14, 'Android', 'Reading'),
(8, 'Web', 'Reading'),
(12, 'Web', 'Reading'),
(18, 'Web', 'Programming');

WITH all_combinations AS (
    SELECT p.platform, e.experiment_name
    FROM (SELECT DISTINCT platform FROM Experiments) p
    CROSS JOIN (SELECT DISTINCT experiment_name FROM Experiments) e
)
SELECT ac.platform, 
       ac.experiment_name, 
       COALESCE(COUNT(exp.platform), 0) AS num_experiments
FROM all_combinations ac
LEFT JOIN Experiments exp
    ON ac.platform = exp.platform 
    AND ac.experiment_name = exp.experiment_name
GROUP BY ac.platform, ac.experiment_name
ORDER BY ac.platform, ac.experiment_name;

----------------------------------------------------------------------------------------------------------------------------------

-- most brute force m2 
WITH cte_platform as (
SELECT 'Android' as platform
FROM experiments
UNION 
SELECT 'IOS' as platform
FROM experiments
union
SELECT 'Web' as platform
FROM experiments
),
 exp_name as (
SELECT 'Reading' as exp_name
FROM experiments
UNION 
SELECT 'Sports' 
FROM experiments
union
SELECT 'Programming' 
FROM experiments
),
cte3 as(
SELECT *
FROM exp_name,cte_platform
)
SELECT exp_name, cte3.platform,COUNT(experiment_id) as cnt
FROM cte3
LEFT JOIN experiments e
ON exp_name =experiment_name and cte3.platform = e.platform 
GROUP BY 1,2;

----------------------------------------------------------------------------------------------------------------------------------

-- m3

WITH platform_info as (
    SELECT 'Android' as platform
    UNION 
    SELECT 'IOS' 
    UNION 
    SELECT 'Web'
),
experiment_info as (
    SELECT 'Reading' as experiment_name
    UNION 
    SELECT 'Programming'
    UNION 
    SELECT 'Sports'
)
SELECT pi.platform,
       ei.experiment_name,
       COUNT(e.experiment_id) AS num_experiments
FROM platform_info pi
CROSS JOIN experiment_info ei
LEFT JOIN Experiments e 
ON e.experiment_name = ei.experiment_name
AND e.platform = pi.platform
GROUP BY pi.platform,
         ei.experiment_name
ORDER BY 1;