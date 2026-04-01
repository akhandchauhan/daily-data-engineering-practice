-- 613. Shortest Distance in a Line
-- Table point holds the x coordinate of some points on x-axis in a plane, 
--which are all integers.
-- Write a query to find the shortest distance between two points in these points.
-- | x   |
-- |-----|
-- | -1  |
-- | 0   |
-- | 2   |
-- The shortest distance is '1' obviously, which is from point '-1' to '0'. So
-- the output is as below:
-- | shortest|
-- |---------|
-- | 1       |
-- Note: Every point is unique, which means there is no duplicates in table point.
-- Follow-up: What if all these points have an id and are arranged from the left most
-- to the right 
--most of x axis?
DROP TABLE Points;
CREATE TABLE points (
    x  INT
);

INSERT INTO points (x ) VALUES (-1),(0),(2);


SELECT  MIN(ABS(p1.x - p2.x)) AS shortest
FROM points p1 
CROSS JOIN points p2
WHERE p1.x <> p2.x;

---------------------------------------------------------------------------------------
-- m2 
select min(abs(p2.x-p1.x)) as shortest 
from Point p1 
join Point p2
where p1.x<p2.x;

---------------------------------------------------------------------------------------
-- m3
SELECT MIN(x - prev_x) AS shortest
FROM (
    SELECT 
        x,
        LAG(x) OVER (ORDER BY x) AS prev_x
    FROM points
) t
WHERE prev_x IS NOT NULL;

---------------------------------------------------------------------------------------
-- Follow-up question:

CREATE TABLE points2 (id INT,x INT);

INSERT INTO points2 VALUES (1,-1),(2,0),(3,2),(4,2),(5,2);

-- m1
SELECT MIN(ABS(p2.x-p1.x)) AS shortest
FROM points2 p1
JOIN points2 p2
ON p1.id < p2.id ;



