-- 1384. Total Sales Amount by Year
-- SQL Schema 
-- Table: Product
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- product_id is the primary key for this table.
-- product_name is the name of the product.

-- Table: Sales
-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | product_id          | int     |
-- | period_start        | varchar |
-- | period_end          | date    |
-- | average_daily_sales | int     |
-- +---------------------+---------+
-- product_id is the primary key for this table.
-- period_start and period_end indicates the start and end date for sales period,
-- both dates are inclusive.
-- The average_daily_sales column holds the average daily sales amount of the 
-- items for the period.

-- Write an SQL query to report the Total sales amount of each item for each year,
-- with corresponding product name, product_id, product_name and report_year.
-- Dates of the sales years are between 2018 to 2020. Return the result 
-- table ordered by product_id  and report_year.

-- Product table:
-- +------------+--------------+
-- | product_id | product_name |
-- +------------+--------------+
-- | 1          | LC Phone     |
-- | 2          | LC T-Shirt   |
-- | 3          | LC Keychain  |
-- +------------+--------------+
-- Sales table:
-- +------------+--------------+-------------+---------------------+
-- | product_id | period_start | period_end  | average_daily_sales |
-- +------------+--------------+-------------+---------------------+
-- | 1          | 2019-01-25   | 2019-02-28  | 100                 |
-- | 2          | 2018-12-01   | 2020-01-01  | 10                  |
-- | 3          | 2019-12-01   | 2020-01-31  | 1                   |
-- +------------+--------------+-------------+---------------------+
-- Result table:
-- +------------+--------------+-------------+--------------+
-- | product_id | product_name | report_year | total_amount |
-- +------------+--------------+-------------+--------------+
-- | 1          | LC Phone     |    2019     | 3500         |
-- | 2          | LC T-Shirt   |    2018     | 310          |
-- | 2          | LC T-Shirt   |    2019     | 3650         |
-- | 2          | LC T-Shirt   |    2020     | 10           |
-- | 3          | LC Keychain  |    2019     | 31           |
-- | 3          | LC Keychain  |    2020     | 31           |
-- +------------+--------------+-------------+--------------+
-- LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there 
-- are 35 days for this period. Total amount 35*100 = 3500. 
-- LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, 
-- and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
-- LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there 
-- are 31, 31 days for years 2019 and 2020 respectively.

DROP TABLE Product;
DROP TABLE Sales;
-- Create Product table
CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

-- Create Sales table
CREATE TABLE Sales (
    product_id INT,
    period_start VARCHAR(10),
    period_end DATE,
    average_daily_sales INT,
    PRIMARY KEY (product_id, period_start, period_end)
);

-- Insert data into Product table
INSERT INTO Product (product_id, product_name) VALUES
(1, 'LC Phone'),
(2, 'LC T-Shirt'),
(3, 'LC Keychain');

-- Insert data into Sales table
INSERT INTO Sales (product_id, period_start, period_end, average_daily_sales) VALUES
(1, '2019-01-25', '2019-02-28', 100),
(2, '2018-12-01', '2020-01-01', 10),
(3, '2019-12-01', '2020-01-31', 1);


--m1 not working = dont consider in evaluation
WITH RECURSIVE cte as(
    SELECT product_id, year(period_start) as first_year,year(period_end) as last_year
    FROM Sales
    UNION ALL
    SELECT product_id, first_year+1,last_year
    FROM cte
    WHERE first_year < last_year
)
SELECT c.product_id, p.product_name,c.first_year as report_year,
    DATEDIFF(period_end,period_start) * average_daily_sales
FROM cte as c 
JOIN Product as p 
ON c.product_id = p.product_id
JOIN sales as s 
ON c.product_id = s.product_id;

-------------------------------------------------------------------------------------
--m2 ankit bansal
WITH RECURSIVE cte AS (
    SELECT 
        product_id,
        period_start AS curr_date,
        period_end
    FROM sales
    UNION ALL
    SELECT 
        product_id,
        DATE_ADD(curr_date, INTERVAL 1 DAY),
        period_end
    FROM cte
    WHERE curr_date < period_end
)
SELECT
    p.product_id,
    p.product_name,
    YEAR(c.curr_date) AS reporting_year,
    SUM(s.average_daily_sales) AS total_amount

FROM Product p 
LEFT JOIN cte c 
    ON p.product_id = c.product_id
LEFT JOIN sales s 
    ON s.product_id = c.product_id
   AND c.curr_date BETWEEN s.period_start AND s.period_end
GROUP BY 
    p.product_id,
    p.product_name,
    YEAR(c.curr_date)
ORDER BY 
    p.product_id,
    reporting_year;

-----------------------------------------------------------------------------------------
-- m3
WITH RECURSIVE product_cte AS (
    SELECT 
        product_id,
        YEAR(period_start) AS start_year,
        YEAR(period_end) AS end_year
    FROM Sales
    UNION ALL 
    SELECT 
        product_id, 
        start_year + 1,
        end_year
    FROM product_cte 
    WHERE start_year < end_year
)
SELECT 
    p.product_id,
    p.product_name,
    pc.start_year AS report_year,
    s.average_daily_sales * 
    CASE 
        -- same year
        WHEN pc.start_year = YEAR(s.period_start) 
         AND pc.start_year = YEAR(s.period_end)
        THEN DATEDIFF(s.period_end, s.period_start) + 1
        -- first year
        WHEN pc.start_year = YEAR(s.period_start)
        THEN DATEDIFF(
                STR_TO_DATE(CONCAT(pc.start_year,'-12-31'), '%Y-%m-%d'),
                s.period_start
             ) + 1
        -- middle year
        WHEN pc.start_year != YEAR(s.period_start) 
         AND pc.start_year != YEAR(s.period_end)
        THEN 
            CASE 
                WHEN (pc.start_year % 4 = 0 AND pc.start_year % 100 != 0) 
                     OR (pc.start_year % 400 = 0)
                THEN 366
                ELSE 365
            END
        -- last year
        WHEN pc.start_year = YEAR(s.period_end)
        THEN DATEDIFF(
                s.period_end,
                STR_TO_DATE(CONCAT(pc.start_year,'-01-01'), '%Y-%m-%d')
             ) + 1
    END AS total_amount
FROM Product p 
LEFT JOIN product_cte pc 
    ON p.product_id = pc.product_id
LEFT JOIN Sales s
    ON p.product_id = s.product_id
ORDER BY p.product_id,
         pc.start_year;

---------------------------------------------------------------------------------------
-- m4
WITH RECURSIVE years AS (
    SELECT product_id,
           YEAR(period_start) AS yr,
           YEAR(period_end) AS end_yr,
           period_start,
           period_end,
           average_daily_sales
    FROM Sales
    UNION ALL
    SELECT product_id,
           yr + 1,
           end_yr,
           period_start,
           period_end,
           average_daily_sales
    FROM years
    WHERE yr < end_yr
)
SELECT 
    y.product_id,
    p.product_name,
    y.yr AS report_year,
    (
        DATEDIFF(
            LEAST(y.period_end, STR_TO_DATE(CONCAT(y.yr,'-12-31'), '%Y-%m-%d')),
            GREATEST(y.period_start, STR_TO_DATE(CONCAT(y.yr,'-01-01'), '%Y-%m-%d'))
        ) + 1
    ) * y.average_daily_sales AS total_amount

FROM years y
JOIN Product p
ON y.product_id = p.product_id
ORDER BY y.product_id, report_year;