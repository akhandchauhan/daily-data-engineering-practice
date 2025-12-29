
-- Question 1
-- In a football tournament, some data is recorded. Every winning team gets a point and the losing team loses a point. 
-- At the end of the tournament, a ranking is given to all the teams based on their total points. The total points of a 
-- team can be negative.
-- You are given two tables: Matches Record and Team Details.
-- The ranking should be calculated according to the following rules:
-- The total points should be ranked from highest to lowest.
-- If two teams have the same total points, then the team with the higher number of winning goals should be ranked higher.

DROP TABLE matches;

CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    winning_team_id INT,
    losing_team_id INT,
    goals_won INT
);
delete from matches;
INSERT INTO matches (match_id, winning_team_id, losing_team_id, goals_won) VALUES
(1, 1001, 1007, 1),
(2, 1007, 1001, 2),
(3, 1006, 1003, 3),
(4, 1001, 1003, 1),
(5, 1007, 1001, 1),
(6, 1006, 1003, 2),
(7, 1006, 1001, 3),
(8, 1007, 1003, 5),
(9, 1001, 1003, 1),
(10, 1007, 1006, 2),
(11, 1006, 1003, 3),
(12, 1001, 1003, 4),
(13, 1001, 1006, 2),
(14, 1007, 1001, 4),
(15, 1006, 1007, 3),
(16, 1001, 1003, 3),
(17, 1001, 1007, 3),
(18, 1006, 1007, 2),
(19, 1003, 1001, 1);

insert into matches values
(20, 1001, 1007, 3),
(21, 1001, 1003, 3);
;

WITH matches_info as (
    SELECT winning_team_id as team_id, 1 as points,goals_won
    FROM matches
    UNION ALL
    SELECT losing_team_id, -1 as points, 0
    FROM matches
)
, mathces_info_agg as (
    SELECT team_id,
        SUM(points) as total_points,
        SUM(goals_won) as total_scored,
        RANK() OVER(ORDER BY SUM(points) DESC, SUM(goals_won) DESC) AS rnk
    FROM matches_info
    GROUP BY 1
)
SELECT team_id
FROM mathces_info_agg
ORDER BY rnk