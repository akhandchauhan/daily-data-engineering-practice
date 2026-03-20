-- 3166. Calculate Parking Fees and Duration 
-- Description
-- Table: ParkingTransactions

-- +--+--+
-- \| lot_id       \| int       \|
-- \| car_id       \| int       \|
-- \| entry_time   \| datetime  \|
-- \| exit_time    \| datetime  \|
-- \| fee_paid     \| decimal   \|
-- +--++-+
-- \| lot_id \| car_id \| entry_time          \| exit_time           \| fee_paid \|
-- +--+--+++-+
-- Output:

-- +--+-+-++
-- \| 1001   \| 18.00          \| 2.40           \| 1             \|
-- \| 1002   \| 6.00           \| 1.33           \| 2             \|
-- +--+-+---+
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
insert into ParkingTransactions (lot_id, car_id, entry_time, exit_time, fee_paid) values ('1', '1001', '2023-06-01 08:00:00', '2023-06-01 10:30:00', '5.0');
insert into ParkingTransactions (lot_id, car_id, entry_time, exit_time, fee_paid) values ('1', '1001', '2023-06-02 11:00:00', '2023-06-02 12:45:00', '3.0');
insert into ParkingTransactions (lot_id, car_id, entry_time, exit_time, fee_paid) values ('2', '1001', '2023-06-01 10:45:00', '2023-06-01 12:00:00', '6.0');
insert into ParkingTransactions (lot_id, car_id, entry_time, exit_time, fee_paid) values ('2', '1002', '2023-06-01 09:00:00', '2023-06-01 11:30:00', '4.0');
insert into ParkingTransactions (lot_id, car_id, entry_time, exit_time, fee_paid) values ('3', '1001', '2023-06-03 07:00:00', '2023-06-03 09:00:00', '4.0');
insert into ParkingTransactions (lot_id, car_id, entry_time, exit_time, fee_paid) values ('3', '1002', '2023-06-02 12:00:00', '2023-06-02 14:00:00', '2.0');

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
