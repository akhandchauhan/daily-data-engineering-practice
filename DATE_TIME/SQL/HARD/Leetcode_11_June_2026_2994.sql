-- 2994. Friday Purchases II

-- Table: Purchases
-- +---------------+------+
-- | Column Name   | Type |
-- +---------------+------+
-- | user_id       | int  |
-- | purchase_date | date |
-- | amount_spend  | int  |
-- +---------------+------+
-- (user_id, purchase_date, amount_spend) is the primary key
-- (combination of columns with unique values) for this table.
-- purchase_date will range from November 1, 2023, to November 30, 2023, inclusive of both dates.
-- Each row contains user id, purchase date, and amount spend.

-- Write a solution to calculate the total spending by users on each
-- Friday of every week in November 2023. If there are no purchases on a
-- particular Friday of a week, it will be considered as 0.

-- Return the result table ordered by week of month in ascending order.

-- Input:
-- Purchases table:
-- +---------+---------------+--------------+
-- | user_id | purchase_date | amount_spend |
-- +---------+---------------+--------------+
-- | 11      | 2023-11-07    | 1126         |
-- | 15      | 2023-11-30    | 7473         |
-- | 17      | 2023-11-14    | 2414         |
-- | 12      | 2023-11-24    | 9692         |
-- | 8       | 2023-11-03    | 5117         |
-- | 1       | 2023-11-16    | 5241         |
-- | 10      | 2023-11-12    | 8266         |
-- | 13      | 2023-11-24    | 12000        |
-- +---------+---------------+--------------+
-- Output:
-- +---------------+---------------+--------------+
-- | week_of_month | purchase_date | total_amount |
-- +---------------+---------------+--------------+
-- | 1             | 2023-11-03    | 5117         |
-- | 2             | 2023-11-10    | 0            |
-- | 3             | 2023-11-17    | 0            |
-- | 4             | 2023-11-24    | 21692        |
-- +---------------+---------------+--------------+
-- Explanation:
-- - During the first week of November 2023, transactions amounting to $5,117 occurred on
-- Friday, 2023-11-03.
-- - For the second week of November 2023, there were no transactions on Friday,
-- 2023-11-10, resulting in a value of 0 in the output table for that day.
-- - Similarly, during the third week of November 2023, there were no transactions
-- on Friday, 2023-11-17, reflected as 0 in the output table for that specific day.
-- - In the fourth week of November 2023, two transactions took place on Friday,
-- 2023-11-24, amounting to $12,000 and $9,692 respectively, summing up to a total of $21,692.
-- Output table is ordered by week_of_month in ascending order.

DROP TABLE IF EXISTS Purchases;

CREATE TABLE Purchases (
    user_id INT,
    purchase_date DATE,
    amount_spend INT
);

INSERT INTO Purchases (user_id, purchase_date, amount_spend) VALUES
(11, '2023-11-07', 1126),
(15, '2023-11-30', 7473),
(17, '2023-11-14', 2414),
(12, '2023-11-24', 9692),
(8,  '2023-11-03', 5117),
(1,  '2023-11-16', 5241),
(10, '2023-11-12', 8266),
(13, '2023-11-24', 12000);

WITH RECURSIVE date_generation_cte AS (
    SELECT '2023-11-01' AS dt
    UNION ALL
    SELECT DATE_ADD(dt, INTERVAL 1 DAY)
    FROM date_generation_cte
    WHERE dt < '2023-11-30'
),
month_info AS (
    SELECT
           dt AS purchase_date,
           CEIL(DAYOFMONTH(dt)/7) AS week_of_month
    FROM date_generation_cte
    WHERE DAYNAME(dt) = 'Friday'        -- ❌ locale-dependent; use DAYOFWEEK(dt) = 6
),
purchase_info AS (
    SELECT  purchase_date,
            SUM(amount_spend) AS total_amount
    FROM Purchases
    WHERE DAYNAME(purchase_date) = 'Friday'  -- ❌ redundant: JOIN with month_info already limits to Fridays
    GROUP BY
            purchase_date
)
SELECT
        mi.week_of_month,
        mi.purchase_date,
        COALESCE(pi.total_amount, 0) AS total_amount
FROM month_info mi
LEFT JOIN purchase_info pi
ON mi.purchase_date = pi.purchase_date
ORDER BY
        mi.week_of_month ;

--------------------------------------------------------------------------------
-- m2
WITH RECURSIVE T AS (
  SELECT '2023-11-01' AS purchase_date
  UNION ALL
  SELECT DATE_ADD(purchase_date, INTERVAL 1 DAY)
  FROM T
  WHERE purchase_date < '2023-11-30'
)
SELECT
  CEIL(DAYOFMONTH(purchase_date) / 7) AS week_of_month,
  purchase_date,
  IFNULL(SUM(amount_spend), 0)        AS total_amount
FROM T
LEFT JOIN Purchases USING (purchase_date)
WHERE DAYOFWEEK(purchase_date) = 6    -- ✓ integer comparison; locale-safe
GROUP BY purchase_date
ORDER BY week_of_month;
