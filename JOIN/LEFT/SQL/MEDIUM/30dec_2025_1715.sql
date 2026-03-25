1715. Count Apples and Oranges
-- Level
-- Medium
-- Description
-- Table: Boxes
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | box_id       | int  |
-- | chest_id     | int  |
-- | apple_count  | int  |
-- | orange_count | int  |
-- +--------------+------+
-- box_id is the primary key for this table.
-- chest_id is a foreign key of the chests table.
-- This table contains information about the boxes and the number of oranges and apples they contain.
-- Each box may contain a chest, which also can contain oranges and apples.
-- Table: Chests
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | chest_id     | int  |
-- | apple_count  | int  |
-- | orange_count | int  |
-- +--------------+------+
-- chest_id is the primary key for this table.
-- This table contains information about the chests we have, and the corresponding number if oranges and apples they contain.
-- Write an  SQL query to count the number of  apples and oranges in all the boxes.
-- If a box contains a chest, you should also include the number of apples and oranges it has.
-- Return the result table in any order.
-- The query result format is in the following example:
-- Boxes table:
-- +--------+----------+-------------+--------------+
-- | box_id | chest_id | apple_count | orange_count |
-- +--------+----------+-------------+--------------+
-- | 2      | null     | 6           | 15           |
-- | 18     | 14       | 4           | 15           |
-- | 19     | 3        | 8           | 4            |
-- | 12     | 2        | 19          | 20           |
-- | 20     | 6        | 12          | 9            |
-- | 8      | 6        | 9           | 9            |
-- | 3      | 14       | 16          | 7            |
-- +--------+----------+-------------+--------------+
-- Chests table:
-- +----------+-------------+--------------+
-- | chest_id | apple_count | orange_count |
-- +----------+-------------+--------------+
-- | 6        | 5           | 6            |
-- | 14       | 20          | 10           |
-- | 2        | 8           | 8            |
-- | 3        | 19          | 4            |
-- | 16       | 19          | 19           |
-- +----------+-------------+--------------+
-- Result table:
-- +-------------+--------------+
-- | apple_count | orange_count |
-- +-------------+--------------+
-- | 151         | 123          |
-- +-------------+--------------+


CREATE TABLE Chests (
    chest_id INT PRIMARY KEY,
    apple_count INT,
    orange_count INT
);

CREATE TABLE Boxes (
    box_id INT PRIMARY KEY,
    chest_id INT,
    apple_count INT,
    orange_count INT,
    FOREIGN KEY (chest_id) REFERENCES Chests(chest_id)
);


INSERT INTO Chests (chest_id, apple_count, orange_count) VALUES
(6, 5, 6),
(14, 20, 10),
(2, 8, 8),
(3, 19, 4),
(16, 19, 19);

INSERT INTO Boxes (box_id, chest_id, apple_count, orange_count) VALUES
(2, NULL, 6, 15),
(18, 14, 4, 15),
(19, 3, 8, 4),
(12, 2, 19, 20),
(20, 6, 12, 9),
(8, 6, 9, 9),
(3, 14, 16, 7);

-- m1

SELECT SUM(b.apple_count + IFNULL(c.apple_count, 0)) as apple_count,
       SUM(b.orange_count + IFNULL(c.orange_count,0)) as orange_count
FROM Boxes b 
LEFT JOIN Chests c     
ON b.chest_id = c.chest_id
;


-- m2 

SELECT
    SUM(apple_count) AS apple_count,
    SUM(orange_count) AS orange_count
FROM (
    -- Fruits directly in boxes
    SELECT
        apple_count,
        orange_count
    FROM Boxes

    UNION ALL
    -- Fruits in chests that are placed inside boxes
    SELECT
        c.apple_count,
        c.orange_count
    FROM Boxes b
    JOIN Chests c
        ON b.chest_id = c.chest_id
) t;
