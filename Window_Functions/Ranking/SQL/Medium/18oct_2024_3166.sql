-- 3166. Calculate Parking Fees and Duration
-- Description
-- Table: ParkingTransactions
-- +--------------+-----------+
-- | Column Name  | Type      |
-- +--------------+-----------+
-- | lot_id       | int       |
-- | car_id       | int       |
-- | entry_time   | datetime  |
-- | exit_time    | datetime  |
-- | fee_paid     | decimal   |
-- +--------------+-----------+
-- (lot_id, car_id, entry_time) is the primary key (combination of columns with unique values) for this
-- table.
-- Each row of this table contains the ID of the parking lot, the ID of the car, the entry and exit times,
-- and the fee paid for the parking duration.
-- Write a solution to find the total parking fee paid by each car across all parking lots, and the
-- average hourly fee (rounded to 2 decimal places) paid by each car. Also, find the parking lot where
-- each car spent the most total time.
-- Return the result table ordered by car_id in ascending order.
-- Note: Test cases are generated in such a way that an individual car cannot be in multiple 
--parking lots at the same time.
-- ParkingTransactions table:
-- +--------+--------+---------------------+---------------------+----------+
-- | lot_id | car_id | entry_time          | exit_time           | fee_paid |
-- +--------+--------+---------------------+---------------------+----------+
-- | 1      | 1001   | 2023-06-01 08:00:00 | 2023-06-01 10:30:00 | 5.00     |
-- | 1      | 1001   | 2023-06-02 11:00:00 | 2023-06-02 12:45:00 | 3.00     |
-- | 2      | 1001   | 2023-06-01 10:45:00 | 2023-06-01 12:00:00 | 6.00     |
-- | 2      | 1002   | 2023-06-01 09:00:00 | 2023-06-01 11:30:00 | 4.00     |
-- | 3      | 1001   | 2023-06-03 07:00:00 | 2023-06-03 09:00:00 | 4.00     |
-- | 3      | 1002   | 2023-06-02 12:00:00 | 2023-06-02 14:00:00 | 2.00     |
-- +--------+--------+---------------------+---------------------+----------+
-- Output:
-- --------+----------------+----------------+---------------+
-- | car_id | total_fee_paid | avg_hourly_fee | most_time_lot |
-- +--------+----------------+----------------+---------------+
-- | 1001   | 18.00          | 2.40           | 1             |
-- | 1002   | 6.00           | 1.33           | 2             |
-- +--------+----------------+----------------+---------------+
-- Explanation:
-- For car ID 1001:
-- From 2023-06-01 08:00:00 to 2023-06-01 10:30:00 in lot 1: 2.5 hours, fee 5.00
-- From 2023-06-02 11:00:00 to 2023-06-02 12:45:00 in lot 1: 1.75 hours, fee 3.00
-- From 2023-06-01 10:45:00 to 2023-06-01 12:00:00 in lot 2: 1.25 hours, fee 6.00
-- From 2023-06-03 07:00:00 to 2023-06-03 09:00:00 in lot 3: 2 hours, fee 4.00
-- Total fee paid: 18.00, total hours: 7.5, average hourly fee: 2.40, most time spent in lot 1: 4.25 hours.
-- For car ID 1002:
-- From 2023-06-01 09:00:00 to 2023-06-01 11:30:00 in lot 2: 2.5 hours, fee 4.00
-- From 2023-06-02 12:00:00 to 2023-06-02 14:00:00 in lot 3: 2 hours, fee 2.00
-- Total fee paid: 6.00, total hours: 4.5, average hourly fee: 1.33, most time spent in lot 2: 2.5 hours.
-- Note: Output table is ordered by car_id in ascending order.


CREATE TABLE If not exists ParkingTransactions (
    lot_id INT,
    car_id INT,
    entry_time DATETIME,
    exit_time DATETIME,
    fee_paid DECIMAL(10, 2)
);

Truncate table ParkingTransactions;

INSERT INTO ParkingTransactions (lot_id, car_id, entry_time, exit_time, fee_paid) VALUES
(1, 1001, '2023-06-01 08:00:00', '2023-06-01 10:30:00', 5.0),
(1, 1001, '2023-06-02 11:00:00', '2023-06-02 12:45:00', 3.0),
(2, 1001, '2023-06-01 10:45:00', '2023-06-01 12:00:00', 6.0),
(2, 1002, '2023-06-01 09:00:00', '2023-06-01 11:30:00', 4.0),
(3, 1001, '2023-06-03 07:00:00', '2023-06-03 09:00:00', 4.0),
(3, 1002, '2023-06-02 12:00:00', '2023-06-02 14:00:00', 2.0);

WITH T AS (
        SELECT car_id, lot_id,
            SUM(TIMESTAMPDIFF(SECOND, entry_time, exit_time)) AS duration
        FROM ParkingTransactions
        GROUP BY 1, 2
    ),
    P AS (
        SELECT *,
            RANK() OVER (PARTITION BY car_id ORDER BY duration DESC) AS rk
        FROM T
    )
SELECT t1.car_id, SUM(fee_paid) AS total_fee_paid,
    ROUND(SUM(fee_paid) / (SUM(TIMESTAMPDIFF(SECOND, entry_time, exit_time)) / 3600),2) AS avg_hourly_fee,
    t2.lot_id AS most_time_lot
FROM ParkingTransactions AS t1
LEFT JOIN P AS t2 
ON t1.car_id = t2.car_id AND t2.rk = 1
GROUP BY 1
ORDER BY 1;

------------------------------------------------------------------------------------------------------

-- m2
WITH car_parking_info AS (
    SELECT 
            lot_id,
            car_id,
            SUM(TIMESTAMPDIFF(minute,entry_time, exit_time))/60 AS time_parked,
            SUM(fee_paid) AS fee_paid
    FROM ParkingTransactions 
    GROUP BY lot_id, 
            car_id 
),
most_time_spend AS (
    SELECT 
            car_id,
            lot_id AS most_time_lot,
            ROW_NUMBER() OVER(PARTITION BY car_id ORDER BY time_parked DESC) AS car_rank
    FROM car_parking_info
)
SELECT 
        cpi.car_id,
        ROUND(SUM(cpi.fee_paid), 2) AS total_fee_paid,
        ROUND(SUM(cpi.fee_paid)/SUM(cpi.time_parked), 2)  AS avg_hourly_fee,
        mts.most_time_lot
FROM car_parking_info cpi 
JOIN most_time_spend mts 
ON cpi.car_id = mts.car_id
AND mts.car_rank = 1
GROUP BY cpi.car_id,
         mts.most_time_lot
ORDER BY cpi.car_id ;

------------------------------------------------------------------------------------------------------

-- m3
WITH base AS (
    SELECT 
        car_id,
        lot_id,
        SUM(TIMESTAMPDIFF(SECOND, entry_time, exit_time)) AS total_seconds,
        SUM(fee_paid) AS total_fee
    FROM ParkingTransactions
    GROUP BY car_id, lot_id
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY car_id ORDER BY total_seconds DESC) AS rn
    FROM base
),
car_total AS (
    SELECT 
        car_id,
        SUM(total_fee) AS total_fee_paid,
        SUM(total_seconds) AS total_seconds
    FROM base
    GROUP BY car_id
)
SELECT 
    ct.car_id,
    ct.total_fee_paid,
    ROUND(ct.total_fee_paid / (ct.total_seconds / 3600), 2) AS avg_hourly_fee,
    r.lot_id AS most_time_lot
FROM car_total ct
JOIN ranked r 
ON ct.car_id = r.car_id AND r.rn = 1
ORDER BY ct.car_id;