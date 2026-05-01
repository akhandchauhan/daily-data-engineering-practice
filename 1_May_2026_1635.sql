-- 1635. Hopper Company Queries I

-- Table: Drivers
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | driver_id   | int     |
-- | join_date   | date    |
-- +-------------+---------+
-- driver_id is the primary key for this table.
-- Each row of this table contains the driver's ID 
-- and the date they joined the Hopper company.

-- Table: Rides
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | ride_id      | int     |
-- | user_id      | int     |
-- | requested_at | date    |
-- +--------------+---------+
-- ride_id is the primary key for this table.
-- Each row of this table contains the ID of a ride, the user's ID that 
-- requested it, and the day they requested it.
-- There may be some ride requests in this table that were not accepted.

-- Table: AcceptedRides
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | ride_id       | int     |
-- | driver_id     | int     |
-- | ride_distance | int     |
-- | ride_duration | int     |
-- +---------------+---------+
-- ride_id is the primary key for this table.
-- Each row of this table contains some information about an accepted ride.
-- It is guaranteed that each accepted ride exists in the Rides table.

-- Write an SQL query to report the following statistics for each month of 2020:

-- The number of drivers currently with the Hopper company by the end of the month (active_drivers).
-- The number of accepted rides in that month (accepted_rides).
-- Return the result table ordered by month in ascending order, where month is the 
-- month's number (January is 1, February is 2, etc.).

-- Drivers table:
-- +-----------+------------+
-- | driver_id | join_date  |
-- +-----------+------------+
-- | 10        | 2019-12-10 |
-- | 8         | 2020-1-13  |
-- | 5         | 2020-2-16  |
-- | 7         | 2020-3-8   |
-- | 4         | 2020-5-17  |
-- | 1         | 2020-10-24 |
-- | 6         | 2021-1-5   |
-- +-----------+------------+
 -- Active driver for that month = join_date <= month_end_date 
-- Rides table:
-- +---------+---------+--------------+
-- | ride_id | user_id | requested_at |
-- +---------+---------+--------------+
-- | 6       | 75      | 2019-12-9    |
-- | 1       | 54      | 2020-2-9     |
-- | 10      | 63      | 2020-3-4     |
-- | 19      | 39      | 2020-4-6     |
-- | 3       | 41      | 2020-6-3     |
-- | 13      | 52      | 2020-6-22    |
-- | 7       | 69      | 2020-7-16    |
-- | 17      | 70      | 2020-8-25    |
-- | 20      | 81      | 2020-11-2    |
-- | 5       | 57      | 2020-11-9    |
-- | 2       | 42      | 2020-12-9    |
-- | 11      | 68      | 2021-1-11    |
-- | 15      | 32      | 2021-1-17    |
-- | 12      | 11      | 2021-1-19    |
-- | 14      | 18      | 2021-1-27    |
-- +---------+---------+--------------+

-- AcceptedRides table:
-- +---------+-----------+---------------+---------------+
-- | ride_id | driver_id | ride_distance | ride_duration |
-- +---------+-----------+---------------+---------------+
-- | 10      | 10        | 63            | 38            |
-- | 13      | 10        | 73            | 96            |
-- | 7       | 8         | 100           | 28            |
-- | 17      | 7         | 119           | 68            |
-- | 20      | 1         | 121           | 92            |
-- | 5       | 7         | 42            | 101           |
-- | 2       | 4         | 6             | 38            |
-- | 11      | 8         | 37            | 43            |
-- | 15      | 8         | 108           | 82            |
-- | 12      | 8         | 38            | 34            |
-- | 14      | 1         | 90            | 74            |
-- +---------+-----------+---------------+---------------+

-- Result table:
-- +-------+----------------+----------------+
-- | month | active_drivers | accepted_rides |
-- +-------+----------------+----------------+
-- | 1     | 2              | 0              |
-- | 2     | 3              | 0              |
-- | 3     | 4              | 1              |
-- | 4     | 4              | 0              |
-- | 5     | 5              | 0              |
-- | 6     | 5              | 1              |
-- | 7     | 5              | 1              |
-- | 8     | 5              | 1              |
-- | 9     | 5              | 0              |
-- | 10    | 6              | 0              |
-- | 11    | 6              | 2              |
-- | 12    | 6              | 1              |
-- +-------+----------------+----------------+

-- By the end of January --> two active drivers (10, 8) and no accepted rides.
-- By the end of February --> three active drivers (10, 8, 5) and no accepted rides.
-- By the end of March --> four active drivers (10, 8, 5, 7) and one accepted ride (10).
-- By the end of April --> four active drivers (10, 8, 5, 7) and no accepted rides.
-- By the end of May --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
-- By the end of June --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (13).
-- By the end of July --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (7).
-- By the end of August --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (17).
-- By the end of Septemeber --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
-- By the end of October --> six active drivers (10, 8, 5, 7, 4, 1) and no accepted rides.
-- By the end of November --> six active drivers (10, 8, 5, 7, 4, 1) and two accepted rides (20, 5).
-- By the end of December --> six active drivers (10, 8, 5, 7, 4, 1) and one accepted ride (2).



-- DROP TABLES
DROP TABLE IF EXISTS AcceptedRides;
DROP TABLE IF EXISTS Rides;
DROP TABLE IF EXISTS Drivers;

-- CREATE TABLES
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY,
    join_date DATE
);

CREATE TABLE Rides (
    ride_id INT PRIMARY KEY,
    user_id INT,
    requested_at DATE
);

CREATE TABLE AcceptedRides (
    ride_id INT PRIMARY KEY,
    driver_id INT,
    ride_distance INT,
    ride_duration INT
);

-- INSERT DATA INTO Drivers
INSERT INTO Drivers (driver_id, join_date) VALUES
(10, '2019-12-10'),
(8, '2020-01-13'),
(5, '2020-02-16'),
(7, '2020-03-08'),
(4, '2020-05-17'),
(1, '2020-10-24'),
(6, '2021-01-05');

-- INSERT DATA INTO Rides
INSERT INTO Rides (ride_id, user_id, requested_at) VALUES
(6, 75, '2019-12-09'),
(1, 54, '2020-02-09'),
(10, 63, '2020-03-04'),
(19, 39, '2020-04-06'),
(3, 41, '2020-06-03'),
(13, 52, '2020-06-22'),
(7, 69, '2020-07-16'),
(17, 70, '2020-08-25'),
(20, 81, '2020-11-02'),
(5, 57, '2020-11-09'),
(2, 42, '2020-12-09'),
(11, 68, '2021-01-11'),
(15, 32, '2021-01-17'),
(12, 11, '2021-01-19'),
(14, 18, '2021-01-27');

-- INSERT DATA INTO AcceptedRides
INSERT INTO AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) VALUES
(10, 10, 63, 38),
(13, 10, 73, 96),
(7, 8, 100, 28),
(17, 7, 119, 68),
(20, 1, 121, 92),
(5, 7, 42, 101),
(2, 4, 6, 38),
(11, 8, 37, 43),
(15, 8, 108, 82),
(12, 8, 38, 34),
(14, 1, 90, 74);

WITH RECURSIVE month_cte AS (
    SELECT 1 AS month 
    UNION ALL
    SELECT month + 1
    FROM month_cte
    WHERE month < 12
),
active_driver_info AS (
    SELECT 
        mc.month,
        COUNT(join_date) AS active_drivers
    FROM month_cte mc 
    JOIN drivers d 
    ON d.join_date <= LAST_DAY(CONCAT('2020-', mc.month, '-01'))
    GROUP BY mc.month
),
accepted_rider_info AS (
    SELECT 
        MONTH(r.requested_at) AS month,
        COUNT(ar.ride_id) AS accepted_rides
    FROM rides r 
    LEFT JOIN acceptedrides ar 
    ON r.ride_id = ar.ride_id
    WHERE  YEAR(r.requested_at) = 2020
    GROUP BY  MONTH(r.requested_at)
)
SELECT 
    adi.month,
    adi.active_drivers,
    COALESCE(ari.accepted_rides, 0) AS accepted_rides
FROM active_driver_info adi 
LEFT JOIN accepted_rider_info ari 
ON adi.month = ari.month
ORDER BY adi.month;