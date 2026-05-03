-- 612. Shortest Distance in a Plane
-- Description
-- Table: Point2D
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | x           | int  |
-- | y           | int  |
-- +-------------+------+
-- (x, y) is the primary key column (combination of columns with unique values) for this table.
-- Each row of this table indicates the position of a point on the X-Y plane.

-- The distance between two points p1(x1, y1) and p2(x2, y2) is sqrt((x2 - x1)2 + (y2 - y1)2).

-- Write a solution to report the shortest distance between any two points from the Point2D table.
-- Round the distance to two decimal points.
-- Input: 
-- Point2D table:
-- +----+----+
-- | x  | y  |
-- +----+----+
-- | -1 | -1 |
-- | 0  | 0  |
-- | -1 | -2 |
-- +----+----+
-- Output: 
-- +----------+
-- | shortest |
-- +----------+
-- | 1.00     |
-- +----------+
-- Explanation: The shortest distance is 1.00 from point (-1, -1) to (-1, 2).


DROP TABLE IF EXISTS Point2D;

CREATE TABLE Point2D (
    x INT,
    y INT,
    PRIMARY KEY (x, y)
);

INSERT INTO Point2D (x, y) VALUES
(-1, -1),
(0, 0),
(-1, -2);

sqrt((x2 - x1)2 + (y2 - y1)2).

SELECT 
    ROUND(
        MIN(
            SQRT(
                POWER(p2.x - p1.x, 2) + 
                POWER(p2.y - p1.y, 2)
            )
        ),
    2) AS shortest
FROM Point2D p1
JOIN Point2D p2
ON p1.x < p2.x OR (p1.x = p2.x AND p1.y < p2.y);

------------------------------------------------------------------------------------------------
-- m2

WITH cte AS (
    SELECT *, ROW_NUMBER() OVER() AS rnk
    FROM Point2D
)
SELECT 
    ROUND(
        MIN(
            SQRT(POWER(c1.x - c2.x, 2) + POWER(c1.y - c2.y, 2))
        ),
    2) AS shortest
FROM cte c1
JOIN cte c2
ON c1.rnk < c2.rnk;