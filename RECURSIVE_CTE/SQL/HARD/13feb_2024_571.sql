-- 571. Find Median Given Frequency of Numbers 🔒
-- Table: Numbers
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | num         | int  |
-- | frequency   | int  |
-- +-------------+------+
-- num is the primary key (column with unique values) for this table.
-- Each row of this table shows the frequency of a number in the database.
-- The median is the value separating the higher half from the lower half of a data sample.
-- Write a solution to report the median of all the numbers in the database after decompressing
-- the Numbers table. Round the median to one decimal point.
-- Numbers table:
-- +-----+-----------+
-- | num | frequency |
-- +-----+-----------+
-- | 0   | 7         |
-- | 1   | 1         |
-- | 2   | 3         |
-- | 3   | 1         |
-- +-----+-----------+
-- Output:
-- +--------+
-- | median |
-- +--------+
-- | 0.0    |
-- +--------+
-- Explanation:
-- If we decompress the Numbers table, we will get [0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3],
-- so the median is (0 + 0) / 2 = 0.

Create table If Not Exists Numbers (num int, frequency int);
Truncate table Numbers;
insert into Numbers (num, frequency) values ('0', '7');
insert into Numbers (num, frequency) values ('1', '1');
insert into Numbers (num, frequency) values ('2', '3');
insert into Numbers (num, frequency) values ('3', '1');

WITH RECURSIVE cte AS (
    SELECT num, frequency FROM Numbers
    UNION ALL
    SELECT num, frequency - 1
    FROM cte
    WHERE frequency > 1
),
cte2 AS (
    SELECT num, ROW_NUMBER() OVER (ORDER BY num) AS rnk,
           COUNT(*) OVER () AS total_count
    FROM cte
)
SELECT num
FROM cte2
WHERE rnk = (total_count + 1) / 2 OR
      (total_count % 2 = 0 AND rnk = (total_count / 2) + 1);
