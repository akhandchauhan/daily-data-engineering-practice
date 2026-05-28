-- 1440. Evaluate Boolean Expression
-- SQL Schema 
-- Table Variables:
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | name          | varchar |
-- | value         | int     |
-- +---------------+---------+
-- name is the primary key for this table.
-- This table contains the stored variables and their values.
-- Table Expressions:
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | left_operand  | varchar |
-- | operator      | enum    |
-- | right_operand | varchar |
-- +---------------+---------+
-- (left_operand, operator, right_operand) is the primary key for this table.
-- This table contains a boolean expression that should be evaluated.
-- operator is an enum that takes one of the values ('<', '>', '=')
-- The values of left_operand and right_operand are guaranteed to be in the Variables table.
-- Write an  SQL query to evaluate the boolean expressions in Expressions table.
-- Return the result table in any order.
-- Variables table:
-- +------+-------+
-- | name | value |
-- +------+-------+
-- | x    | 66    |
-- | y    | 77    |
-- +------+-------+
-- Expressions table:
-- +--------------+----------+---------------+
-- | left_operand | operator | right_operand |
-- +--------------+----------+---------------+
-- | x            | >        | y             |
-- | x            | <        | y             |
-- | x            | =        | y             |
-- | y            | >        | x             |
-- | y            | <        | x             |
-- | x            | =        | x             |
-- +--------------+----------+---------------+
-- Result table:
-- +--------------+----------+---------------+-------+
-- | left_operand | operator | right_operand | value |
-- +--------------+----------+---------------+-------+
-- | x            | >        | y             | false |
-- | x            | <        | y             | true  |
-- | x            | =        | y             | false |
-- | y            | >        | x             | true  |
-- | y            | <        | x             | false |
-- | x            | =        | x             | true  |
-- +--------------+----------+---------------+-------+
-- As shown, you need find the value of each boolean exprssion in the table using the variables table.


DROP TABLE Variables;
CREATE TABLE Variables (
    name VARCHAR(255) PRIMARY KEY,
    value INT
);

INSERT INTO Variables (name, value) VALUES ('x', 66);
INSERT INTO Variables (name, value) VALUES ('y', 77);

DROP TABLE Expressions;
CREATE TABLE Expressions (
    left_operand VARCHAR(255),
    operator ENUM('<', '>', '='),
    right_operand VARCHAR(255),
    PRIMARY KEY (left_operand, operator, right_operand)
);
INSERT INTO Expressions (left_operand, operator, right_operand) 
VALUES 
    ('x', '>', 'y'),
    ('x', '<', 'y'),
    ('x', '=', 'y'),
    ('y', '>', 'x'),
    ('y', '<', 'x'),
    ('x', '=', 'x');


   
-- my method not working
WITH cte as(
    SELECT left_operand,operator,right_operand,v1.value as value1,v2.value as value2
    FROM Expressions as e
    LEFT JOIN Variables as v1
    ON e.left_operand = v1.name 
    LEFT JOIN Variables as v2
    ON e.right_operand = v2.name
)
SELECT left_operand,operator,right_operand,CASE
        WHEN operator = '<' AND value1 < value2 THEN 'true'
        WHEN operator = '>' AND value1 > value2 THEN 'true'
        WHEN operator = '=' AND value1 = value2 THEN 'true'
        ELSE 'false'
    END AS value
FROM cte;

-------------------------------------------------------------------------------------------------
-- m2
SELECT
    left_operand,operator,right_operand,
    CASE WHEN (
            (operator = '=' AND v1.value = v2.value)
            OR (operator = '>' AND v1.value > v2.value)
            OR (operator = '<' AND v1.value < v2.value)
        ) THEN 'true'
        ELSE 'false'
    END AS value
FROM
    Expressions AS e
    JOIN Variables AS v1 ON e.left_operand = v1.name
    JOIN Variables AS v2 ON e.right_operand = v2.name;

-------------------------------------------------------------------------------------------------
-- m3

SELECT e.left_operand,
       e.operator,
       e.right_operand,
       CASE WHEN e.operator = '=' AND vl.value = rl.value THEN 'true'
       WHEN e.operator = '>' AND vl.value > rl.value THEN 'true'
       WHEN e.operator = '<' AND vl.value < rl.value THEN 'true' 
       ELSE 'false' END AS value
FROM Expressions e
JOIN Variables vl
ON vl.name = e.left_operand 
JOIN Variables rl
ON rl.name = e.right_operand ;
