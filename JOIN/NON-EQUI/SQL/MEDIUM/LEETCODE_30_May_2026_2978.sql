-- 2978. Symmetric Coordinates

-- Table: Coordinates
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | X           | int  |
-- | Y           | int  |
-- +-------------+------+
-- Each row includes X and Y, where both are integers. Table may contain duplicate 
-- values.
-- Two coordindates (X1, Y1) and (X2, Y2) are said to be symmetric coordintes 
-- if X1 == Y2 and X2 == Y1.

-- Write a solution that outputs, among all these symmetric coordintes, 
-- only those unique coordinates that satisfy the condition X1 <= Y1.

-- Return the result table ordered by X and Y (respectively) in ascending order.

-- Example 1:

-- Coordinates table:
-- +----+----+
-- | X  | Y  |
-- +----+----+
-- | 20 | 20 |
-- | 20 | 20 |
-- | 20 | 21 |
-- | 23 | 22 |
-- | 22 | 23 |
-- | 21 | 20 |
-- +----+----+
-- Output: 
-- +----+----+
-- | x  | y  |
-- +----+----+
-- | 20 | 20 |
-- | 20 | 21 |
-- | 22 | 23 |
-- +----+----+
-- Explanation: 
-- - (20, 20) and (20, 20) are symmetric coordinates because, X1 == Y2 and X2 == Y1. 
-- This results in displaying (20, 20) as a distinctive coordinates.
-- - (20, 21) and (21, 20) are symmetric coordinates because, X1 == Y2 and 
-- X2 == Y1. However, only (20, 21) will be displayed because X1 <= Y1.
-- - (23, 22) and (22, 23) are symmetric coordinates because, X1 == Y2 and X2 == Y1.
-- However, only (22, 23) will be displayed because X1 <= Y1.
-- The output table is sorted by X and Y in ascending order.

DROP TABLE IF EXISTS Coordinates;

CREATE TABLE Coordinates (
    X INT,
    Y INT
);

INSERT INTO Coordinates (X, Y) VALUES
(20, 20),
(20, 20),
(20, 21),
(23, 22),
(22, 23),
(21, 20);

-- m1 misses edge cage of single point 
SELECT DISTINCT 
            c1.x,
            c1.y
FROM Coordinates c1
JOIN coordinates c2
ON c1.x = c2.y
AND c1.y = c2.x
WHERE c1.x <= c1.y 
ORDER BY 
            c1.x,
            c1.y;

---------------------------------------------------------------------------------
-- m2 (handles lone diagonal points)
WITH cte AS (
    SELECT X, Y, 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM Coordinates
)
SELECT DISTINCT c1.X, c1.Y
FROM cte c1
JOIN cte c2
    ON c1.X = c2.Y
    AND c1.Y = c2.X
    AND c1.rn <> c2.rn      -- the key: must be two *different* rows
WHERE c1.X <= c1.Y
ORDER BY c1.X, c1.Y;
