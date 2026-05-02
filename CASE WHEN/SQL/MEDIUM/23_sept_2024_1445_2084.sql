-- 1445. Apples & Oranges
-- Description
-- Table: Sales
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | sale_date     | date    |
-- | fruit         | enum    | 
-- | sold_num      | int     | 
-- +---------------+---------+
-- (sale_date, fruit) is the primary key (combination of columns with unique values) of this table.
-- This table contains the sales of "apples" and "oranges" sold each day.
-- Write a solution to report the difference between the number of  apples and  oranges sold each day.
-- Return the result table ordered by sale_date.
-- Inpt: 
-- Sales table:
-- +------------+------------+-------------+
-- | sale_date  | fruit      | sold_num    |
-- +------------+------------+-------------+
-- | 2020-05-01 | apples     | 10          |
-- | 2020-05-01 | oranges    | 8           |
-- | 2020-05-02 | apples     | 15          |
-- | 2020-05-02 | oranges    | 15          |
-- | 2020-05-03 | apples     | 20          |
-- | 2020-05-03 | oranges    | 0           |
-- | 2020-05-04 | apples     | 15          |
-- | 2020-05-04 | oranges    | 16          |
-- +------------+------------+-------------+
-- Output: 
-- +------------+--------------+
-- | sale_date  | diff         |
-- +------------+--------------+
-- | 2020-05-01 | 2            |
-- | 2020-05-02 | 0            |
-- | 2020-05-03 | 20           |
-- | 2020-05-04 | -1           |
-- +------------+--------------+
-- Explanation: 
-- Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
-- Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
-- Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
-- Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).


drop table Sales;
CREATE TABLE Sales (
    sale_date DATE,
    fruit ENUM('apples', 'oranges'),
    sold_num INT,
    PRIMARY KEY (sale_date, fruit)
);

INSERT INTO Sales (sale_date, fruit, sold_num) VALUES
('2020-05-01', 'apples', 10),
('2020-05-01', 'oranges', 8),
('2020-05-02', 'apples', 15),
('2020-05-02', 'oranges', 15),
('2020-05-03', 'apples', 20),
('2020-05-03', 'oranges', 0),
('2020-05-04', 'apples', 15),
('2020-05-04', 'oranges', 16);

--m1 
WITH cte as(
SELECT *, LEAD(sold_num) OVER(PARTITION BY sale_date ORDER BY sale_date) as nxt_num
FROM Sales
)
SELECT sale_date, sold_num-nxt_num as diff
FROM cte
WHERE fruit = 'apples'
ORDER BY 1;

-- m2
WITH cte as(
    SELECT sale_date,CASE WHEN fruit='apples' Then sold_num ELSE -sold_num end as value
    FROM Sales
)
SELECT sale_date,SUM(value) AS diff
FROM cte
GROUP BY sale_date
ORDER BY 1;

-- m3
SELECT sale_date,
    SUM(IF(fruit = 'apples', sold_num, -sold_num)) AS diff
FROM Sales
GROUP BY 1
ORDER BY 1;

-- m4
WITH cte as(
SELECT sale_date,SUM(CASE WHEN fruit = 'apples' THEN sold_num ELSE 0 end)  as apple_cnt,
SUM(CASE WHEN fruit = 'oranges' THEN sold_num ELSE 0 end)  as orange_cnt
FROM Sales
GROUP BY sale_date
)
SELECT sale_date, apple_cnt - orange_cnt as diff
FROM cte
ORDER BY sale_date;

-- m5
SELECT sale_date,SUM(IF(fruit = 'apples',sold_num, 0)) - SUM(IF(fruit = 'oranges',sold_num, 0)) as diff
FROM Sales
GROUP BY sale_date
ORDER BY sale_date;

-- m6
WITH fruit_info as (
    SELECT sale_date,
        fruit,
        sold_num,
        LEAD(fruit) OVER(PARTITION BY sale_date ORDER BY fruit) as nxt_fruit,
        LEAD(sold_num) OVER(PARTITION BY sale_date ORDER BY fruit) as nxt_sold_num
    FROM Sales
)
SELECT sale_date,nxt_sold_num - sold_num as diff
FROM fruit_info 
WHERE fruit = 'apples' and nxt_fruit = 'oranges'
ORDER BY sale_date


--m7
SELECT a.sale_date, b.sold_num - a.sold_num as diff
FROM (SELECT *
FROM Sales
WHERE fruit = 'apples'
) a
JOIN (SELECT *
    FROM Sales 
    WHERE fruit = 'oranges'
) b
ON a.sale_date = b.sale_date
ORDER BY a.sale_date
